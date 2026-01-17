package com.library.dao;

import com.library.model.Livre;
import jakarta.persistence.EntityManager;
import java.util.List;

/**

 * CRUD = Create (créer), Read (lire), Update (modifier), Delete (supprimer)
 */
public class LivreDao {
    

    public void save(Livre l) {
        EntityManager em = null; // Le gestionnaire de base de données
        try {

            em = JpaUtil.getEntityManager();
            

            em.getTransaction().begin();
            

            em.persist(l);
            

            em.flush();
            

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