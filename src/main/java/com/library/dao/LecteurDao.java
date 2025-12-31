package com.library.dao;

import com.library.model.Lecteur;
import jakarta.persistence.EntityManager;
import java.util.List;

public class LecteurDao {

    public void save(Lecteur l) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(l);
            em.flush(); // Forcer l'écriture immédiate
            em.getTransaction().commit();
            System.out.println("✅ Lecteur sauvegardé : " + l.getNom() + " (ID: " + l.getId() + ")");
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la sauvegarde du lecteur", e);
        } finally {
            em.close();
        }
    }

    public List<Lecteur> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Lecteur> list;
        try {
            list = em.createQuery("SELECT l FROM Lecteur l", Lecteur.class).getResultList();

            // ⚡ Charger les emprunts pour éviter LazyInitializationException
            list.forEach(l -> {
                if (l.getEmprunts() != null) l.getEmprunts().size();
            });

        } finally {
            em.close();
        }
        return list;
    }

    public Lecteur findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        Lecteur l;
        try {
            l = em.find(Lecteur.class, id);
            if (l != null && l.getEmprunts() != null) {
                l.getEmprunts().size(); // ⚡ Force le chargement
            }
        } finally {
            em.close();
        }
        return l;
    }

    public void delete(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Lecteur l = em.find(Lecteur.class, id);
            if (l != null) {
                em.remove(l);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de la suppression du lecteur", e);
        } finally {
            em.close();
        }
    }
}
