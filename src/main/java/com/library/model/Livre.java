package com.library.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class Livre {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titre;
    private int anneePublication;
    
    private String isbn;
    
    @Column(length = 2000)
    private String description;
    
    private String imageUrl;

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
    
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public Auteur getAuteur() { return auteur; }
    public void setAuteur(Auteur auteur) { this.auteur = auteur; }
    public List<Emprunt> getEmprunts() { return emprunts; }
    public void setEmprunts(List<Emprunt> emprunts) { this.emprunts = emprunts; }
    
    // Méthode utilitaire pour getAnnee() qui retourne Integer
    public Integer getAnnee() { 
        return anneePublication > 0 ? anneePublication : null; 
    }
}
