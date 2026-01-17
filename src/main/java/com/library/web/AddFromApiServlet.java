package com.library.web;

import com.library.dao.AuteurDao;
import com.library.dao.LivreDao;
import com.library.model.Auteur;
import com.library.model.Livre;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/addFromApi")
public class AddFromApiServlet extends HttpServlet {
    private final LivreDao livreDao = new LivreDao(); // DAO pour sauvegarder les livres
    private final AuteurDao auteurDao = new AuteurDao(); // DAO pour gérer les auteurs

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String titre = req.getParameter("titre");
        String auteurNom = req.getParameter("auteur");
        String anneeStr = req.getParameter("annee");

        // Extraire l'année depuis la chaîne (format YYYY ou YYYY-MM-DD)
        int annee = 0;
        if (anneeStr != null && !anneeStr.isEmpty()) {
            try {
                annee = Integer.parseInt(anneeStr.substring(0, Math.min(4, anneeStr.length())));
            } catch (Exception ignored) {}
        }

        // Chercher ou créer l'auteur
        Auteur auteur = null;
        if (auteurNom != null && !auteurNom.isEmpty()) {
            String premierAuteur = auteurNom.split(",")[0].trim(); // Prendre le premier si plusieurs auteurs
            String[] parts = premierAuteur.split(" ", 2); // Séparer prénom et nom
            String nom = parts.length > 1 ? parts[1] : premierAuteur;
            String prenom = parts.length > 1 ? parts[0] : "";
            
            // Chercher l'auteur dans la base de données
            final String nomFinal = nom;
            final String prenomFinal = prenom;
            auteur = auteurDao.findAll().stream()
                    .filter(a -> a.getNom().equalsIgnoreCase(nomFinal) &&
                               (prenomFinal.isEmpty() || a.getPrenom().equalsIgnoreCase(prenomFinal)))
                    .findFirst()
                    .orElse(null);
            
            // Si l'auteur n'existe pas, le créer
            if (auteur == null) {
                auteur = new Auteur(nom, prenom);
                auteurDao.save(auteur);
            }
        }

        // Créer et sauvegarder le livre
        if (titre != null && !titre.isEmpty() && auteur != null) {
            Livre livre = new Livre(titre.trim(), annee, auteur);
            livreDao.save(livre);
            req.getSession().setAttribute("message", "✅ Livre ajouté avec succès : " + titre);
        } else {
            req.getSession().setAttribute("error", "❌ Erreur : informations manquantes");
        }

        resp.sendRedirect("livres"); // Rediriger vers la page des livres
    }
}
