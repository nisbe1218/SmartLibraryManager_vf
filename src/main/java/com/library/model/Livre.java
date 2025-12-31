package com.library.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class Livre {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titre;
    private int anneePublication;

    @ManyToOne
    @JoinColumn(name = "auteur_id")
    private Auteur auteur;

    @OneToMany(mappedBy = "livre", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Emprunt> emprunts;

    public Livre() {}
    public Livre(String titre, int anneePublication, Auteur auteur) {
        this.titre = titre;
        this.anneePublication = anneePublication;
        this.auteur = auteur;
    }

    public Long getId() { return id; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public int getAnneePublication() { return anneePublication; }
    public void setAnneePublication(int anneePublication) { this.anneePublication = anneePublication; }
    public Auteur getAuteur() { return auteur; }
    public void setAuteur(Auteur auteur) { this.auteur = auteur; }
    public List<Emprunt> getEmprunts() { return emprunts; }
    public void setEmprunts(List<Emprunt> emprunts) { this.emprunts = emprunts; }
}
