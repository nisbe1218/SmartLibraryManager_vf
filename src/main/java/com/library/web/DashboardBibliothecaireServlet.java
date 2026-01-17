package com.library.web;

import com.library.dao.LivreDao;
import com.library.dao.EmpruntDao;
import com.library.dao.LecteurDao;
import com.library.dao.AuteurDao;
import com.library.model.Utilisateur;
import com.library.model.Livre;
import com.library.model.Emprunt;
import com.library.model.Lecteur;
import com.library.model.Auteur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@WebServlet("/dashboard-bibliothecaire")
public class DashboardBibliothecaireServlet extends HttpServlet {

    private final LivreDao livreDao = new LivreDao();
    private final EmpruntDao empruntDao = new EmpruntDao();
    private final LecteurDao lecteurDao = new LecteurDao();
    private final AuteurDao auteurDao = new AuteurDao();
//Afficher le dashboard avec statistiques, livres, emprunts
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        
        if (utilisateur == null || !utilisateur.isBibliothecaire()) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        // Statistiques générales
        List<Livre> tousLesLivres = livreDao.findAll();
        List<Emprunt> tousLesEmprunts = empruntDao.findAll();
        List<Lecteur> tousLesLecteurs = lecteurDao.findAll();
        
        // Emprunts en cours
        List<Emprunt> empruntsEnCours = empruntDao.findByStatut(Emprunt.StatutEmprunt.EN_COURS);
        
        // Réservations en attente
        List<Emprunt> reservations = empruntDao.findByStatut(Emprunt.StatutEmprunt.RESERVE);
        
        // Emprunts en retard
        List<Emprunt> empruntsEnRetard = empruntsEnCours.stream()
            .filter(Emprunt::isEnRetard)
            .collect(Collectors.toList());
        
        // 10 derniers emprunts pour le graphique
        List<Emprunt> derniers10Emprunts = empruntDao.findLastNEmprunts(10);
        
        // Calculer les statistiques pour le graphique
        Map<String, Long> statistiquesLivres = derniers10Emprunts.stream()
            .collect(Collectors.groupingBy(
                e -> e.getLivre().getTitre(),
                Collectors.counting()
            ));

        request.setAttribute("utilisateur", utilisateur);
        request.setAttribute("tousLesLivres", tousLesLivres);
        request.setAttribute("empruntsEnCours", empruntsEnCours);
        request.setAttribute("reservations", reservations);
        request.setAttribute("empruntsEnRetard", empruntsEnRetard);
        request.setAttribute("derniers10Emprunts", derniers10Emprunts);
        request.setAttribute("statistiquesLivres", statistiquesLivres);
        request.setAttribute("nombreTotalLivres", tousLesLivres.size());
        request.setAttribute("nombreTotalLecteurs", tousLesLecteurs.size());
        request.setAttribute("nombreEmpruntsActifs", empruntsEnCours.size());
        
        request.getRequestDispatcher("/pages/dashboard-bibliothecaire.jsp").forward(request, response);
    }
