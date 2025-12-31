package com.library.web;

import com.library.dao.AuteurDao;
import com.library.model.Auteur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/auteurs")
public class AuteurServlet extends HttpServlet {
    
    private final AuteurDao dao = new AuteurDao(); // DAO pour accéder à la base

    // GET : Afficher la page avec la liste des auteurs
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("auteurs", dao.findAll()); // Récupérer tous les auteurs
        req.getRequestDispatcher("/pages/auteurs.jsp").forward(req, resp); // Afficher la page
    }

    // POST : Ajouter ou supprimer un auteur
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action"); // Récupérer l'action (delete ou add)
        
        // Cas1
        if ("delete".equals(action)) {
            String idStr = req.getParameter("id");
            try {
                Long id = Long.parseLong(idStr); // Convertir en nombre
                dao.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect("auteurs"); // Recharger la page
            return;
        }
        
        // CAS 2 : Ajouter un auteur
        String nom = req.getParameter("nom");       // Récupérer le nom
        String prenom = req.getParameter("prenom");
        
        // Vérifier que les champs sont remplis
        if (nom != null && prenom != null && !nom.isBlank()) {
            dao.save(new Auteur(nom.trim(), prenom.trim())); // Créer et sauvegarder
        }
        
        resp.sendRedirect("auteurs"); // Redirection après succès
    }
}
