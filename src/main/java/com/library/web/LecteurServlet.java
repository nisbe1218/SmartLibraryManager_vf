package com.library.web;

import com.library.dao.LecteurDao;
import com.library.model.Lecteur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/lecteurs")
public class LecteurServlet extends HttpServlet {

    private final LecteurDao dao = new LecteurDao(); // DAO pour accéder aux lecteurs

    // GET : Afficher la page avec la liste des lecteurs
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8"); // Configurer l'encodage UTF-8 pour la réponse
        req.setCharacterEncoding("UTF-8"); // Configurer l'encodage UTF-8 pour la requête

        try {
            List<Lecteur> lecteurs = dao.findAll();
            req.setAttribute("lecteurs", lecteurs);
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors du chargement des lecteurs : " + e.getMessage()); // Message d'erreur
        }

        req.getRequestDispatcher("/pages/lecteurs.jsp").forward(req, resp); // Afficher la page lecteurs.jsp
    }

    // POST : Ajouter ou supprimer un lecteur
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action"); // Récupérer l'action
        
        // CAS 1 : Supprimer un lecteur
        if ("delete".equals(action)) {
            String idStr = req.getParameter("id");
            try {
                Long id = Long.parseLong(idStr);
                dao.delete(id); // Supprimer de la base
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect("lecteurs");
            return;
        }
        
        // CAS 2 : Ajouter un lecteur
        String nom = req.getParameter("nom");
        String email = req.getParameter("email");

        // Vérifier que les champs sont remplis
        if (nom == null || nom.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Veuillez remplir tous les champs.");
            doGet(req, resp);
            return;
        }

        try {
            Lecteur lecteur = new Lecteur(nom.trim(), email.trim()); // Créer le lecteur
            dao.save(lecteur); // Sauvegarder
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de l’ajout du lecteur : " + e.getMessage());
            doGet(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/lecteurs"); // Redirection
    }
}
