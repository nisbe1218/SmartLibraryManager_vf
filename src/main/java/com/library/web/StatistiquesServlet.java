package com.library.web;

import com.google.gson.Gson;
import com.library.dao.EmpruntDao;
import com.library.dao.LivreDao;
import com.library.dao.LecteurDao;
import com.library.model.Emprunt;
import com.library.model.Livre;
import com.library.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * SERVLET : StatistiquesServlet
 * RÔLE : Générer et afficher les statistiques de la bibliothèque
 * 
 * FONCTIONNALITÉS :
 * - GET  : Afficher la page des statistiques avec graphiques et tableaux
 * - POST : Fournir les données JSON pour les graphiques
 * 
 * STATISTIQUES GÉNÉRÉES :
 * - Livres les plus empruntés (top 10)
 * - Lecteurs les plus actifs
 * - Évolution des emprunts par mois
 * - Taux de disponibilité des livres
 * - Emprunts en cours vs terminés
 * - Retards et livres non rendus
 * 
 * FORMAT RÉPONSE POST :
 * - JSON pour alimenter les graphiques JavaScript (Chart.js)
 * 
 * URL : /statistiques
 * PAGE JSP : statistiques.jsp
 * ACCÈS : Bibliothécaires uniquement
 */
import java.util.stream.Collectors;

@WebServlet("/statistiques")
public class StatistiquesServlet extends HttpServlet {

    // DAOs pour accéder aux données de la base
    private EmpruntDao empruntDao = new EmpruntDao();   // Accès aux emprunts
    private LivreDao livreDao = new LivreDao();         // Accès aux livres
    private LecteurDao lecteurDao = new LecteurDao();   // Accès aux lecteurs


     //Méthode GET : Afficher la page des statistiques ou renvoyer des données

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Vérifier si une session existe et si l'utilisateur est connecté
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            // Rediriger vers la page de connexion si non connecté
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Récupérer l'utilisateur connecté depuis la session
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

        // Vérifier que l'utilisateur est un bibliothécaire (sécurité)
        if (utilisateur == null || !utilisateur.isBibliothecaire()) {
            // Rediriger vers le dashboard approprié si ce n'est pas un bibliothécaire
            response.sendRedirect(request.getContextPath() + dashboardFor(utilisateur));
            return;
        }

        // Récupérer le paramètre "action" pour déterminer quelle opération effectuer
        String action = request.getParameter("action");
        
