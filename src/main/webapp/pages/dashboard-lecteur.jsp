<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.library.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Lecteur - Smart Library</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f1e8 0%, #e8dcc4 100%);
            min-height: 100vh;
            position: relative;
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=2000');
            background-size: cover;
            background-position: center;
            opacity: 0.03;
            z-index: 0;
            pointer-events: none;
        }
        
        .dashboard {
            max-width: 1600px;
            margin: 0 auto;
            padding: 30px;
            position: relative;
            z-index: 1;
        }
        
        /* Header moderne */
        .header {
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            padding: 30px 40px;
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 10px 40px rgba(139, 111, 71, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=2000');
            background-size: cover;
            background-position: center;
            opacity: 0.08;
            z-index: 0;
        }
        
        .header > * {
            position: relative;
            z-index: 1;
        }
        
        .header-left h1 {
            color: #fefdfb;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .header-left p {
            color: rgba(254, 253, 251, 0.85);
            font-size: 15px;
            font-weight: 400;
        }
        
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-badge {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            padding: 10px 20px;
            border-radius: 30px;
            color: #fefdfb;
            font-weight: 500;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .btn-header {
            padding: 12px 24px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
        }
        
        .btn-calendar {
            background: rgba(0, 184, 148, 0.2);
            color: #00b894;
            border: 2px solid #00b894;
        }
        
        .btn-calendar:hover {
            background: #00b894;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 184, 148, 0.4);
        }
        
        .btn-logout {
            background: rgba(214, 48, 49, 0.2);
            color: #d63031;
            border: 2px solid #d63031;
        }
        
        .btn-logout:hover {
            background: #d63031;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(214, 48, 49, 0.4);
        }
        
        /* Alerts modernes */
        .alert {
            padding: 18px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.4s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border-left: 5px solid #28a745;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border-left: 5px solid #dc3545;
        }
        
        /* Section moderne */
        .section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 35px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(139, 111, 71, 0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #8b6f47;
        }
        
        .section-header h2 {
            color: #654321;
            font-size: 26px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        /* Barre de recherche élégante */
        .search-bar {
            display: flex;
            gap: 15px;
            max-width: 700px;
            margin-bottom: 30px;
        }
        
        .search-input {
            flex: 1;
            padding: 16px 24px;
            border: 2px solid #e8dcc4;
            border-radius: 50px;
            font-size: 15px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background: white;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #8b6f47;
            box-shadow: 0 5px 20px rgba(139, 111, 71, 0.15);
        }
        
        .search-btn {
            padding: 16px 32px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }
        
        .search-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(139, 111, 71, 0.4);
        }
        
        /* Grille de livres moderne */
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 25px;
        }
        
        .book-card {
            background: white;
            border-radius: 18px;
            padding: 0;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            border: 2px solid transparent;
            overflow: hidden;
            position: relative;
        }
        
        .book-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 15px 40px rgba(139, 111, 71, 0.25);
            border-color: #8b6f47;
        }
        
        .book-card[data-source="google"] {
            border-color: rgba(102, 126, 234, 0.3);
        }
        
        .book-card[data-source="google"]:hover {
            border-color: #667eea;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.3);
        }
        
        .book-card img {
            width: 100%;
            height: 240px;
            object-fit: cover;
            border-radius: 16px 16px 0 0;
        }
        
        .book-card-content {
            padding: 20px;
        }
        
        .book-card h3 {
            color: #2c3e50;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 12px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 50px;
        }
        
        .book-meta {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 15px;
            font-size: 14px;
            color: #7f8c8d;
        }
        
        .book-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .book-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 12px;
        }
        
        .badge-local {
            background: linear-gradient(135deg, #e8f4f8 0%, #d1e7f0 100%);
            color: #2980b9;
        }
        
        .badge-google {
            background: linear-gradient(135deg, #f0ebff 0%, #e0d5ff 100%);
            color: #667eea;
        }
        
        .book-status {
            padding: 6px 14px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 12px;
        }
        
        .status-disponible {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #00b894;
        }
        
        .status-emprunte {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #d63031;
        }
        
        .book-description {
            font-size: 13px;
            color: #7f8c8d;
            line-height: 1.6;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .btn {
            width: 100%;
            padding: 14px 20px;
            border-radius: 12px;
            border: none;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #00b894 0%, #00cec9 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 184, 148, 0.3);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 184, 148, 0.4);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(139, 111, 71, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 111, 71, 0.4);
        }
        
        /* Onglets élégants */
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            background: #f8f9fa;
            padding: 8px;
            border-radius: 50px;
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.05);
        }
        
        .tab {
            flex: 1;
            padding: 14px 24px;
            cursor: pointer;
            border: none;
            background: transparent;
            font-size: 15px;
            font-weight: 500;
            color: #7f8c8d;
            transition: all 0.3s ease;
            border-radius: 40px;
            font-family: 'Poppins', sans-serif;
        }
        
        .tab:hover {
            background: rgba(139, 111, 71, 0.1);
            color: #8b6f47;
        }
        
        .tab.active {
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(139, 111, 71, 0.3);
            font-weight: 600;
        }
        
        .tab-content {
            display: none;
            animation: fadeIn 0.4s ease-in-out;
        }
        
        .tab-content.active {
            display: block;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Cards d'emprunts modernes */
        .emprunt-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 5px solid #8b6f47;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
        }
        
        .emprunt-card:hover {
            transform: translateX(5px);
            box-shadow: 0 6px 20px rgba(139, 111, 71, 0.15);
        }
        
        .emprunt-card h4 {
            color: #2c3e50;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 12px;
        }
        
        .emprunt-info {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #95a5a6;
            font-size: 16px;
        }
        
        .no-data svg {
            width: 80px;
            height: 80px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6);
            backdrop-filter: blur(5px);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 3% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 700px;
            box-shadow: 0 10px 50px rgba(0,0,0,0.3);
            animation: slideDown 0.3s ease-out;
        }
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px 30px;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h2 {
            margin: 0;
            font-size: 24px;
        }
        .close {
            color: white;
            font-size: 32px;
            font-weight: bold;
            cursor: pointer;
            background: none;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s;
        }
        .close:hover {
            background: rgba(255,255,255,0.2);
        }
        .modal-body {
            padding: 30px;
        }
        .book-detail-container {
            display: flex;
            gap: 25px;
            margin-bottom: 25px;
        }
        .book-detail-image {
            flex-shrink: 0;
        }
        .book-detail-image img {
            width: 200px;
            height: 280px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .book-detail-info {
            flex: 1;
        }
        .book-detail-info h3 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 22px;
        }
        .book-detail-row {
            margin-bottom: 12px;
            color: #555;
            line-height: 1.6;
        }
        .book-detail-row strong {
            color: #2c3e50;
            display: inline-block;
            min-width: 80px;
        }
        .book-description {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            line-height: 1.8;
            color: #555;
        }
        .modal-footer {
            padding: 20px 30px;
            background: #f8f9fa;
            border-radius: 0 0 15px 15px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .btn-modal {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-modal-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-modal-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-modal-secondary {
            background: #e0e0e0;
            color: #555;
        }
        .btn-modal-secondary:hover {
            background: #d0d0d0;
        }
    </style>
</head>
<body>
    <%
        Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
        Lecteur lecteur = (Lecteur) request.getAttribute("lecteur");
        List<Livre> tousLesLivres = (List<Livre>) request.getAttribute("tousLesLivres");
        List<Emprunt> empruntsEnCours = (List<Emprunt>) request.getAttribute("empruntsEnCours");
        List<Emprunt> reservations = (List<Emprunt>) request.getAttribute("reservations");
        List<Emprunt> historique = (List<Emprunt>) request.getAttribute("historique");
        
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        session.removeAttribute("success");
        session.removeAttribute("error");
    %>

    <div class="dashboard">
        <!-- Header moderne -->
        <div class="header">
            <div class="header-left">
                <h1>
                    <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    Espace Lecteur
                </h1>
                <p>Bienvenue, <%= lecteur.getNom() %></p>
            </div>
            <div class="header-right">
                <span class="user-badge">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: inline; vertical-align: middle;">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                    <%= utilisateur.getUsername() %>
                </span>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-header btn-logout">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                        <polyline points="16 17 21 12 16 7"></polyline>
                        <line x1="21" y1="12" x2="9" y2="12"></line>
                    </svg>
                    Déconnexion
                </a>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert alert-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
                <%= success %>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
                <%= error %>
            </div>
        <% } %>

        <!-- Mes emprunts et réservations -->
        <div class="section">
            <div class="section-header">
                <h2>
                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                    </svg>
                    Mes Livres
                </h2>
            </div>
            <div class="tabs">
                <button class="tab active" onclick="showTab('encours')">
                    📚 En cours (<%= empruntsEnCours.size() %>)
                </button>
                <button class="tab" onclick="showTab('reserves')">
                    🔖 Réservations (<%= reservations.size() %>)
                </button>
                <button class="tab" onclick="showTab('historique')">Historique (<%= historique.size() %>)</button>
            </div>

            <div id="encours" class="tab-content active">
                <% if (empruntsEnCours.isEmpty()) { %>
                    <p style="color: #7f8c8d;">Vous n'avez aucun emprunt en cours.</p>
                <% } else { %>
                    <% for (Emprunt emprunt : empruntsEnCours) { %>
                        <div class="emprunt-card">
                            <h4><%= emprunt.getLivre().getTitre() %></h4>
                            <div class="emprunt-info">📅 Emprunté le : <%= emprunt.getDateEmprunt() %></div>
                            <div class="emprunt-info">📆 À rendre le : <%= emprunt.getDateRetourPrevue() %>
                                <% if (emprunt.isEnRetard()) { %>
                                    <span class="badge badge-warning">⚠️ En retard</span>
                                <% } else { %>
                                    <span class="badge badge-success">✓ <%= emprunt.getJoursRestants() %> jours restants</span>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <div id="reserves" class="tab-content">
                <% if (reservations.isEmpty()) { %>
                    <p style="color: #7f8c8d;">Vous n'avez aucune réservation.</p>
                <% } else { %>
                    <% for (Emprunt reservation : reservations) { %>
                        <div class="emprunt-card">
                            <h4><%= reservation.getLivre().getTitre() %></h4>
                            <div class="emprunt-info">🔖 Réservé le : <%= reservation.getDateReservation() %></div>
                            <div class="emprunt-info">⏳ En attente de disponibilité</div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <div id="historique" class="tab-content">
                <% if (historique.isEmpty()) { %>
                    <p style="color: #7f8c8d;">Aucun historique d'emprunt.</p>
                <% } else { %>
                    <% for (Emprunt emprunt : historique) { %>
                        <div class="emprunt-card">
                            <h4><%= emprunt.getLivre().getTitre() %></h4>
                            <div class="emprunt-info">📅 Emprunté le : <%= emprunt.getDateEmprunt() %></div>
                            <div class="emprunt-info">✅ Rendu le : <%= emprunt.getDateRetourEffective() %></div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>

        <!-- Tous les livres disponibles -->
        <div class="section">
            <div class="section-header">
                <h2>
                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    Catalogue Complet
                </h2>
            </div>
            
            <!-- Barre de recherche Google Books -->
            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="🔍 Rechercher des livres sur Google Books..." class="search-input">
                <button onclick="searchGoogleBooks()" class="search-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: inline;">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    Rechercher
                </button>
            </div>
            <div id="searchMessage"></div>

            <!-- Grille de livres -->
            <div class="books-grid" id="booksGrid">
                <!-- Livres de la base de données -->
                <% for (Livre livre : tousLesLivres) { 
                    Boolean disponible = (Boolean) request.getAttribute("disponible_" + livre.getId());
                    String livreData = "{"
                        + "\"id\":\"" + livre.getId() + "\","
                        + "\"titre\":\"" + livre.getTitre().replace("\"", "\\\"").replace("\\", "\\\\") + "\","
                        + "\"auteur\":\"" + livre.getAuteur().getPrenom() + " " + livre.getAuteur().getNom() + "\","
                        + "\"annee\":\"" + livre.getAnneePublication() + "\","
                        + "\"isbn\":\"" + (livre.getIsbn() != null ? livre.getIsbn() : "") + "\","
                        + "\"description\":\"" + (livre.getDescription() != null ? livre.getDescription().replace("\"", "\\\"").replace("\\", "\\\\").replace("\n", " ").replace("\r", " ") : "Aucune description disponible") + "\","
                        + "\"imageUrl\":\"" + (livre.getImageUrl() != null ? livre.getImageUrl() : "") + "\","
                        + "\"disponible\":" + disponible
                        + "}";
                %>
                    <div class="book-card" data-source="database">
                        <% if (livre.getImageUrl() != null && !livre.getImageUrl().isEmpty()) { %>
                            <img src="<%= livre.getImageUrl() %>" alt="<%= livre.getTitre() %>">
                        <% } else { %>
                            <div style="width: 100%; height: 240px; background: linear-gradient(135deg, #e8dcc4 0%, #d4c4a8 100%); display: flex; align-items: center; justify-content: center; border-radius: 16px 16px 0 0;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="#8b6f47" stroke-width="1.5">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                            </div>
                        <% } %>
                        <div class="book-card-content">
                            <span class="book-badge badge-local">
                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: inline;">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                    <path d="M16 11h2a2 2 0 0 1 2 2v4M6 11H4a2 2 0 0 0-2 2v4"></path>
                                </svg>
                                Bibliothèque locale
                            </span>
                            <h3><%= livre.getTitre() %></h3>
                            <div class="book-meta">
                                <div class="book-meta-item">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                    <%= livre.getAuteur().getPrenom() %> <%= livre.getAuteur().getNom() %>
                                </div>
                                <div class="book-meta-item">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <%= livre.getAnneePublication() %>
                                </div>
                            </div>
                            
                            <% if (disponible) { %>
                                <span class="book-status status-disponible">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: inline;">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                    Disponible
                                </span>
                            <% } else { %>
                                <span class="book-status status-emprunte">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: inline;">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="15" y1="9" x2="9" y2="15"></line>
                                        <line x1="9" y1="9" x2="15" y2="15"></line>
                                    </svg>
                                    Non disponible
                                </span>
                            <% } %>
                            
                            <button class="btn btn-primary" onclick='showLocalBookDetails(<%= livreData %>)'>
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                                </svg>
                                Voir les détails
                            </button>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Modal pour afficher les détails du livre -->
    <div id="bookDetailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>📖 Détails du livre</h2>
                <button class="close" onclick="closeBookModal()">&times;</button>
            </div>
            <div class="modal-body" id="modalBookDetails">
                <!-- Les détails seront insérés ici -->
            </div>
            <div class="modal-footer" id="modalFooter">
                <button class="btn-modal btn-modal-secondary" onclick="closeBookModal()">Fermer</button>
                <button class="btn-modal btn-modal-primary" id="reserveBookBtn" style="display: none; background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);">
                    🔖 Réserver
                </button>
                <button class="btn-modal btn-modal-primary" id="borrowBookBtn" style="display: none;">
                    📖 Emprunter
                </button>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '<%= request.getContextPath() %>';
        const API_KEY = 'AIzaSyBJPL1TZkMKdbUs3eclTycwHCGBz3IdQ5M';
        
        function showTab(tabName) {
            // Masquer tous les contenus
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            
            // Désactiver tous les onglets
            document.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Activer le contenu et l'onglet sélectionnés
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
        }
        
        // Recherche Google Books
        async function searchGoogleBooks() {
            const query = document.getElementById('searchInput').value.trim();
            const messageDiv = document.getElementById('searchMessage');
            
            if (!query) {
                messageDiv.innerHTML = '<p style="color: #e74c3c;">⚠️ Veuillez entrer un terme de recherche</p>';
                return;
            }
            
            messageDiv.innerHTML = '<p style="color: #3498db;">🔍 Recherche en cours...</p>';
            
            try {
                const url = 'https://www.googleapis.com/books/v1/volumes?q=' + encodeURIComponent(query) + '&maxResults=20&key=' + API_KEY;
                const response = await fetch(url);
                const data = await response.json();
                
                if (data.items && data.items.length > 0) {
                    displayGoogleBooksResults(data.items);
                    messageDiv.innerHTML = '<p style="color: #27ae60;">✅ ' + data.items.length + ' livre(s) trouvé(s) sur Google Books</p>';
                } else {
                    messageDiv.innerHTML = '<p style="color: #e67e22;">ℹ️ Aucun résultat trouvé sur Google Books</p>';
                }
            } catch (error) {
                messageDiv.innerHTML = '<p style="color: #e74c3c;">❌ Erreur lors de la recherche: ' + error.message + '</p>';
            }
        }
        
        function displayGoogleBooksResults(books) {
            const grid = document.getElementById('booksGrid');
            
            // Supprimer les anciens résultats Google Books
            const oldGoogleBooks = grid.querySelectorAll('[data-source="google"]');
            oldGoogleBooks.forEach(book => book.remove());
            
            // Ajouter les nouveaux résultats
            books.forEach(book => {
                const volumeInfo = book.volumeInfo;
                const titre = volumeInfo.title || 'Sans titre';
                const auteurs = volumeInfo.authors ? volumeInfo.authors.join(', ') : 'Auteur inconnu';
                const annee = volumeInfo.publishedDate ? volumeInfo.publishedDate.substring(0, 4) : 'N/A';
                const description = volumeInfo.description || 'Aucune description disponible';
                const imageUrl = volumeInfo.imageLinks ? volumeInfo.imageLinks.thumbnail : '';
                const isbn = volumeInfo.industryIdentifiers ? volumeInfo.industryIdentifiers[0].identifier : '';
                
                const bookCard = document.createElement('div');
                bookCard.className = 'book-card';
                bookCard.setAttribute('data-source', 'google');
                
                let cardHTML = '';
                if (imageUrl) {
                    cardHTML += '<img src="' + imageUrl + '" alt="' + titre + '">';
                } else {
                    cardHTML += '<div style="width: 100%; height: 240px; background: linear-gradient(135deg, #f0ebff 0%, #e0d5ff 100%); display: flex; align-items: center; justify-content: center; border-radius: 16px 16px 0 0;">';
                    cardHTML += '<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="#667eea" stroke-width="1.5">';
                    cardHTML += '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>';
                    cardHTML += '<path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>';
                    cardHTML += '</svg></div>';
                }
                cardHTML += '<div class="book-card-content">';
                cardHTML += '<span class="book-badge badge-google">';
                cardHTML += '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: inline;">';
                cardHTML += '<circle cx="12" cy="12" r="10"></circle>';
                cardHTML += '<circle cx="12" cy="12" r="4"></circle>';
                cardHTML += '<line x1="21.17" y1="8" x2="12" y2="8"></line>';
                cardHTML += '<line x1="3.95" y1="6.06" x2="8.54" y2="14"></line>';
                cardHTML += '<line x1="10.88" y1="21.94" x2="15.46" y2="14"></line>';
                cardHTML += '</svg>';
                cardHTML += 'Google Books</span>';
                cardHTML += '<h3>' + escapeHtml(titre) + '</h3>';
                cardHTML += '<div class="book-meta">';
                cardHTML += '<div class="book-meta-item">';
                cardHTML += '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>';
                cardHTML += escapeHtml(auteurs) + '</div>';
                cardHTML += '<div class="book-meta-item">';
                cardHTML += '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>';
                cardHTML += annee + '</div></div>';
                cardHTML += '<p class="book-description">' + escapeHtml(description.substring(0, 150)) + '...</p>';
                cardHTML += '</p>';
                cardHTML += '<button class="btn btn-success" onclick=\'showBookDetailsModal("' + escapeForJs(titre) + '", "' + escapeForJs(auteurs) + '", "' + annee + '", "' + isbn + '", "' + escapeForJs(description) + '", "' + escapeForJs(imageUrl) + '")\'>';
                cardHTML += '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path></svg>';
                cardHTML += 'Voir les détails</button></div>';
                
                bookCard.innerHTML = cardHTML;
                
                grid.appendChild(bookCard);
            });
        }
        
        async function addBookToLibrary(titre, auteurs, annee, isbn, description, imageUrl) {
            const messageDiv = document.getElementById('searchMessage');
            
            try {
                const premierAuteur = auteurs.split(',')[0].trim();
                const parts = premierAuteur.split(' ');
                const prenom = parts[0] || '';
                const nom = parts.slice(1).join(' ') || prenom;

                const formData = new URLSearchParams();
                formData.append('action', 'ajouter-livre-google');
                formData.append('titre', titre);
                formData.append('auteurNomComplet', premierAuteur);
                formData.append('prenom', prenom);
                formData.append('nom', nom || premierAuteur);
                formData.append('annee', annee || '2000');
                formData.append('isbn', isbn || '');
                formData.append('description', description || '');
                formData.append('imageUrl', imageUrl || '');

                const response = await fetch(contextPath + '/dashboard-bibliothecaire', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });

                if (response.ok) {
                    messageDiv.innerHTML = '<p style="color: #27ae60; padding: 10px; background: #d4edda; border-radius: 5px;">✅ Livre ajouté avec succès à la bibliothèque ! Rechargement...</p>';
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    throw new Error('Erreur lors de l\'ajout');
                }
            } catch (error) {
                messageDiv.innerHTML = '<p style="color: #e74c3c; padding: 10px; background: #f8d7da; border-radius: 5px;">❌ Erreur: ' + error.message + '</p>';
            }
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text || '';
            return div.innerHTML;
        }
        
        function escapeForJs(str) {
            return (str || '').replace(/\\/g, '\\\\')
                               .replace(/'/g, "\\'")
                               .replace(/"/g, '\\"')
                               .replace(/\n/g, '\\n')
                               .replace(/\r/g, '\\r');
        }
        
        // Variables globales pour stocker les infos du livre sélectionné
        let selectedBookData = null;
        let isGoogleBook = false;
        
        // Afficher les détails d'un livre local
        function showLocalBookDetails(bookData) {
            selectedBookData = bookData;
            isGoogleBook = false;
            
            const modalBody = document.getElementById('modalBookDetails');
            const actionBtn = document.getElementById('actionBookBtn');
            
            let detailsHTML = '<div class="book-detail-container">';
            
            // Image du livre
            if (bookData.imageUrl) {
                detailsHTML += '<div class="book-detail-image">';
                detailsHTML += '<img src="' + bookData.imageUrl + '" alt="' + bookData.titre + '">';
                detailsHTML += '</div>';
            }
            
            // Informations du livre
            detailsHTML += '<div class="book-detail-info">';
            detailsHTML += '<h3>' + escapeHtml(bookData.titre) + '</h3>';
            detailsHTML += '<div class="book-detail-row"><strong>Auteur:</strong> ' + escapeHtml(bookData.auteur) + '</div>';
            detailsHTML += '<div class="book-detail-row"><strong>Année:</strong> ' + bookData.annee + '</div>';
            if (bookData.isbn) {
                detailsHTML += '<div class="book-detail-row"><strong>ISBN:</strong> ' + bookData.isbn + '</div>';
            }
            detailsHTML += '<div class="book-detail-row"><strong>Statut:</strong> ';
            if (bookData.disponible) {
                detailsHTML += '<span style="color: #27ae60; font-weight: 600;">✅ Disponible</span>';
            } else {
                detailsHTML += '<span style="color: #e74c3c; font-weight: 600;">❌ Non disponible</span>';
            }
            detailsHTML += '</div>';
            detailsHTML += '<div class="book-detail-row"><strong>Source:</strong> <span style="color: #2980b9;">📂 Bibliothèque locale</span></div>';
            detailsHTML += '</div>';
            detailsHTML += '</div>';
            
            // Description
            if (bookData.description && bookData.description !== 'Aucune description disponible') {
                detailsHTML += '<div class="book-description">';
                detailsHTML += '<strong style="display: block; margin-bottom: 10px; color: #2c3e50;">Description:</strong>';
                detailsHTML += escapeHtml(bookData.description);
                detailsHTML += '</div>';
            }
            
            modalBody.innerHTML = detailsHTML;
            
            // Configurer les boutons d'action
            const borrowBtn = document.getElementById('borrowBookBtn');
            const reserveBtn = document.getElementById('reserveBookBtn');
            
            // Toujours afficher les deux boutons pour les livres locaux
            borrowBtn.style.display = 'inline-flex';
            borrowBtn.onclick = function() { borrowLocalBook(bookData.id); };
            borrowBtn.disabled = !bookData.disponible;
            if (!bookData.disponible) {
                borrowBtn.style.opacity = '0.5';
                borrowBtn.style.cursor = 'not-allowed';
            } else {
                borrowBtn.style.opacity = '1';
                borrowBtn.style.cursor = 'pointer';
            }
            
            reserveBtn.style.display = 'inline-flex';
            reserveBtn.onclick = function() { reserveLocalBook(bookData.id); };
            
            document.getElementById('bookDetailsModal').style.display = 'block';
        }
        
        // Emprunter un livre local
        function borrowLocalBook(livreId) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = contextPath + '/dashboard-lecteur';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'emprunter';
            
            const livreInput = document.createElement('input');
            livreInput.type = 'hidden';
            livreInput.name = 'livreId';
            livreInput.value = livreId;
            
            form.appendChild(actionInput);
            form.appendChild(livreInput);
            document.body.appendChild(form);
            form.submit();
        }
        
        // Réserver un livre local
        function reserveLocalBook(livreId) {
            if (confirm('Voulez-vous réserver ce livre ? Vous serez notifié quand il sera disponible.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = contextPath + '/reservation';
                
                const livreInput = document.createElement('input');
                livreInput.type = 'hidden';
                livreInput.name = 'livreId';
                livreInput.value = livreId;
                
                form.appendChild(livreInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Réserver un livre local
        function reserveLocalBook(livreId) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = contextPath + '/dashboard-lecteur';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'reserver';
            
            const livreInput = document.createElement('input');
            livreInput.type = 'hidden';
            livreInput.name = 'livreId';
            livreInput.value = livreId;
            
            form.appendChild(actionInput);
            form.appendChild(livreInput);
            document.body.appendChild(form);
            form.submit();
        }
        
        // Afficher le modal avec les détails du livre Google Books
        function showBookDetailsModal(titre, auteurs, annee, isbn, description, imageUrl) {
            // Stocker les données du livre
            selectedBookData = {
                titre: titre,
                auteurs: auteurs,
                annee: annee,
                isbn: isbn,
                description: description,
                imageUrl: imageUrl
            };
            isGoogleBook = true;
            
            const modalBody = document.getElementById('modalBookDetails');
            const actionBtn = document.getElementById('actionBookBtn');
            
            let detailsHTML = '<div class="book-detail-container">';
            
            // Image du livre
            if (imageUrl) {
                detailsHTML += '<div class="book-detail-image">';
                detailsHTML += '<img src="' + imageUrl + '" alt="' + titre + '">';
                detailsHTML += '</div>';
            }
            
            // Informations du livre
            detailsHTML += '<div class="book-detail-info">';
            detailsHTML += '<h3>' + escapeHtml(titre) + '</h3>';
            detailsHTML += '<div class="book-detail-row"><strong>Auteur(s):</strong> ' + escapeHtml(auteurs) + '</div>';
            detailsHTML += '<div class="book-detail-row"><strong>Année:</strong> ' + annee + '</div>';
            if (isbn) {
                detailsHTML += '<div class="book-detail-row"><strong>ISBN:</strong> ' + isbn + '</div>';
            }
            detailsHTML += '<div class="book-detail-row"><strong>Source:</strong> <span style="color: #667eea;">🌐 Google Books</span></div>';
            detailsHTML += '</div>';
            detailsHTML += '</div>';
            
            // Description
            if (description && description !== 'Aucune description disponible') {
                detailsHTML += '<div class="book-description">';
                detailsHTML += '<strong style="display: block; margin-bottom: 10px; color: #2c3e50;">Description:</strong>';
                detailsHTML += escapeHtml(description);
                detailsHTML += '</div>';
            }
            
            modalBody.innerHTML = detailsHTML;
            
            // Configurer les boutons d'action pour Google Books
            const borrowBtn = document.getElementById('borrowBookBtn');
            const reserveBtn = document.getElementById('reserveBookBtn');
            
            // Pour Google Books, afficher les deux boutons
            borrowBtn.style.display = 'inline-flex';
            borrowBtn.onclick = borrowGoogleBook;
            borrowBtn.disabled = false;
            borrowBtn.style.opacity = '1';
            borrowBtn.style.cursor = 'pointer';
            borrowBtn.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
            
            reserveBtn.style.display = 'inline-flex';
            reserveBtn.onclick = reserveGoogleBook;
            
            document.getElementById('bookDetailsModal').style.display = 'block';
        }
        
        // Fermer le modal
        function closeBookModal() {
            document.getElementById('bookDetailsModal').style.display = 'none';
            selectedBookData = null;
            isGoogleBook = false;
        }
        
        // Réserver un livre depuis Google Books
        async function reserveGoogleBook() {
            if (!selectedBookData || !isGoogleBook) return;
            
            const messageDiv = document.getElementById('searchMessage');
            const borrowBtn = document.getElementById('borrowBookBtn');
            const reserveBtn = document.getElementById('reserveBookBtn');
            borrowBtn.disabled = true;
            reserveBtn.disabled = true;
            reserveBtn.textContent = '⏳ Ajout et réservation...';
            
            try {
                const premierAuteur = selectedBookData.auteurs.split(',')[0].trim();
                const parts = premierAuteur.split(' ');
                const prenom = parts[0] || '';
                const nom = parts.slice(1).join(' ') || prenom;

                const formData = new URLSearchParams();
                formData.append('action', 'ajouter-reserver-google');
                formData.append('titre', selectedBookData.titre);
                formData.append('auteurNomComplet', premierAuteur);
                formData.append('prenom', prenom);
                formData.append('nom', nom || premierAuteur);
                formData.append('annee', selectedBookData.annee || '2000');
                formData.append('isbn', selectedBookData.isbn || '');
                formData.append('description', selectedBookData.description || '');
                formData.append('imageUrl', selectedBookData.imageUrl || '');

                const response = await fetch(contextPath + '/dashboard-lecteur', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });

                if (response.ok) {
                    const result = await response.json();
                    
                    if (result.success) {
                        closeBookModal();
                        messageDiv.innerHTML = '<p style="color: #27ae60; padding: 15px; background: #d4edda; border-radius: 8px; font-size: 16px;">✅ Livre réservé avec succès ! Rechargement...</p>';
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        throw new Error(result.error || 'Erreur lors de la réservation du livre');
                    }
                } else {
                    throw new Error('Erreur lors de l\'ajout et de la réservation du livre');
                }
            } catch (error) {
                messageDiv.innerHTML = '<p style="color: #e74c3c; padding: 10px; background: #f8d7da; border-radius: 5px;">❌ Erreur: ' + error.message + '</p>';
                borrowBtn.disabled = false;
                reserveBtn.disabled = false;
                reserveBtn.textContent = '🔖 Réserver';
                closeBookModal();
            }
        }
        
        // Emprunter le livre depuis Google Books
        async function borrowGoogleBook() {
            if (!selectedBookData || !isGoogleBook) return;
            
            const messageDiv = document.getElementById('searchMessage');
            const borrowBtn = document.getElementById('borrowBookBtn');
            const reserveBtn = document.getElementById('reserveBookBtn');
            borrowBtn.disabled = true;
            reserveBtn.disabled = true;
            borrowBtn.textContent = '⏳ Ajout et emprunt en cours...';
            
            try {
                // Ajouter le livre et l'emprunter en une seule action
                const premierAuteur = selectedBookData.auteurs.split(',')[0].trim();
                const parts = premierAuteur.split(' ');
                const prenom = parts[0] || '';
                const nom = parts.slice(1).join(' ') || prenom;

                const formData = new URLSearchParams();
                formData.append('action', 'ajouter-emprunter-google');
                formData.append('titre', selectedBookData.titre);
                formData.append('auteurNomComplet', premierAuteur);
                formData.append('prenom', prenom);
                formData.append('nom', nom || premierAuteur);
                formData.append('annee', selectedBookData.annee || '2000');
                formData.append('isbn', selectedBookData.isbn || '');
                formData.append('description', selectedBookData.description || '');
                formData.append('imageUrl', selectedBookData.imageUrl || '');

                const response = await fetch(contextPath + '/dashboard-lecteur', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });

                if (response.ok) {
                    const result = await response.json();
                    
                    if (result.success) {
                        closeBookModal();
                        messageDiv.innerHTML = '<p style="color: #27ae60; padding: 15px; background: #d4edda; border-radius: 8px; font-size: 16px;">✅ Livre emprunté avec succès ! Rechargement...</p>';
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        throw new Error(result.error || 'Erreur lors de l\'emprunt du livre');
                    }
                } else {
                    throw new Error('Erreur lors de l\'ajout et de l\'emprunt du livre');
                }
            } catch (error) {
                messageDiv.innerHTML = '<p style="color: #e74c3c; padding: 10px; background: #f8d7da; border-radius: 5px;">❌ Erreur: ' + error.message + '</p>';
                borrowBtn.disabled = false;
                reserveBtn.disabled = false;
                borrowBtn.textContent = '📖 Emprunter';
                closeBookModal();
            }
        }
        
        // Fermer le modal si on clique en dehors
        window.onclick = function(event) {
            const modal = document.getElementById('bookDetailsModal');
            if (event.target == modal) {
                closeBookModal();
            }
        }
        
        // Charger des livres populaires au démarrage
        async function loadDefaultBooks() {
            const messageDiv = document.getElementById('searchMessage');
            
            try {
                const defaultQueries = ['bestsellers', 'popular fiction', 'science', 'histoire'];
                const randomQuery = defaultQueries[Math.floor(Math.random() * defaultQueries.length)];
                
                const url = 'https://www.googleapis.com/books/v1/volumes?q=' + randomQuery + '&maxResults=12&orderBy=relevance&key=' + API_KEY;
                const response = await fetch(url);
                const data = await response.json();
                
                if (data.items && data.items.length > 0) {
                    displayGoogleBooksResults(data.items);
                    messageDiv.innerHTML = '<p style="color: #3498db;">📚 Livres populaires chargés depuis Google Books</p>';
                }
            } catch (error) {
                console.error('Erreur lors du chargement des livres par défaut:', error);
            }
        }
        
        // Permettre la recherche avec la touche Entrée et charger des livres au démarrage
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('searchInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchGoogleBooks();
                }
            });
            
            // Charger automatiquement des livres populaires
            loadDefaultBooks();
        });
    </script>
</body>
</html>
