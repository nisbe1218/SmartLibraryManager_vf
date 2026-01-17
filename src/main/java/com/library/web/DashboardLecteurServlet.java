package com.library.web;

import com.library.dao.LivreDao;
import com.library.dao.EmpruntDao;
import com.library.dao.AuteurDao;
import com.library.model.Utilisateur;
import com.library.model.Lecteur;
import com.library.model.Livre;
import com.library.model.Emprunt;
import com.library.model.Auteur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;


@WebServlet("/dashboard-lecteur")
public class DashboardLecteurServlet extends HttpServlet {

    private final LivreDao livreDao = new LivreDao();
    private final EmpruntDao empruntDao = new EmpruntDao();
    private final AuteurDao auteurDao = new AuteurDao();
//Afficher le catalogue des livres et les emprunts du lecteur
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        
        if (utilisateur == null || !utilisateur.isLecteur()) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        Lecteur lecteur = utilisateur.getLecteur();
        
        // Récupérer tous les livres disponibles
        List<Livre> tousLesLivres = livreDao.findAll();
        
        // Récupérer les emprunts du lecteur
        List<Emprunt> mesEmprunts = empruntDao.findByLecteur(lecteur.getId());
        
        // Séparer par statut
        List<Emprunt> empruntsEnCours = mesEmprunts.stream()
            .filter(e -> e.getStatut() == Emprunt.StatutEmprunt.EN_COURS)
            .collect(Collectors.toList());
            
        List<Emprunt> reservations = mesEmprunts.stream()
            .filter(e -> e.getStatut() == Emprunt.StatutEmprunt.RESERVE)
            .collect(Collectors.toList());
            
        List<Emprunt> historique = mesEmprunts.stream()
            .filter(e -> e.getStatut() == Emprunt.StatutEmprunt.RETOURNE)
            .collect(Collectors.toList());

        // Vérifier la disponibilité de chaque livre
        for (Livre livre : tousLesLivres) {
            boolean estDisponible = empruntDao.isLivreDisponible(livre.getId());
            request.setAttribute("disponible_" + livre.getId(), estDisponible);
        }

        request.setAttribute("utilisateur", utilisateur);
        request.setAttribute("lecteur", lecteur);
        request.setAttribute("tousLesLivres", tousLesLivres);
        request.setAttribute("empruntsEnCours", empruntsEnCours);
        request.setAttribute("reservations", reservations);
        request.setAttribute("historique", historique);
        
        request.getRequestDispatcher("/pages/dashboard-lecteur.jsp").forward(request, response);
    }
//Gérer les emprunts (emprunter, réserver, annuler)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        
        if (utilisateur == null || !utilisateur.isLecteur()) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        Lecteur lecteur = utilisateur.getLecteur();
        
        // Gestion de l'ajout d'un livre Google et emprunt direct
        if ("ajouter-emprunter-google".equals(action)) {
            ajouterEtEmprunterLivreGoogle(request, response, lecteur);
            return;
        }
        
        // Gestion de l'ajout d'un livre Google et réservation
        if ("ajouter-reserver-google".equals(action)) {
            ajouterEtReserverLivreGoogle(request, response, lecteur);
            return;
        }
        
        Long livreId = Long.parseLong(request.getParameter("livreId"));
        Livre livre = livreDao.findById(livreId);

        if ("emprunter".equals(action)) {
            emprunterLivre(livre, lecteur, request);
        } else if ("reserver".equals(action)) {
            reserverLivre(livre, lecteur, request);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard-lecteur");
    }

    private void emprunterLivre(Livre livre, Lecteur lecteur, HttpServletRequest request) {
        if (empruntDao.isLivreDisponible(livre.getId())) {
            Emprunt emprunt = new Emprunt(
                java.time.LocalDate.now(),
                java.time.LocalDate.now().plusDays(15),
                livre,
                lecteur
            );
            empruntDao.create(emprunt);
            request.getSession().setAttribute("success", "Livre emprunté avec succès !");
        } else {
            request.getSession().setAttribute("error", 
                "Ce livre n'est pas disponible. Voulez-vous le réserver ?");
        }
    }

    private void reserverLivre(Livre livre, Lecteur lecteur, HttpServletRequest request) {
        Emprunt reservation = Emprunt.creerReservation(livre, lecteur);
        empruntDao.create(reservation);
        request.getSession().setAttribute("success", 
            "Livre réservé avec succès ! Vous serez notifié quand il sera disponible.");
    }
    
    private void ajouterEtEmprunterLivreGoogle(HttpServletRequest request, HttpServletResponse response, Lecteur lecteur) 
            throws IOException {
        try {
            String titre = request.getParameter("titre");
            String anneeStr = request.getParameter("annee");
            String prenomAuteur = request.getParameter("prenom");
            String nomAuteur = request.getParameter("nom");
            String auteurNomComplet = request.getParameter("auteurNomComplet");
            String isbn = request.getParameter("isbn");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            
            if (titre == null || titre.trim().isEmpty()) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Le titre du livre est requis\"}");
                return;
            }
            
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
            
            // Créer et sauvegarder le livre
            Livre livre = new Livre(titre.trim(), annee, auteur);
            
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
            
            // Emprunter automatiquement le livre
            if (livre.getId() != null) {
                Emprunt emprunt = new Emprunt(
                    java.time.LocalDate.now(),
                    java.time.LocalDate.now().plusDays(15),
                    livre,
                    lecteur
                );
                empruntDao.create(emprunt);
                
                // Renvoyer le succès
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"bookId\": " + livre.getId() + "}");
            } else {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Impossible de créer le livre\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void ajouterEtReserverLivreGoogle(HttpServletRequest request, HttpServletResponse response, Lecteur lecteur) 
            throws IOException {
        try {
            String titre = request.getParameter("titre");
            String anneeStr = request.getParameter("annee");
            String prenomAuteur = request.getParameter("prenom");
            String nomAuteur = request.getParameter("nom");
            String auteurNomComplet = request.getParameter("auteurNomComplet");
            String isbn = request.getParameter("isbn");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            
            if (titre == null || titre.trim().isEmpty()) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Le titre du livre est requis\"}");
                return;
            }
            
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
            
            // Créer et sauvegarder le livre
            Livre livre = new Livre(titre.trim(), annee, auteur);
            
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
            
            // Réserver automatiquement le livre
            if (livre.getId() != null) {
                Emprunt reservation = Emprunt.creerReservation(livre, lecteur);
                empruntDao.create(reservation);
                
                // Renvoyer le succès
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"bookId\": " + livre.getId() + "}");
            } else {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Impossible de créer le livre\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
