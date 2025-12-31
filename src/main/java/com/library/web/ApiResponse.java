package com.library.web;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.time.LocalDateTime;

// Classe pour formater les réponses JSON de manière uniforme (succès ou erreur)
@JsonInclude(JsonInclude.Include.NON_NULL) // Ne pas inclure les champs null dans le JSON
public class ApiResponse<T> {

    private boolean success; // true = succès, false = erreur
    private String message; // Message descriptif pour l'utilisateur
    private T data; // Les données à renvoyer (livre, auteur, etc.)
    private String error; // Message d'erreur technique
    private LocalDateTime timestamp; // Horodatage de la réponse

    // Constructeur : initialise l'horodatage à maintenant
    public ApiResponse() {
        this.timestamp = LocalDateTime.now();
    }

    // Créer une réponse de succès avec uniquement des données
    public static <T> ApiResponse<T> success(T data) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setSuccess(true);
        response.setData(data);
        return response;
    }

    // Créer une réponse de succès avec message + données
    public static <T> ApiResponse<T> success(String message, T data) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setSuccess(true);
        response.setMessage(message);
        response.setData(data);
        return response;
    }

    // Créer une réponse d'erreur avec uniquement un message
    public static <T> ApiResponse<T> error(String error) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setSuccess(false);
        response.setError(error);
        return response;
    }

    // Créer une réponse d'erreur avec message utilisateur + message technique
    public static <T> ApiResponse<T> error(String message, String error) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setSuccess(false);
        response.setMessage(message);
        response.setError(error);
        return response;
    }

    // Créer une réponse d'erreur avec message + données de diagnostic
    public static <T> ApiResponse<T> error(String message, T data) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setSuccess(false);
        response.setMessage(message);
        response.setData(data);
        return response;
    }

    // Getters et Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public T getData() { return data; }
    public void setData(T data) { this.data = data; }

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
