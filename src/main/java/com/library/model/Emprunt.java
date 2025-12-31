package com.library.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Entity
public class Emprunt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate dateEmprunt;
    private LocalDate dateRetourPrevue;
    private LocalDate dateRetourEffective;

    @Enumerated(EnumType.STRING)
    private StatutEmprunt statut;

    @ManyToOne
    @JoinColumn(name = "livre_id")
    private Livre livre;

    @ManyToOne
    @JoinColumn(name = "lecteur_id")
    private Lecteur lecteur;

    // Constante pour la durée d'emprunt
    private static final int DUREE_EMPRUNT_JOURS = 14;

    public Emprunt() {}

    public Emprunt(LocalDate dateEmprunt, LocalDate dateRetour, Livre livre, Lecteur lecteur) {
        this.dateEmprunt = dateEmprunt;
        this.dateRetourPrevue = dateEmprunt.plusDays(DUREE_EMPRUNT_JOURS);
        this.dateRetourEffective = null;
        this.statut = StatutEmprunt.EN_COURS;
        this.livre = livre;
        this.lecteur = lecteur;
    }

    // Marquer l'emprunt comme rendu (met la date de retour à aujourd'hui)
    public void marquerCommeRendu() {
        this.dateRetourEffective = LocalDate.now(); // Enregistrer la date de retour
        this.statut = StatutEmprunt.RETOURNE; // Changer le statut à RETOURNE
    }

    // Enum pour les différents statuts d'un emprunt
    public enum StatutEmprunt {
        EN_COURS,   // Le livre est toujours emprunté
        RETOURNE,   // Le livre a été rendu
        EN_RETARD   // L'emprunt est en retard
    }

    // ============ GETTERS ET SETTERS ============

    public Long getId() {
        return id;
    }

    public LocalDate getDateEmprunt() {
        return dateEmprunt;
    }

    public void setDateEmprunt(LocalDate dateEmprunt) {
        this.dateEmprunt = dateEmprunt;
    }

    public LocalDate getDateRetourPrevue() {
        return dateRetourPrevue;
    }

    public void setDateRetourPrevue(LocalDate dateRetourPrevue) {
        this.dateRetourPrevue = dateRetourPrevue;
    }

    public LocalDate getDateRetourEffective() {
        return dateRetourEffective;
    }

    public void setDateRetourEffective(LocalDate dateRetourEffective) {
        this.dateRetourEffective = dateRetourEffective;
    }

    public StatutEmprunt getStatut() {
        return statut;
    }

    public void setStatut(StatutEmprunt statut) {
        this.statut = statut;
    }

    public Livre getLivre() {
        return livre;
    }

    public void setLivre(Livre livre) {
        this.livre = livre;
    }

    public Lecteur getLecteur() {
        return lecteur;
    }

    public void setLecteur(Lecteur lecteur) {
        this.lecteur = lecteur;
    }

    // Compatibilité avec l'ancien code
    @Deprecated
    public LocalDate getDateRetour() {
        return dateRetourEffective;
    }

    @Deprecated
    public void setDateRetour(LocalDate dateRetour) {
        this.dateRetourEffective = dateRetour;
    }
}