package com.library.web;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.library.model.Utilisateur;
import java.io.IOException;
//Contrôler l'accès aux pages (sécurité et authentification)

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;// les infos  transfo
        HttpServletResponse response = (HttpServletResponse) res;// les redirections manipuler la réponse HTTP.
        HttpSession session = request.getSession(false);// stocker des infos sur l’utilisateur
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // Pages publiques (pas besoin d'authentification)
        boolean isPublicPage = uri.endsWith("/auth") || 
                              uri.endsWith("/login.jsp") || 
                              uri.endsWith("/register.jsp") ||
                              uri.contains("/css/") ||
                              uri.contains("/js/") ||
                              uri.endsWith(contextPath + "/") ||
                              uri.endsWith(contextPath);
        
        boolean isLoggedIn = (session != null && session.getAttribute("utilisateur") != null);
        
        if (isPublicPage || isLoggedIn) {
            // Vérifier les autorisations de rôle
            if (isLoggedIn && !isPublicPage) {
                Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                
                // Protéger le dashboard bibliothécaire
                if (uri.contains("/dashboard-bibliothecaire") && !utilisateur.isBibliothecaire()) {
                    response.sendRedirect(contextPath + "/dashboard-lecteur");
                    return;
                }
                
                // Protéger le dashboard lecteur
                if (uri.contains("/dashboard-lecteur") && !utilisateur.isLecteur()) {
                    response.sendRedirect(contextPath + "/dashboard-bibliothecaire");
                    return;
                }
            }
            chain.doFilter(request, response);
        } else {
            response.sendRedirect(contextPath + "/auth");
        }
    }
}
