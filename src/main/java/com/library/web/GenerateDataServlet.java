package com.library.web;

import com.library.dao.JpaUtil;
import com.library.model.Auteur;
import com.library.model.Lecteur;
import com.library.model.Livre;
import com.library.model.Emprunt;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Random;

@WebServlet("/generate")
public class GenerateDataServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Récupération des paramètres depuis le formulaire
        int nLivres = 100;
        int nLecteurs = 50;
        int nEmprunts = 1000;

        try { nLivres = Integer.parseInt(req.getParameter("nLivres")); } catch (Exception ignored) {}
        try { nLecteurs = Integer.parseInt(req.getParameter("nLecteurs")); } catch (Exception ignored) {}
        try { nEmprunts = Integer.parseInt(req.getParameter("nEmprunts")); } catch (Exception ignored) {}

        EntityManager em = JpaUtil.getEntityManager();//connexion
        em.getTransaction().begin();

        Random rnd = new Random();//generateur

        // Créer 10 auteurs
        Auteur[] auteurs = new Auteur[10];
        for (int i = 0; i < auteurs.length; i++) {
            auteurs[i] = new Auteur("NomA" + i, "PrenomA" + i);
            em.persist(auteurs[i]);
        }

        // Créer les livres
        for (int i = 0; i < nLivres; i++) {
            Auteur a = auteurs[rnd.nextInt(auteurs.length)];
            Livre l = new Livre("Livre " + i, 1900 + rnd.nextInt(121), a);
            em.persist(l);
            if (i % 50 == 0) {
                em.flush();
                em.clear();
            }
        }

        // Créer les lecteurs
        for (int i = 0; i < nLecteurs; i++) {
            Lecteur lect = new Lecteur("Lecteur" + i, "lecteur" + i + "@mail.test");
            em.persist(lect);
            if (i % 50 == 0) {
                em.flush();
                em.clear();
            }
        }

        // Recharger les livres et lecteurs pour générer les emprunts
        List<Livre> livresList = em.createQuery("SELECT l FROM Livre l", Livre.class).getResultList();
        List<Lecteur> lecteursList = em.createQuery("SELECT le FROM Lecteur le", Lecteur.class).getResultList();

        for (int i = 0; i < nEmprunts; i++) {
            Livre livre = livresList.get(rnd.nextInt(livresList.size()));
            Lecteur lecteur = lecteursList.get(rnd.nextInt(lecteursList.size()));

            LocalDate dateEmprunt = LocalDate.now().minusDays(rnd.nextInt(365));
            LocalDate dateRetour = rnd.nextBoolean() ? dateEmprunt.plusDays(rnd.nextInt(60)) : null;//la moitie deja rendu

            Emprunt e = new Emprunt(dateEmprunt, dateRetour, livre, lecteur);
            em.persist(e);

            if (i % 50 == 0) {
                em.flush();
                em.clear();
            }
        }

        em.getTransaction().commit();
        em.close();

        // Message de confirmation dans la session
        HttpSession session = req.getSession();
        session.setAttribute("message", "✅ Génération terminée : " + nLivres + " livres, " + nLecteurs + " lecteurs, " + nEmprunts + " emprunts.");

        resp.sendRedirect("index.jsp");
    }
}
