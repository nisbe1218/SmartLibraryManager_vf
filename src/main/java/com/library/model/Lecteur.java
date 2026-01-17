package com.library.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class Lecteur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nom;
    private String email;
    
    @OneToOne(mappedBy = "lecteur")
    private Utilisateur utilisateur; // Lien vers le compte utilisateur

    @OneToMany(mappedBy = "lecteur", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Emprunt> emprunts;

    public Lecteur() {}

    public Lecteur(String nom, String email) {
        this.nom = nom;
        this.email = email;
    }

    // --- Getters & Setters ---
    public Long getId() { return id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public List<Emprunt> getEmprunts() { return emprunts; }
    public void setEmprunts(List<Emprunt> emprunts) { this.emprunts = emprunts; }
    public Utilisateur getUtilisateur() { return utilisateur; }
    public void setUtilisateur(Utilisateur utilisateur) { this.utilisateur = utilisateur; }


}
