package com.library.dao;

import com.library.model.Auteur;
import jakarta.persistence.EntityManager;
import java.util.List;

/**
 * DAO (Data Access Object) pour gérer les opérations sur les auteurs dans la base de données
 * C'est le "pont" entre l'application Java et la base de données H2
 */
public class AuteurDao {
    
    /**
     * MÉTHODE 1 : Sauvegarder un nouvel auteur dans la base de données
     * @param a L'objet Auteur à sauvegarder
     */
    public void save(Auteur a) {
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager();
            
            em.getTransaction().begin();
            
            em.persist(a);
            
            // Forcer l'écriture immédiate dans la base
            em.flush();
            
            em.getTransaction().commit();
            
            System.out.println("✅ Auteur sauvegardé : " + a.getNom() + " " + a.getPrenom() + " (ID: " + a.getId() + ")");
            
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

    /**
     * MÉTHODE 2 : Récupérer tous les auteurs de la base de données
     * @return Une liste contenant tous les auteurs
     */
    public List<Auteur> findAll() {
        EntityManager em = null; // Le manager de connexion
        try {
            // Ouvrir la connexion
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
            // Toujours fermer la connexion
            if (em != null) {
                em.close();
            }
        }
    }

    /**
     * MÉTHODE 3 : Trouver un auteur spécifique par son ID

     */
    public Auteur findById(Long id) {
        EntityManager em = null;
        try {

            em = JpaUtil.getEntityManager();

            Auteur a = em.find(Auteur.class, id);
            
            // Force le chargement de la liste des livres de cet auteur
            if (a != null && a.getLivres() != null) {
                a.getLivres().size();
            }
            return a; // Renvoie l'auteur trouvé (ou null)
        } finally {
            // Fermer la connexion
            if (em != null) {
                em.close();
            }
        }
    }

    /**
     * MÉTHODE 4 : Supprimer un auteur de la base de données

     */
    public void delete(Long id) {
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager();
            
            em.getTransaction().begin();
            
            Auteur a = em.find(Auteur.class, id);
            
            // Si l'auteur existe, le supprimer
            if (a != null) {
                em.remove(a); // remove() = DELETE FROM Auteur WHERE id = ?
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