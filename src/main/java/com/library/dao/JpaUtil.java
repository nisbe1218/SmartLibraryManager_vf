package com.library.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Gère la connexion à la base de données
 */
public class JpaUtil {
    
    // L'usine à connexions (créée une seule fois au démarrage)
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("libraryPU");

    // Donne une connexion à la base de données
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    // Ferme l'usine (appelé à l'arrêt du serveur)
    public static void close() {
        emf.close();
    }
}
