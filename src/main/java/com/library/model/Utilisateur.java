package com.library.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    private LocalDateTime dateCreation;
    private LocalDateTime derniereConnexion;

    @OneToOne
    @JoinColumn(name = "lecteur_id")
    private Lecteur lecteur; // Lien vers Lecteur si c'est un utilisateur lecteur

    public enum Role {
        LECTEUR,           // Utilisateur normal
        BIBLIOTHECAIRE     // Administrateur/Employé
    }

    public Utilisateur() {
        this.dateCreation = LocalDateTime.now();
    }

    public Utilisateur(String username, String password, String email, Role role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.dateCreation = LocalDateTime.now();
    }

    // VERIFICATION
    public boolean isLecteur() {
        return this.role == Role.LECTEUR;
    }

    public boolean isBibliothecaire() {
        return this.role == Role.BIBLIOTHECAIRE;
    }

    public void updateDerniereConnexion() {
        this.derniereConnexion = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public LocalDateTime getDerniereConnexion() {
        return derniereConnexion;
    }

    public void setDerniereConnexion(LocalDateTime derniereConnexion) {
        this.derniereConnexion = derniereConnexion;
    }

    public Lecteur getLecteur() {
        return lecteur;
    }

    public void setLecteur(Lecteur lecteur) {
        this.lecteur = lecteur;
    }
}
