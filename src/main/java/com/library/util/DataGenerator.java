package com.library.util;


import com.library.dao.JpaUtil;
import com.library.model.Auteur;
import com.library.model.Livre;
import jakarta.persistence.EntityManager;

import java.util.Random;

public class DataGenerator {
    public static void main(String[] args) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        Auteur auteur = new Auteur("Hugo", "Victor");
        em.persist(auteur);
        Random r = new Random();
        for (int i = 0; i < 5000; i++) {
            Livre l = new Livre("Livre " + i, 1800 + r.nextInt(200), auteur);
            em.persist(l);
            if (i % 50 == 0) {
                em.flush();
                em.clear();
            }
        }
        em.getTransaction().commit();
        em.close();
        System.out.println("✅ 5000 livres insérés !");
    }
}
