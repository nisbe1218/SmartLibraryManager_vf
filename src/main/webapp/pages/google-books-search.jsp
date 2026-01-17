<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Utilisateur" %>
<%
    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
    boolean isAdmin = utilisateur != null && utilisateur.isBibliothecaire();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche Google Books - Smart Library</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom, #f5f1e8 0%, #e8dcc4 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(139, 111, 71, 0.15);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 2px solid rgba(139, 111, 71, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: '';
            position: absolute;
            right: -50px;
            top: 50%;
            transform: translateY(-50%);
            width: 400px;
            height: 250px;
            background: url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=800') center/cover;
            opacity: 0.08;
            border-radius: 20px;
            pointer-events: none;
        }
        
        .header-content {
            position: relative;
            z-index: 1;
        }

        .header-content h1 {
            color: #654321;
            margin-bottom: 12px;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
        }

        .header-content p {
            color: #8b6f47;
            font-size: 1rem;
            font-weight: 500;
        }

        .btn-back {
            padding: 14px 28px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(139, 111, 71, 0.3);
            display: inline-flex;
            align-items: center;
            white-space: nowrap;
            position: relative;
            z-index: 1;
        }
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(139, 111, 71, 0.3);
            display: inline-flex;
            align-items: center;
            white-space: nowrap;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 111, 71, 0.45);
        }

        .search-box {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(139, 111, 71, 0.15);
            margin-bottom: 30px;
            border: 2px solid rgba(139, 111, 71, 0.1);
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding: 16px 24px;
            border: 2px solid #e8dcc4;
            border-radius: 12px;
            font-size: 16px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
            background: #fefdfb;
            color: #2c3e50;
        }

        .search-input::placeholder {
            color: #a0826d;
        }

        .search-input:focus {
            outline: none;
            border-color: #8b6f47;
            box-shadow: 0 0 0 4px rgba(139, 111, 71, 0.15), 0 3px 8px rgba(139, 111, 71, 0.1);
            background: white;
            transform: translateY(-1px);
        }

        .btn-search {
            padding: 16px 45px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
            box-shadow: 0 4px 15px rgba(139, 111, 71, 0.3);
            letter-spacing: 0.3px;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 111, 71, 0.45);
        }

        .btn-search:active {
            transform: translateY(0);
        }

        .loading {
            text-align: center;
            padding: 40px;
            display: none;
        }

        .spinner {
            border: 5px solid #e8dcc4;
            border-top: 5px solid #8b6f47;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .message {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;\n            height: 100%;
            background-color: rgba(0,0,0,0.6);
            backdrop-filter: blur(5px);
        }

        .modal.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            padding: 40px;
            border-radius: 20px;
            max-width: 700px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 15px 50px rgba(0,0,0,0.3);
            position: relative;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: -40px -40px 30px -40px;
            padding: 30px 40px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            border-radius: 20px 20px 0 0;
        }

        .modal-header h2 {
            color: white;
            font-size: 24px;
            margin: 0;
            font-weight: 700;
        }

        .close-modal {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            font-size: 28px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .close-modal:hover {
            background: #e74c3c;
            transform: rotate(90deg);
        }

        .book-cover-large {
            width: 250px;
            height: 350px;
            margin: 0 auto 30px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .book-cover-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .detail-row {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0ebe0;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 700;
            color: #8b6f47;
            font-size: 14px;
        }

        .detail-value {
            color: #654321;
            font-size: 14px;
            line-height: 1.6;
        }

        .results {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        .book-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(255,255,255,0.95) 100%);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(139, 111, 71, 0.12);
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            border: 2px solid rgba(139, 111, 71, 0.08);
            position: relative;
            overflow: hidden;
        }

        .book-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #8b6f47 0%, #654321 100%);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 35px rgba(139, 111, 71, 0.2);
            border-color: rgba(139, 111, 71, 0.2);
        }

        .book-card:hover::before {
            opacity: 1;
        }

        .book-cover {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 18px;
            background: linear-gradient(135deg, #f5f1e8 0%, #e8dcc4 100%);
            border: 3px solid rgba(139, 111, 71, 0.1);
            transition: all 0.3s;
        }

        .book-card:hover .book-cover {
            border-color: rgba(139, 111, 71, 0.25);
        }

        .book-title {
            color: #654321;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .book-info {
            color: #8b6f47;
            font-size: 0.9rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .book-description {
            color: #666;
            font-size: 0.85rem;
            line-height: 1.5;
            margin: 15px 0;
            flex-grow: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .btn-add {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
            margin-top: auto;
            box-shadow: 0 4px 15px rgba(139, 111, 71, 0.25);
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 111, 71, 0.35);
        }

        .btn-add svg {
            width: 18px;
            height: 18px;
        }

        .btn-add:active {
            transform: translateY(0);
        }

        .btn-add:disabled {
            background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .no-results {
            grid-column: 1 / -1;
            text-align: center;
            padding: 80px 30px;
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            border-radius: 20px;
            color: #8b6f47;
            font-size: 1.1rem;
            border: 2px dashed rgba(139, 111, 71, 0.2);
        }

        .no-results .icon {
            font-size: 5rem;
            margin-bottom: 25px;
            opacity: 0.7;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div class="header-content">
            <h1>
                <svg style="width: 36px; height: 36px; vertical-align: middle; margin-right: 12px; stroke: #8b6f47;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.35-4.35"></path>
                </svg>
                Recherche Google Books
            </h1>
            <p>Recherchez et ajoutez des livres depuis Google Books à votre bibliothèque</p>
        </div>
        <% if (isAdmin) { %>
            <a href="${pageContext.request.contextPath}/dashboard-bibliothecaire" class="btn-back">
                <svg style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Retour au dashboard
            </a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/dashboard-lecteur" class="btn-back">
                <svg style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Retour au dashboard
            </a>
        <% } %>
    </div>

    <div class="search-box">
        <form class="search-form" onsubmit="searchBooks(event)">
            <input type="text"
                   id="searchQuery"
                   class="search-input"
                   placeholder="🔍 Rechercher par titre, auteur, ISBN..."
                   required>
            <button type="submit" class="btn-search">Rechercher</button>
        </form>
    </div>

    <div id="message"></div>

    <div id="loading" class="loading">
        <div class="spinner"></div>
        <p>Recherche en cours dans Google Books...</p>
    </div>

    <div id="results" class="results"></div>
</div>

<!-- Modal Détails du livre -->
<div id="bookDetailsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>📖 Détails du livre</h2>
            <button class="close-modal" onclick="closeDetailsModal()">&times;</button>
        </div>
        <div id="bookDetailsContent">
            <!-- Le contenu sera inséré dynamiquement par JavaScript -->
        </div>
    </div>
</div>

<script>
    const API_KEY = 'AIzaSyBJPL1TZkMKdbUs3eclTycwHCGBz3IdQ5M';
    const API_URL = 'https://www.googleapis.com/books/v1/volumes';
    const contextPath = '<%= request.getContextPath() %>';
    const isAdmin = <%= isAdmin %>;

    async function searchBooks(event) {
        event.preventDefault();

        const query = document.getElementById('searchQuery').value;
        const loading = document.getElementById('loading');
        const results = document.getElementById('results');
        const message = document.getElementById('message');

        loading.style.display = 'block';
        results.innerHTML = '';
        message.innerHTML = '';

        try {
            const url = API_URL + '?q=' + encodeURIComponent(query) + '&maxResults=40&langRestrict=fr&key=' + API_KEY;
            const response = await fetch(url);
            const data = await response.json();

            loading.style.display = 'none';
            displayResults(data);
        } catch (error) {
            loading.style.display = 'none';
            message.innerHTML = '<div class="message error">❌ Erreur lors de la recherche: ' + error.message + '</div>';
        }
    }

    function showBookDetails(titre, auteurs, annee, isbn, description, imageUrl) {
        let content = '';
        
        if (imageUrl && imageUrl.trim() !== '' && imageUrl !== 'undefined') {
            content += '<div class="book-cover-large">';
            content += '<img src="' + imageUrl + '" alt="' + titre + '">';
            content += '</div>';
        }
        
        content += '<div class="detail-row">';
        content += '<div class="detail-label">📖 Titre</div>';
        content += '<div class="detail-value"><strong>' + titre + '</strong></div>';
        content += '</div>';
        
        content += '<div class="detail-row">';
        content += '<div class="detail-label">✍️ Auteur(s)</div>';
        content += '<div class="detail-value">' + auteurs + '</div>';
        content += '</div>';
        
        if (annee && annee !== 'undefined' && annee !== '') {
            content += '<div class="detail-row">';
            content += '<div class="detail-label">📅 Année</div>';
            content += '<div class="detail-value">' + annee + '</div>';
            content += '</div>';
        }
        
        if (isbn && isbn !== 'undefined' && isbn !== '') {
            content += '<div class="detail-row">';
            content += '<div class="detail-label">🔢 ISBN</div>';
            content += '<div class="detail-value">' + isbn + '</div>';
            content += '</div>';
        }
        
        if (description && description !== 'undefined' && description !== '') {
            content += '<div class="detail-row">';
            content += '<div class="detail-label">📝 Description</div>';
            content += '<div class="detail-value">' + description + '</div>';
            content += '</div>';
        } else {
            content += '<div class="detail-row">';
            content += '<div class="detail-label">📝 Description</div>';
            content += '<div class="detail-value">Aucune description disponible</div>';
            content += '</div>';
        }
        
        document.getElementById('bookDetailsContent').innerHTML = content;
        document.getElementById('bookDetailsModal').classList.add('active');
    }
    
    function closeDetailsModal() {
        document.getElementById('bookDetailsModal').classList.remove('active');
    }
    
    // Fermer le modal en cliquant à l'extérieur
    window.onclick = function(event) {
        const modal = document.getElementById('bookDetailsModal');
        if (event.target === modal) {
            closeDetailsModal();
        }
    }

    async function addBook(titre, auteurs, annee, isbn, description, imageUrl) {
        const message = document.getElementById('message');
        
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
                message.innerHTML = '<div class="message success"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg> Livre ajouté avec succès à la bibliothèque !</div>';
                setTimeout(function() {
                    message.innerHTML = '';
                }, 3000);
            } else {
                throw new Error('Erreur lors de l\'ajout');
            }
        } catch (error) {
            message.innerHTML = '<div class="message error"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg> Erreur: ' + error.message + '</div>';
        }
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text || '';
        return div.innerHTML;
    }
    
    function escapeForJs(text) {
        return (text || '').replace(/'/g, "\\'").replace(/"/g, '\\"');
    }
    
    // Charger automatiquement des livres populaires au démarrage
    window.addEventListener('DOMContentLoaded', function() {
        loadPopularBooks();
    });
    
    function loadPopularBooks() {
        const loading = document.getElementById('loading');
        const results = document.getElementById('results');
        const message = document.getElementById('message');
        
        loading.style.display = 'block';
        results.innerHTML = '';
        
        // Rechercher des livres populaires en français
        const queries = ['bestseller', 'roman français', 'classique littérature'];
        const randomQuery = queries[Math.floor(Math.random() * queries.length)];
        
        const url = API_URL + '?q=' + encodeURIComponent(randomQuery) + '&maxResults=40&langRestrict=fr&orderBy=relevance&key=' + API_KEY;
        
        fetch(url)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                loading.style.display = 'none';
                displayResults(data);
            })
            .catch(function(error) {
                loading.style.display = 'none';
                message.innerHTML = '<div class="message error">❌ Erreur lors du chargement: ' + error.message + '</div>';
            });
    }
    
    function displayResults(data) {
        const results = document.getElementById('results');
        const message = document.getElementById('message');
        
        if (data.items && data.items.length > 0) {
            let html = '';
            data.items.forEach(function(item) {
                const book = item.volumeInfo;
                const titre = book.title || 'Titre inconnu';
                const auteurs = book.authors ? book.authors.join(', ') : 'Auteur inconnu';
                const annee = book.publishedDate ? book.publishedDate.substring(0, 4) : '';
                const description = book.description || 'Aucune description disponible';
                const couverture = (book.imageLinks && book.imageLinks.thumbnail) ? book.imageLinks.thumbnail : '';
                const imageUrl = couverture ? couverture.replace('http:', 'https:') : '';
                const isbn = (book.industryIdentifiers && book.industryIdentifiers[0]) ? book.industryIdentifiers[0].identifier : '';
                
                html += '<div class="book-card">';
                
                if (couverture) {
                    html += '<img src="' + imageUrl + '" alt="' + escapeHtml(titre) + '" class="book-cover">';
                } else {
                    html += '<div class="book-cover" style="display:flex;align-items:center;justify-content:center;font-size:3rem;">📖</div>';
                }
                
                html += '<div class="book-title">' + escapeHtml(titre) + '</div>';
                html += '<div class="book-info">✍️ ' + escapeHtml(auteurs) + '</div>';
                
                if (annee) {
                    html += '<div class="book-info">📅 ' + annee + '</div>';
                }
                
                if (isbn) {
                    html += '<div class="book-info">🔢 ' + isbn + '</div>';
                }
                
                html += '<div class="book-description">' + escapeHtml(description.substring(0, 200)) + '...</div>';
                
                // Different buttons based on user role
                if (isAdmin) {
                    // Admin sees "Voir les détails" button
                    html += '<button class="btn-add" onclick="showBookDetails(\'' + escapeForJs(titre) + '\', \'' + escapeForJs(auteurs) + '\', \'' + annee + '\', \'' + isbn + '\', \'' + escapeForJs(description) + '\', \'' + escapeForJs(imageUrl) + '\')">';
                    html += '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>';
                    html += 'Voir les détails</button>';
                } else {
                    // Lecteur sees "Ajouter à ma bibliothèque" button
                    html += '<button class="btn-add" onclick="addBook(\'' + escapeForJs(titre) + '\', \'' + escapeForJs(auteurs) + '\', \'' + annee + '\', \'' + isbn + '\', \'' + escapeForJs(description) + '\', \'' + escapeForJs(imageUrl) + '\')">';
                    html += '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>';
                    html += 'Ajouter à ma bibliothèque</button>';
                }
                
                html += '</div>';
            });
            results.innerHTML = html;
        } else {
            results.innerHTML = '<div class="no-results"><div class="icon">📚</div><p>Aucun livre disponible</p><p style="margin-top: 10px; font-size: 0.9rem;">Utilisez la recherche pour trouver des livres</p></div>';
        }
    }
</script>
</body>
</html>
