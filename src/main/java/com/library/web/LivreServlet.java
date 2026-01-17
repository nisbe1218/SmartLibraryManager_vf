package com.library.web;

import com.library.dao.AuteurDao;
import com.library.dao.LivreDao;
import com.library.model.Auteur;
import com.library.model.Livre;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
//Gérer les livres de la bibliothèque (CRUD)

@WebServlet("/livres")
public class LivreServlet extends HttpServlet {
    

    private final LivreDao livreDao = new LivreDao();    // Pour gérer les livres
    private final AuteurDao auteurDao = new AuteurDao();
//Afficher la liste de tous les livres avec leurs auteurs
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("livres", livreDao.findAll());
        
        req.setAttribute("auteurs", auteurDao.findAll());
        

        req.getRequestDispatcher("/pages/livres.jsp").forward(req, resp);
    }

//Ajouter, modifier ou supprimer un livre
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        

        // CAS 1 : SUPPRESSION d'un livre
        if ("delete".equals(action)) {
            // Récupérer l'ID du livre à supprimer
            String idStr = req.getParameter("id");
            try {
                Long id = Long.parseLong(idStr);
                
                livreDao.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect("livres");
            return;
        }
        
        // CAS 2 : AJOUT d'un nouveau livre (formulaire d'ajout)

        String titre = req.getParameter("titre");
        String anneeStr = req.getParameter("annee");
        String auteurIdStr = req.getParameter("auteurId");

        // Convertir l'année de texte en nombre entier
        int annee = 0;
        try { 
            annee = Integer.parseInt(anneeStr); 
        } catch (Exception ignored) {} // Si erreur, garder 0
        
        // Convertir l'ID de l'auteur de texte en nombre
        Long auteurId = null;
        try { 
            auteurId = Long.parseLong(auteurIdStr); 
        } catch (Exception ignored) {} // Si erreur, garder null

        // Chercher
        Auteur auteur = null;
        if (auteurId != null) {
            auteur = auteurDao.findById(auteurId);
        }
        
        // Si on a un titre ET un auteur, créer le livre
        if (titre != null && auteur != null) {
            // Créer un nouvel objet Livre
            Livre l = new Livre(titre.trim(), annee, auteur);
            
            // Sauvegarder le livre dans la base de données
            livreDao.save(l);
        }

        resp.sendRedirect("livres");
    }
}
