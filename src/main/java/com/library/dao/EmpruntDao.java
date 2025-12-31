package com.library.dao;

import com.library.model.Emprunt;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * DAO pour gérer les emprunts de livres
 */
public class EmpruntDao {

    // Sauvegarder un nouvel emprunt dans la base
    public void save(Emprunt e) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(e);
            em.flush(); // Forcer l'écriture immédiate
            em.getTransaction().commit();
            System.out.println("✅ Emprunt sauvegardé (ID: " + e.getId() + ")");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            ex.printStackTrace();
            throw new RuntimeException("Erreur lors de la sauvegarde de l'emprunt", ex);
        } finally {
            em.close();
        }
    }

    // Récupérer tous les emprunts
    public List<Emprunt> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Emprunt> list = em.createQuery("SELECT e FROM Emprunt e", Emprunt.class).getResultList();
        em.close();
        return list;
    }

    // Compter le nombre d'emprunts par livre
    public List<Object[]> countEmpruntsByLivre() {
        EntityManager em = JpaUtil.getEntityManager();
        //  regroupe les emprunts par titre de livre
        List<Object[]> results = em.createQuery(
                "SELECT e.livre.titre, COUNT(e) FROM Emprunt e GROUP BY e.livre.titre", Object[].class
        ).getResultList();
        em.close();
        return results;
    }

    // Marquer un emprunt comme rendu (le lecteur a retourné le livre)
    public void marquerCommeRendu(Long empruntId) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        Emprunt e = em.find(Emprunt.class, empruntId);
        // Vérifier que l'emprunt existe et n'est pas déjà rendu
        if (e != null && e.getDateRetour() == null) {
            e.marquerCommeRendu(); // Met la date de retour à aujourd'hui
            em.merge(e); // Sauvegarde les modifications
        }
        em.getTransaction().commit();
        em.close();
    }

    // Vérifier si un livre est disponible (pas d'emprunt en cours)
    public boolean isLivreDisponible(Long livreId) {
        EntityManager em = JpaUtil.getEntityManager();
        // Compte les emprunts en cours pour ce livre
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM Emprunt e WHERE e.livre.id = :livreId AND e.statut = com.library.model.Emprunt.StatutEmprunt.EN_COURS",
                Long.class
        );
        query.setParameter("livreId", livreId);
        long count = query.getSingleResult();
        em.close();
        return count == 0; // Si count = 0, le livre est disponible
    }

    // Supprimer un emprunt de la base
    public void delete(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Emprunt e = em.find(Emprunt.class, id);
            if (e != null) {
                em.remove(e);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de la suppression de l'emprunt", ex);
        } finally {
            em.close();
        }
    }
}
