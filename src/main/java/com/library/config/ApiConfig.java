package com.library.config;

// Configuration centralisée pour l'accès à l'API Google Books
public class ApiConfig {

    // URL de base de l'API Google Books
    public static final String GOOGLE_BOOKS_API_URL = "https://www.googleapis.com/books/v1/volumes";
    
    // Clé API Google Books
    public static final String GOOGLE_BOOKS_API_KEY = "AIzaSyBJPL1TZkMKdbUs3eclTycwHCGBz3IdQ5M";
    
    // Nombre maximum de résultats par recherche
    public static final int MAX_RESULTS_PER_SEARCH = 20;
}