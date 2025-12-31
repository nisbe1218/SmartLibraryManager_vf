package com.library.dao;

import com.library.model.Livre;
import jakarta.persistence.EntityManager;
import java.util.List;

/**
 * DAO pour gérer les opérations CRUD sur les livres
 * CRUD = Create (créer), Read (lire), Update (modifier), Delete (supprimer)
 */
public class LivreDao {
    
    /**
     * Sauvegarder un nouveau livre dans la base de données
     * @param l Le livre à ajouter
     */
    public void save(Livre l) {
        EntityManager em = null; // Le gestionnaire de base de données
        try {
            // 1. Ouvrir une connexion à la base de données H2
            em = JpaUtil.getEntityManager();
            
            // 2. Commencer une transaction (un ensemble d'opérations qui vont ensemble)
            em.getTransaction().begin();
            
            // 3. Persister le livre (l'ajouter dans la base)
            // JPA va automatiquement faire : INSERT INTO Livre VALUES (...)
            em.persist(l);
            
            // 4. Forcer l'écriture immédiate dans la base
            em.flush();
            
            // 5. Valider la transaction (sauvegarder définitivement)
            em.getTransaction().commit();
            
            System.out.println("✅ Livre sauvegardé : " + l.getTitre() + " (ID: " + l.getId() + ")");
            
        } catch (Exception e) {
            // Si quelque chose se passe mal, annuler tout
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback(); // Rollback = annuler
            }
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la sauvegarde du livre", e);
        } finally {
            // Toujours fermer la connexion (libérer la mémoire)
            if (em != null) {
                em.close();
            }
        }
    }

    /**
     * Récupérer tous les livres stockés dans la base de données
     * @return Une liste contenant tous les livres
     */
    public List<Livre> findAll() {
        EntityManager em = null;
        try {
            // Ouvrir la connexion
            em = JpaUtil.getEntityManager();
            
            // Créer et exécuter une requête JPQL
            // "SELECT l FROM Livre l" signifie "récupère tous les objets Livre"
            // En SQL, cela devient : SELECT * FROM Livre
            List<Livre> list = em.createQuery("SELECT l FROM Livre l", Livre.class).getResultList();
            
            // Force le chargement de la liste des emprunts pour chaque livre
            // Sans ça, on aurait une erreur "LazyInitializationException" 
            // car la connexion serait fermée avant d'accéder aux emprunts
            list.forEach(l -> {
                if (l.getEmprunts() != null) {
                    l.getEmprunts().size(); // size() déclenche le chargement
                }
            });
            return list; // Retourne la liste complète
        } finally {
            // Fermer la connexion
            if (em != null) {
                em.close();
            }
        }
    }

    /**
     * Chercher un livre spécifique par son identifiant unique
     * @param id L'ID du livre recherché
     * @return Le livre trouvé, ou null si inexistant
     */
    public Livre findById(Long id) {
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager();
            
            // find() cherche dans la base par la clé primaire
            // SQL équivalent : SELECT * FROM Livre WHERE id = ?
            Livre l = em.find(Livre.class, id);
            
            // Force le chargement des emprunts de ce livre
            if (l != null && l.getEmprunts() != null) {
                l.getEmprunts().size();
            }
            return l;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    /**
     * Supprimer un livre de la base de données
     * @param id L'identifiant du livre à supprimer
     */
    public void delete(Long id) {
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager();
            
            // Démarrer une transaction (obligatoire pour modifier la base)
            em.getTransaction().begin();
            
            // Chercher le livre à supprimer
            Livre l = em.find(Livre.class, id);
            
            // Si le livre existe, le supprimer
            if (l != null) {
                em.remove(l); // SQL : DELETE FROM Livre WHERE id = ?
            }
            
            // Valider la suppression
            em.getTransaction().commit();
            
        } catch (Exception e) {
            // En cas d'erreur, annuler la suppression
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression du livre", e);
        } finally {
            // Toujours fermer la connexion
            if (em != null) {
                em.close();
            }
        }
    }
}