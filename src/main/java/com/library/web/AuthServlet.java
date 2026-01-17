package com.library.web;

import com.library.dao.UtilisateurDao;
import com.library.dao.LecteurDao;
import com.library.model.Utilisateur;
import com.library.model.Lecteur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
//Gérer l'authentification et l'inscription des utilisateurs

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private final UtilisateurDao utilisateurDao = new UtilisateurDao();
    private final LecteurDao lecteurDao = new LecteurDao();
//Afficher la page de connexion/inscription
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
//Traiter connexion ou inscription selon le paramètre 'action'
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            login(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        }
    }
//Connexion utilisateur (param: email, password)
    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        var utilisateurOpt = utilisateurDao.authenticate(username, password);
        
        if (utilisateurOpt.isPresent()) {
            Utilisateur utilisateur = utilisateurOpt.get();
            utilisateur.updateDerniereConnexion();
            utilisateurDao.update(utilisateur);
            
            HttpSession session = request.getSession();
            session.setAttribute("utilisateur", utilisateur);
            session.setAttribute("role", utilisateur.getRole());
            
            // Rediriger selon le rôle
            if (utilisateur.isBibliothecaire()) {
                response.sendRedirect(request.getContextPath() + "/dashboard-bibliothecaire");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard-lecteur");
            }
        } else {
            request.setAttribute("error", "Nom d'utilisateur ou mot de passe incorrect");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
// Inscription nouveau lecteur (param: nom, prenom, email, password)
    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String nom = request.getParameter("nom");
        String roleStr = request.getParameter("role");

        // Vérifier si l'utilisateur existe déjà
        if (utilisateurDao.findByUsername(username).isPresent()) {
            request.setAttribute("error", "Ce nom d'utilisateur est déjà utilisé");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        Utilisateur.Role role = (roleStr != null && roleStr.equals("BIBLIOTHECAIRE")) 
            ? Utilisateur.Role.BIBLIOTHECAIRE 
            : Utilisateur.Role.LECTEUR;

        Utilisateur utilisateur = new Utilisateur(username, password, email, role);

        // Si c'est un lecteur, créer aussi un objet Lecteur
        if (role == Utilisateur.Role.LECTEUR) {
            Lecteur lecteur = new Lecteur(nom, email);
            lecteur = lecteurDao.create(lecteur);
            utilisateur.setLecteur(lecteur);
        }

        utilisateurDao.create(utilisateur);
        
        request.setAttribute("success", "Compte créé avec succès ! Veuillez vous connecter.");
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
// Déconnexion (détruit la session)
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth");
    }
}