//Gérer les livres, emprunts et lecteurs (CRUD complet)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        
        if (utilisateur == null || !utilisateur.isBibliothecaire()) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        switch (action) {
            case "rendre":
                rendreEmprunt(request);
                break;
            case "activer-reservation":
                activerReservation(request);
                break;
            case "ajouter-livre":
                ajouterLivre(request);
                break;
            case "ajouter-livre-google":
                ajouterLivreDepuisGoogle(request);
                break;
            case "supprimer-livre":
                supprimerLivre(request);
                break;
        }

        response.sendRedirect(request.getContextPath() + "/dashboard-bibliothecaire");
    }

    private void rendreEmprunt(HttpServletRequest request) {
        Long empruntId = Long.parseLong(request.getParameter("empruntId"));
        Emprunt emprunt = empruntDao.findById(empruntId);
        
        if (emprunt != null && emprunt.getStatut() == Emprunt.StatutEmprunt.EN_COURS) {
            emprunt.marquerCommeRendu();
            empruntDao.update(emprunt);
            request.getSession().setAttribute("success", "Livre marqué comme rendu avec succès !");
        }
    }

    private void activerReservation(HttpServletRequest request) {
        Long reservationId = Long.parseLong(request.getParameter("reservationId"));
        Emprunt reservation = empruntDao.findById(reservationId);
        
        if (reservation != null && reservation.getStatut() == Emprunt.StatutEmprunt.RESERVE) {
            // Vérifier si le livre est maintenant disponible
            if (empruntDao.isLivreDisponible(reservation.getLivre().getId())) {
                reservation.activerReservation();
                empruntDao.update(reservation);
                request.getSession().setAttribute("success", "Réservation activée en emprunt !");
            } else {
                request.getSession().setAttribute("error", "Le livre n'est pas encore disponible.");
            }
        }
    }

    private void ajouterLivre(HttpServletRequest request) {
        try {
            String titre = request.getParameter("titre");
            String anneeStr = request.getParameter("annee");
            String prenomAuteur = request.getParameter("prenomAuteur");
            String nomAuteur = request.getParameter("nomAuteur");
            
            if (titre != null && !titre.trim().isEmpty() && 
                prenomAuteur != null && !prenomAuteur.trim().isEmpty() &&
                nomAuteur != null && !nomAuteur.trim().isEmpty()) {
                
                int annee = Integer.parseInt(anneeStr);
                
                // Chercher si l'auteur existe déjà
                Auteur auteur = null;
                List<Auteur> auteurs = auteurDao.findAll();
                for (Auteur a : auteurs) {
                    if (a.getNom().equalsIgnoreCase(nomAuteur.trim()) && 
                        a.getPrenom().equalsIgnoreCase(prenomAuteur.trim())) {
                        auteur = a;
                        break;
                    }
                }
                
                // Si l'auteur n'existe pas, le créer
                if (auteur == null) {
                    auteur = new Auteur(nomAuteur.trim(), prenomAuteur.trim());
                    auteurDao.save(auteur);
                }
                
                // Créer le livre
                Livre livre = new Livre(titre.trim(), annee, auteur);
                livreDao.save(livre);
                request.getSession().setAttribute("success", "Livre ajouté avec succès !");
            } else {
                request.getSession().setAttribute("error", " Veuillez remplir tous les champs obligatoires.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", " Erreur lors de l'ajout du livre: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void ajouterLivreDepuisGoogle(HttpServletRequest request) {
        try {
            String titre = request.getParameter("titre");
            String anneeStr = request.getParameter("annee");
            String prenomAuteur = request.getParameter("prenom");
            String nomAuteur = request.getParameter("nom");
            String auteurNomComplet = request.getParameter("auteurNomComplet");
            String isbn = request.getParameter("isbn");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            
            if (titre != null && !titre.trim().isEmpty()) {
                int annee = 2000;
                try {
                    annee = Integer.parseInt(anneeStr);
                } catch (Exception ignored) {}
                
                // Chercher ou créer l'auteur
                Auteur auteur = null;
                String nom = nomAuteur != null && !nomAuteur.trim().isEmpty() ? nomAuteur.trim() : "Inconnu";
                String prenom = prenomAuteur != null && !prenomAuteur.trim().isEmpty() ? prenomAuteur.trim() : "";
                
                // Si on a un nom complet, l'utiliser
                if (auteurNomComplet != null && !auteurNomComplet.trim().isEmpty()) {
                    String[] parts = auteurNomComplet.trim().split(" ", 2);
                    if (parts.length == 2) {
                        prenom = parts[0];
                        nom = parts[1];
                    } else {
                        nom = parts[0];
                    }
                }
                
                // Chercher si l'auteur existe déjà
                List<Auteur> auteurs = auteurDao.findAll();
                for (Auteur a : auteurs) {
                    if (a.getNom().equalsIgnoreCase(nom) && a.getPrenom().equalsIgnoreCase(prenom)) {
                        auteur = a;
                        break;
                    }
                }
                
                // Si l'auteur n'existe pas, le créer
                if (auteur == null) {
                    auteur = new Auteur(nom, prenom);
                    auteurDao.save(auteur);
                }
                
                // Créer et sauvegarder le livre avec tous les champs
                Livre livre = new Livre(titre.trim(), annee, auteur);
                
                // Ajouter les nouveaux champs s'ils sont fournis
                if (isbn != null && !isbn.trim().isEmpty()) {
                    livre.setIsbn(isbn.trim());
                }
                if (description != null && !description.trim().isEmpty()) {
                    livre.setDescription(description.trim());
                }
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    livre.setImageUrl(imageUrl.trim());
                }
                
                livreDao.save(livre);
                request.getSession().setAttribute("success", "✅ Livre ajouté depuis Google Books avec succès !");
            } else {
                request.getSession().setAttribute("error", "❌ Le titre du livre est requis.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "❌ Erreur lors de l'ajout du livre: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void supprimerLivre(HttpServletRequest request) {
        try {
            String livreIdStr = request.getParameter("livreId");
            if (livreIdStr != null && !livreIdStr.trim().isEmpty()) {
                Long livreId = Long.parseLong(livreIdStr);
                Livre livre = livreDao.findById(livreId);
                
                if (livre != null) {
                    // Vérifier s'il y a des emprunts actifs pour ce livre
                    List<Emprunt> empruntsActifs = empruntDao.findByLivre(livreId);
                    boolean hasActiveEmprunts = false;
                    for (Emprunt emprunt : empruntsActifs) {
                        if (emprunt.getStatut() == Emprunt.StatutEmprunt.EN_COURS || 
                            emprunt.getStatut() == Emprunt.StatutEmprunt.RESERVE) {
                            hasActiveEmprunts = true;
                            break;
                        }
                    }
                    
                    if (hasActiveEmprunts) {
                        request.getSession().setAttribute("error", "❌ Impossible de supprimer ce livre : il est actuellement emprunté ou réservé.");
                    } else {
                        livreDao.delete(livreId);
                        request.getSession().setAttribute("success", "✅ Livre supprimé avec succès !");
                    }
                } else {
                    request.getSession().setAttribute("error", "❌ Livre introuvable.");
                }
            } else {
                request.getSession().setAttribute("error", "❌ ID du livre manquant.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "❌ Erreur lors de la suppression : " + e.getMessage());
            e.printStackTrace();
        }
    }
}
