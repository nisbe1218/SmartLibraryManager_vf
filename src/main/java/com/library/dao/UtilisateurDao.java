package com.library.dao;

import com.library.model.Utilisateur;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class UtilisateurDao {


     // Trouve un utilisateur par son username

    public Optional<Utilisateur> findByUsername(String username) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.username = :username", 
                Utilisateur.class
            );
            query.setParameter("username", username);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }


     //Vérifier les identifiants de connexion

    public Optional<Utilisateur> authenticate(String username, String password) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.username = :username AND u.password = :password", 
                Utilisateur.class
            );
            query.setParameter("username", username);
            query.setParameter("password", password);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }


     // Crée un nouvel utilisateur

    public Utilisateur create(Utilisateur utilisateur) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(utilisateur);
            em.getTransaction().commit();
            return utilisateur;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }


    //Met à jour un utilisateur

    public Utilisateur update(Utilisateur utilisateur) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Utilisateur updated = em.merge(utilisateur);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }




    /**
     * Récupère tous les utilisateurs
     */
    public List<Utilisateur> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM Utilisateur u", Utilisateur.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }



    /**
     * Supprime un utilisateur
     */
    public void delete(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Utilisateur utilisateur = em.find(Utilisateur.class, id);
            if (utilisateur != null) {
                em.remove(utilisateur);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
}
