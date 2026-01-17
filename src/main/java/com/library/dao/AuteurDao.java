package com.library.dao;

import com.library.model.Auteur;
import jakarta.persistence.EntityManager;
import java.util.List;


public class AuteurDao {
    

    public void save(Auteur a) {
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager();
            
            em.getTransaction().begin();
            
            em.persist(a);
            
            // Forcer l'écriture immédiate dans la base
            em.flush();
            
            em.getTransaction().commit();
            
            System.out.println("Auteur sauvegardé : " + a.getNom() + " " + a.getPrenom() + " (ID: " + a.getId() + ")");
            
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback(); // Annulation
            }
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la sauvegarde de l'auteur", e);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }


    public List<Auteur> findAll() {
        EntityManager em = null;
        try {

            em = JpaUtil.getEntityManager();
            

            // Récupère tous les auteurs et les met dans une liste
            List<Auteur> list = em.createQuery("SELECT a FROM Auteur a", Auteur.class).getResultList();
            

            // On force le chargement pour éviter les erreurs quand la connexion est fermée
            list.forEach(a -> {
                if (a.getLivres() != null) {
                    a.getLivres().size(); // Appeler size() force le chargement
                }
            });
            return list; // Renvoie la liste complète
        } finally {

            if (em != null) {
                em.close();
            }
        }
    }


    public Auteur findById(Long id) {
        EntityManager em = null;
        try {

            em = JpaUtil.getEntityManager();

            Auteur a = em.find(Auteur.class, id);
            

            if (a != null && a.getLivres() != null) {
                a.getLivres().size();
            }
            return a;
        } finally {
            // Fermer la connexion
            if (em != null) {
                em.close();
            }
        }
    }


    public void delete(Long id) {
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager();
            
            em.getTransaction().begin();
            
            Auteur a = em.find(Auteur.class, id);
            

            if (a != null) {
                em.remove(a);
            }
            
            em.getTransaction().commit();
            
        } catch (Exception e) {
            // En cas d'erreur, annuler la suppression
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de l'auteur", e);
        } finally {
            // Toujours fermer la connexion
            if (em != null) {
                em.close();
            }
        }
    }
}