        // Traiter l'action demandée
        if ("api".equals(action)) {
            // Renvoyer les statistiques au format JSON pour les graphiques
            sendStatsJson(response);
        } else if ("export-excel".equals(action)) {
            // Exporter les données au format CSV (Excel)
            exportExcel(response);
        } else if ("export-pdf".equals(action)) {
            // Générer un rapport HTML (pour PDF)
            exportPDF(response);
        } else {
            // Afficher la page JSP des statistiques (action par défaut)
            request.getRequestDispatcher("/pages/statistiques.jsp").forward(request, response);
        }
    }

    private String dashboardFor(Utilisateur utilisateur) {
        if (utilisateur == null) {
            return "/auth";
        }
        if (utilisateur.isBibliothecaire()) {
            return "/dashboard-bibliothecaire";
        }
        if (utilisateur.isLecteur()) {
            return "/dashboard-lecteur";
        }
        return "/auth";
    }

    private void sendStatsJson(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<Emprunt> emprunts = empruntDao.findAll();
        List<Livre> livres = livreDao.findAll();
        
        Map<String, Object> stats = new HashMap<>();
        
        // Statistiques générales
        stats.put("totalEmprunts", emprunts.size());
        stats.put("totalLivres", livres.size());
        stats.put("totalLecteurs", lecteurDao.findAll().size());
        stats.put("empruntsActifs", emprunts.stream().filter(e -> "EN_COURS".equals(e.getStatut())).count());
        stats.put("empruntsRetard", emprunts.stream()
            .filter(e -> "EN_COURS".equals(e.getStatut()) && 
                        e.getDateRetourPrevue() != null && 
                        e.getDateRetourPrevue().isBefore(LocalDate.now()))
            .count());
        
        // Livres les plus empruntés (Top 10)
        Map<String, Long> livresCount = emprunts.stream()
            .collect(Collectors.groupingBy(
                e -> e.getLivre().getTitre(),
                Collectors.counting()
            ));
        
        List<Map<String, Object>> topLivres = livresCount.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
            .limit(10)
            .map(e -> {
                Map<String, Object> item = new HashMap<>();
                item.put("titre", e.getKey());
                item.put("nombre", e.getValue());
                return item;
            })
            .collect(Collectors.toList());
        
        stats.put("topLivres", topLivres);
        
        // Emprunts par mois (12 derniers mois)
        LocalDate today = LocalDate.now();
        Map<String, Long> empruntsByMonth = new LinkedHashMap<>();
        
        for (int i = 11; i >= 0; i--) {
            LocalDate month = today.minusMonths(i);
            String monthKey = month.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            String monthLabel = month.format(DateTimeFormatter.ofPattern("MMM yyyy", Locale.FRENCH));
            
            long count = emprunts.stream()
                .filter(e -> e.getDateEmprunt() != null)
                .filter(e -> {
                    String empruntMonth = e.getDateEmprunt().format(DateTimeFormatter.ofPattern("yyyy-MM"));
                    return empruntMonth.equals(monthKey);
                })
                .count();
            
            empruntsByMonth.put(monthLabel, count);
        }
        
        stats.put("empruntsByMonth", empruntsByMonth);
        
        // Répartition par statut
        Map<String, Long> statusDistribution = emprunts.stream()
            .collect(Collectors.groupingBy(
                e -> e.getStatut().toString(),
                Collectors.counting()
            ));
        
        stats.put("statusDistribution", statusDistribution);
        
        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(stats));
    }

    /**
     * Exporte les données des emprunts au format CSV (pour Excel)
     */
    private void exportExcel(HttpServletResponse response) throws IOException {
        // Définir le type de contenu (CSV)
        response.setContentType("text/csv");
        // Définir le nom du fichier à télécharger avec la date actuelle
        response.setHeader("Content-Disposition", "attachment; filename=\"statistiques_" + LocalDate.now() + ".csv\"");
        
        // Récupérer tous les emprunts
        List<Emprunt> emprunts = empruntDao.findAll();
        
        // Créer le contenu CSV
        StringBuilder csv = new StringBuilder();
        // Ajouter l'en-tête du fichier CSV
        csv.append("ID,Livre,Lecteur,Date Emprunt,Date Retour Prévue,Date Retour Effective,Statut\n");
        
        // Parcourir tous les emprunts et ajouter chaque ligne
        for (Emprunt e : emprunts) {
            csv.append(e.getId()).append(",");                          // ID de l'emprunt
            csv.append("\"").append(e.getLivre().getTitre()).append("\",");  // Titre (entre guillemets)
            csv.append("\"").append(e.getLecteur().getNom()).append("\",");   // Nom lecteur
            csv.append(e.getDateEmprunt()).append(",");                 // Date d'emprunt
            csv.append(e.getDateRetourPrevue() != null ? e.getDateRetourPrevue() : "").append(",");  // Date prévue (ou vide)
            csv.append(e.getDateRetourEffective() != null ? e.getDateRetourEffective() : "").append(",");  // Date effective
            csv.append(e.getStatut()).append("\n");                     // Statut
        }
        
        // Écrire le CSV dans la réponse HTTP
        response.getWriter().write(csv.toString());
    }

    /**
     * Génère un rapport HTML pour impression ou export PDF
     */
    private void exportPDF(HttpServletResponse response) throws IOException {
        // Définir le type de contenu (HTML)
        response.setContentType("text/html");
        // Définir le nom du fichier à télécharger
        response.setHeader("Content-Disposition", "attachment; filename=\"rapport_" + LocalDate.now() + ".html\"");
        
        // Récupérer tous les emprunts
        List<Emprunt> emprunts = empruntDao.findAll();
        
        // Créer le contenu HTML
        StringBuilder html = new StringBuilder();
        // En-tête HTML avec encodage UTF-8
        html.append("<!DOCTYPE html><html><head><meta charset='UTF-8'>");
        html.append("<title>Rapport Statistiques - Smart Library</title>");
        // Styles CSS pour le rapport
        html.append("<style>body{font-family:Arial,sans-serif;margin:40px;}");
        html.append("table{width:100%;border-collapse:collapse;margin-top:20px;}");
        html.append("th,td{border:1px solid #ddd;padding:12px;text-align:left;}");
        html.append("th{background:#667eea;color:white;}</style></head><body>");
        
        // Titre et date du rapport
        html.append("<h1>📊 Rapport des Statistiques</h1>");
        html.append("<p>Généré le: ").append(LocalDate.now()).append("</p>");
        
        // Section résumé
        html.append("<h2>Résumé</h2>");
        html.append("<p>Total emprunts: ").append(emprunts.size()).append("</p>");
        // Compter les emprunts actifs
        html.append("<p>Emprunts actifs: ").append(emprunts.stream().filter(e -> "EN_COURS".equals(e.getStatut())).count()).append("</p>");
        
        // Section détails avec tableau
        html.append("<h2>Détails des emprunts</h2>");
        html.append("<table><tr><th>Livre</th><th>Lecteur</th><th>Date Emprunt</th><th>Statut</th></tr>");
        
        // Parcourir tous les emprunts et créer les lignes du tableau
        for (Emprunt e : emprunts) {
            html.append("<tr><td>").append(e.getLivre().getTitre()).append("</td>");      // Colonne Livre
            html.append("<td>").append(e.getLecteur().getNom()).append("</td>");         // Colonne Lecteur
            html.append("<td>").append(e.getDateEmprunt()).append("</td>");              // Colonne Date
            html.append("<td>").append(e.getStatut()).append("</td></tr>");              // Colonne Statut
        }
        
        // Fermer le tableau et le HTML
        html.append("</table></body></html>");
        
        // Écrire le HTML dans la réponse HTTP
        response.getWriter().write(html.toString());
    }
}
