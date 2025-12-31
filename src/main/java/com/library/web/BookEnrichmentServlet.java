package com.library.web;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.library.dao.LivreDao;
import com.library.config.ApiConfig;
import com.library.model.Livre;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

// Servlet pour enrichir un livre avec les infos de Google Books (description, couverture, etc.)
@WebServlet("/api/books/enrich/*")
public class BookEnrichmentServlet extends HttpServlet {

    private final LivreDao livreDao = new LivreDao(); // DAO pour récupérer les livres
    private final HttpClient httpClient = HttpClient.newHttpClient(); // Client HTTP pour appeler l'API
    private final ObjectMapper objectMapper = createObjectMapper(); // Convertisseur JSON

    // Créer un ObjectMapper configuré pour gérer les dates Java 8
    private static ObjectMapper createObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule()); // Support LocalDateTime, LocalDate, etc.
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS); // Dates en format ISO-8601
        return mapper;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json"); // Réponse en JSON
        resp.setCharacterEncoding("UTF-8");

        // Extraire l'ID du livre depuis l'URL (/api/books/enrich/123)
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, ApiResponse.error("ID du livre manquant"));
            return;
        }

        try {
            Long livreId = Long.parseLong(pathInfo.substring(1)); // Convertir "/123" en 123
            Livre livre = livreDao.findById(livreId);

            if (livre == null) {
                sendJsonResponse(resp, HttpServletResponse.SC_NOT_FOUND, ApiResponse.error("Livre non trouvé"));
                return;
            }

            // Construire la requête de recherche (titre + auteur)
            String query = livre.getTitre();
            if (livre.getAuteur() != null) {
                query += " " + livre.getAuteur().getNom();
            }

            // Encoder la query et construire l'URL de l'API Google Books
            String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8);
            String apiUrl = ApiConfig.GOOGLE_BOOKS_API_URL + "?q=" + encodedQuery + "&maxResults=1&key=" + ApiConfig.GOOGLE_BOOKS_API_KEY;

            // Créer et envoyer la requête HTTP
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl))
                    .header("Accept", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonNode root = objectMapper.readTree(response.body()); // Parser le JSON
                Map<String, Object> enrichedData = new HashMap<>();
                enrichedData.put("titre", livre.getTitre());
                enrichedData.put("id", livre.getId());

                JsonNode items = root.get("items");
                if (items != null && items.isArray() && items.size() > 0) {
                    JsonNode volumeInfo = items.get(0).get("volumeInfo"); // Premier résultat

                    // Extraire la description si disponible
                    if (volumeInfo.has("description")) {
                        enrichedData.put("description", volumeInfo.get("description").asText());
                    }

                    // Extraire les catégories si disponibles
                    if (volumeInfo.has("categories") && volumeInfo.get("categories").isArray()) {
                        enrichedData.put("categories", volumeInfo.get("categories").get(0).asText());
                    }

                    // Extraire le nombre de pages si disponible
                    if (volumeInfo.has("pageCount")) {
                        enrichedData.put("nombrePages", volumeInfo.get("pageCount").asInt());
                    }

                    // Extraire l'image de couverture (préférer la meilleure résolution)
                    if (volumeInfo.has("imageLinks")) {
                        JsonNode imageLinks = volumeInfo.get("imageLinks");
                        String[] prefer = {"extraLarge", "large", "medium", "small", "thumbnail", "smallThumbnail"};
                        for (String key : prefer) {
                            if (imageLinks.has(key)) {
                                String url = imageLinks.get(key).asText();
                                if (url.startsWith("http://")) {
                                    url = "https://" + url.substring(7); // Forcer HTTPS
                                }
                                enrichedData.put("couverture", url);
                                break;
                            }
                        }
                    }

                    // Extraire la langue si disponible
                    if (volumeInfo.has("language")) {
                        enrichedData.put("langue", volumeInfo.get("language").asText());
                    }

                    // Extraire l'éditeur si disponible
                    if (volumeInfo.has("publisher")) {
                        enrichedData.put("editeur", volumeInfo.get("publisher").asText());
                    }

                    sendJsonResponse(resp, HttpServletResponse.SC_OK, ApiResponse.success("Informations enrichies récupérées", enrichedData));
                } else {
                    sendJsonResponse(resp, HttpServletResponse.SC_NOT_FOUND, ApiResponse.error("Aucune information supplémentaire trouvée pour ce livre"));
                }
            } else {
                sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ApiResponse.error("Erreur lors de l'appel au fournisseur externe (code=" + response.statusCode() + ")"));
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(resp, HttpServletResponse.SC_BAD_REQUEST, ApiResponse.error("ID du livre invalide"));
        } catch (Exception e) {
            sendJsonResponse(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ApiResponse.error("Erreur serveur: " + e.getMessage()));
        }
    }

    // Envoyer une réponse JSON au client
    private void sendJsonResponse(HttpServletResponse resp, int status, ApiResponse<?> apiResponse) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write(objectMapper.writeValueAsString(apiResponse));
    }
}