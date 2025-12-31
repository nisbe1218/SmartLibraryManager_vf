package com.library.web;

import com.library.dao.EmpruntDao;
import com.library.dao.LecteurDao;
import com.library.dao.LivreDao;
import com.library.model.Emprunt;
import com.library.model.Lecteur;
import com.library.model.Livre;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

// Servlet pour gérer les emprunts : créer, rendre, supprimer
@WebServlet("/emprunts")
public class EmpruntServlet extends HttpServlet {

    private final EmpruntDao empruntDao = new EmpruntDao(); // Pour les emprunts
    private final LivreDao livreDao = new LivreDao();       // Pour les livres
    private final LecteurDao lecteurDao = new LecteurDao(); // Pour les lecteurs

    // GET : Afficher la page avec tous les emprunts et formulaires
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("emprunts", empruntDao.findAll());           // Liste des emprunts
        req.setAttribute("livres", livreDao.findAll());               // Pour le formulaire
        req.setAttribute("lecteurs", lecteurDao.findAll());           // Pour le formulaire
        req.setAttribute("stats", empruntDao.countEmpruntsByLivre()); // Statistiques

        req.getRequestDispatcher("/pages/emprunts.jsp").forward(req, resp);
    }

    // POST : Gérer 3 actions (créer, rendre, supprimer)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action"); // Récupérer l'action
        
        // ACTION 1 : Supprimer un emprunt
        if ("delete".equals(action)) {
            String idStr = req.getParameter("id");
            try {
                Long id = Long.parseLong(idStr);
                empruntDao.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect("emprunts");
            return;
        }

        // ACTION 2 : Marquer comme rendu
        String renduIdStr = req.getParameter("renduId");

        if (renduIdStr != null && !renduIdStr.isEmpty()) {
            try {
                Long renduId = Long.parseLong(renduIdStr); // Convertir l'ID
                empruntDao.marquerCommeRendu(renduId); // Mettre à jour la date de retour
                req.getSession().setAttribute("message", "✅ Livre marqué comme rendu !");

            } catch (NumberFormatException e) {
                req.getSession().setAttribute("error", "❌ ID d'emprunt invalide");
            } catch (Exception e) {
                req.getSession().setAttribute("error", "❌ Erreur lors du retour : " + e.getMessage());
            }

            resp.sendRedirect("emprunts");
            return;
        }

        // ACTION 3 : Créer un nouvel emprunt
        String livreIdStr = req.getParameter("livreId"); // Récupérer les IDs
        String lecteurIdStr = req.getParameter("lecteurId");

        // Vérifier que les champs sont remplis
        if (livreIdStr == null || livreIdStr.isEmpty() ||
                lecteurIdStr == null || lecteurIdStr.isEmpty()) {
            req.getSession().setAttribute("error", "❌ Veuillez sélectionner un livre et un lecteur");
            resp.sendRedirect("emprunts");
            return;
        }

        // Convertir les IDs en nombres
        Long livreId = null;
        Long lecteurId = null;

        try {
            livreId = Long.parseLong(livreIdStr);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "❌ ID de livre invalide");
            resp.sendRedirect("emprunts");
            return;
        }

        try {
            lecteurId = Long.parseLong(lecteurIdStr);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "❌ ID de lecteur invalide");
            resp.sendRedirect("emprunts");
            return;
        }

        // Récupérer les entités depuis la base
        Livre livre = livreDao.findById(livreId);
        Lecteur lecteur = lecteurDao.findById(lecteurId);

        // Vérifier qu'elles existent
        if (livre == null) {
            req.getSession().setAttribute("error", "❌ Livre non trouvé");
            resp.sendRedirect("emprunts");
            return;
        }



        // Vérifier que le livre est disponible
        if (!empruntDao.isLivreDisponible(livreId)) {
            req.getSession().setAttribute("error",
                    "❌ Ce livre est déjà emprunté par quelqu'un d'autre !");
            resp.sendRedirect("emprunts");
            return;
        }

        // Créer et sauvegarder l'emprunt
        try {
            Emprunt emprunt = new Emprunt(LocalDate.now(), null, livre, lecteur);
            empruntDao.save(emprunt);
            req.getSession().setAttribute("message",
                    "✅ Emprunt créé avec succès ! Retour prévu le " + emprunt.getDateRetourPrevue());

        } catch (Exception e) {
            req.getSession().setAttribute("error",
                    "❌ Erreur lors de la création de l'emprunt : " + e.getMessage());
        }

        resp.sendRedirect("emprunts"); // Redirection
    }
}