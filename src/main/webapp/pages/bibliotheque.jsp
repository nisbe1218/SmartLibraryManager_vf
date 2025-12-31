<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bibliothèque - SmartLibrary</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom, #f9f6f1 0%, #ffffff 100%);
            min-height: 100vh;
        }

        /* Header Navigation - Même style que l'accueil */
        .top-nav {
            background: #ffffff;
            padding: 1.5rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .logo-home {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2d5a5a;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 3rem;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: #2d3436;
            font-weight: 500;
            font-size: 1rem;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: #00b894;
        }

        /* Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 3rem;
        }

        /* Hero Section colorée */
        .library-hero {
            text-align: center;
            padding: 4rem 2rem;
            margin-bottom: 3rem;
        }

        .library-hero h1 {
            font-size: 4rem;
            color: #2d5a5a;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .library-hero p {
            font-size: 1.25rem;
            color: #636e72;
            line-height: 1.8;
        }

        /* Search Section */
        .search-section {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 3rem;
        }

        .search-container {
            display: flex;
            gap: 1rem;
            max-width: 800px;
            margin: 0 auto;
        }

        .search-input {
            flex: 1;
            padding: 1rem 1.5rem;
            border: 2px solid #e8e8e8;
            border-radius: 50px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #00b894;
            box-shadow: 0 0 0 4px rgba(0, 184, 148, 0.1);
        }

        .search-btn {
            padding: 1rem 3rem;
            background: linear-gradient(135deg, #d4842f 0%, #c67228 100%);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(212, 132, 47, 0.3);
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(212, 132, 47, 0.4);
        }

        /* Book Cards - Couleurs vives comme l'accueil */
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .book-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .book-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #00b894, #6c5ce7, #fd79a8, #fdcb6e);
        }

        .book-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 35px rgba(0, 184, 148, 0.2);
        }

        .book-cover {
            width: 100%;
            height: 350px;
            object-fit: cover;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        }

        .book-info {
            padding: 1.5rem;
        }

        .book-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .book-authors {
            font-size: 0.9rem;
            color: #00b894;
            margin-bottom: 0.75rem;
            font-weight: 500;
        }

        .book-description {
            font-size: 0.875rem;
            color: #a0aec0;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .loading {
            text-align: center;
            padding: 4rem 2rem;
            font-size: 1.25rem;
            color: #2d5a5a;
        }

        .loading-spinner {
            display: inline-block;
            width: 50px;
            height: 50px;
            border: 5px solid #f3f4f6;
            border-top: 5px solid #00b894;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .no-results {
            text-align: center;
            padding: 4rem 2rem;
            color: #636e72;
        }

        /* Category Tags - Couleurs vives */
        .category-tags {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .category-tag {
            padding: 0.75rem 1.5rem;
            background: white;
            border: 2px solid #e8e8e8;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .category-tag:hover, .category-tag.active {
            background: linear-gradient(135deg, #00b894 0%, #00a383 100%);
            color: white;
            border-color: #00b894;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 184, 148, 0.3);
        }

        /* Modal pour les détails du livre */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.7);
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background: white;
            margin: 2% auto;
            padding: 0;
            border-radius: 20px;
            max-width: 900px;
            width: 90%;
            box-shadow: 0 10px 50px rgba(0,0,0,0.3);
            animation: slideDown 0.3s ease;
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
            background: linear-gradient(135deg, #00b894 0%, #00a383 100%);
            color: white;
            padding: 2rem;
            border-radius: 20px 20px 0 0;
            position: relative;
        }

        .close {
            position: absolute;
            right: 1.5rem;
            top: 1.5rem;
            color: white;
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .close:hover {
            transform: scale(1.2);
        }

        .modal-body {
            padding: 2rem;
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 2rem;
        }

        .modal-book-cover {
            width: 100%;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .modal-book-info h2 {
            color: #2d5a5a;
            margin-bottom: 1rem;
            font-size: 2rem;
        }

        .modal-book-info .authors {
            color: #00b894;
            font-size: 1.125rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .book-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .meta-item {
            background: linear-gradient(135deg, #f9f6f1 0%, #ffffff 100%);
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-size: 0.875rem;
            border: 2px solid #e8e8e8;
        }

        .meta-label {
            color: #636e72;
            font-weight: 500;
        }

        .meta-value {
            color: #2d3748;
            font-weight: 600;
        }

        .book-description-full {
            color: #4a5568;
            line-height: 1.8;
            margin-bottom: 1.5rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn-add-library {
            flex: 1;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #d4842f 0%, #c67228 100%);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(212, 132, 47, 0.3);
        }

        .btn-add-library:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(212, 132, 47, 0.4);
        }

        @media (max-width: 768px) {
            .modal-body {
                grid-template-columns: 1fr;
            }

            .modal-book-cover {
                max-width: 300px;
                margin: 0 auto;
            }

            .library-hero h1 {
                font-size: 2.5rem;
            }

            .nav-links {
                flex-wrap: wrap;
                gap: 1rem;
                font-size: 0.9rem;
            }

            .top-nav {
                padding: 1rem 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation - Même style que l'accueil -->
    <nav class="top-nav">
        <a href="${pageContext.request.contextPath}/" class="logo-home">📚 SmartLibrary</a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/auteurs">AUTEURS</a></li>
            <li><a href="${pageContext.request.contextPath}/livres">LIVRES</a></li>
            <li><a href="${pageContext.request.contextPath}/lecteurs">LECTEURS</a></li>
            <li><a href="${pageContext.request.contextPath}/emprunts">EMPRUNTS</a></li>
        </ul>
    </nav>

    <div class="container">
    <div class="library-hero">
        <h1>📚 Découvrez notre bibliothèque</h1>
        <p>Explorez des milliers de livres disponibles via Google Books</p>
    </div>

    <div class="search-section">
        <div class="search-container">
            <input type="text" 
                   id="searchInput" 
                   class="search-input" 
                   placeholder="Rechercher un livre, auteur, ISBN..."
                   onkeypress="if(event.key === 'Enter') searchBooks()">
            <button class="search-btn" onclick="searchBooks()">🔍 Rechercher</button>
        </div>
    </div>

    <div class="category-tags">
        <button class="category-tag" onclick="searchByCategory('bestsellers')">📈 Bestsellers</button>
        <button class="category-tag" onclick="searchByCategory('fiction')">📖 Fiction</button>
        <button class="category-tag" onclick="searchByCategory('science')">🔬 Science</button>
        <button class="category-tag" onclick="searchByCategory('technology')">💻 Technologie</button>
        <button class="category-tag" onclick="searchByCategory('history')">🏛️ Histoire</button>
        <button class="category-tag" onclick="searchByCategory('art')">🎨 Art</button>
        <button class="category-tag" onclick="searchByCategory('cooking')">🍳 Cuisine</button>
    </div>

    <div id="booksContainer">
        <div class="loading">
            <div class="loading-spinner"></div>
            <p style="margin-top: 1rem;">Chargement des livres...</p>
        </div>
    </div>
</div>

<!-- Modal pour les détails du livre -->
<div id="bookModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle">Détails du livre</h2>
        </div>
        <div class="modal-body" id="modalBody">
            <div class="loading">
                <div class="loading-spinner"></div>
                <p style="margin-top: 1rem;">Chargement des détails...</p>
            </div>
        </div>
    </div>
</div>

<script>
    let currentQuery = 'bestsellers+fiction';

    // Charger les livres au démarrage
    window.addEventListener('load', function() {
        console.log('Page chargée, chargement des livres...');
        loadBooks(currentQuery);
    });

    function searchBooks() {
        const query = document.getElementById('searchInput').value.trim();
        if (query) {
            currentQuery = query;
            loadBooks(query);
        }
    }

    function searchByCategory(category) {
        // Retirer la classe active de tous les tags
        document.querySelectorAll('.category-tag').forEach(tag => {
            tag.classList.remove('active');
        });
        
        // Ajouter la classe active au tag cliqué
        event.target.classList.add('active');
        
        currentQuery = category;
        loadBooks(category);
    }

    function loadBooks(query) {
        console.log('Chargement des livres pour:', query);
        const container = document.getElementById('booksContainer');
        container.innerHTML = '<div class="loading"><div class="loading-spinner"></div><p style="margin-top: 1rem;">Chargement des livres...</p></div>';

        // Utiliser l'API Google Books sans clé API (gratuit avec limitation)
        const url = 'https://www.googleapis.com/books/v1/volumes?q=' + encodeURIComponent(query) + '&maxResults=40&langRestrict=fr';

        console.log('URL de l\'API:', url);

        fetch(url)
            .then(response => {
                console.log('Réponse reçue:', response.status);
                if (!response.ok) {
                    throw new Error('Erreur HTTP: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Données reçues:', data);
                if (data.items && data.items.length > 0) {
                    console.log('Nombre de livres:', data.items.length);
                    displayBooks(data.items);
                } else {
                    console.log('Aucun livre trouvé');
                    container.innerHTML = '<div class="no-results"><h2>😕 Aucun livre trouvé</h2><p>Essayez une autre recherche</p></div>';
                }
            })
            .catch(error => {
                console.error('Erreur complète:', error);
                container.innerHTML = '<div class="no-results"><h2>❌ Erreur de chargement</h2><p>Erreur: ' + error.message + '</p><p>Veuillez vérifier la console pour plus de détails.</p></div>';
            });
    }

    function displayBooks(books) {
        console.log('Affichage de', books.length, 'livres');
        const container = document.getElementById('booksContainer');
        let html = '<div class="books-grid">';

        books.forEach(book => {
            const info = book.volumeInfo;
            const thumbnail = info.imageLinks ? info.imageLinks.thumbnail : '';
            const title = (info.title || 'Sans titre').replace(/'/g, "\\'");
            const authors = info.authors ? info.authors.join(', ') : 'Auteur inconnu';
            const description = info.description ? info.description.substring(0, 150).replace(/'/g, "\\'") + '...' : 'Aucune description disponible';

            html += '<div class="book-card" onclick="showBookDetails(\'' + book.id + '\')">';
            if (thumbnail) {
                html += '<img src="' + thumbnail.replace('http:', 'https:') + '" alt="' + title + '" class="book-cover">';
            } else {
                html += '<div class="book-cover" style="display: flex; align-items: center; justify-content: center; font-size: 3rem;">📚</div>';
            }
            html += '<div class="book-info">';
            html += '<div class="book-title">' + title + '</div>';
            html += '<div class="book-authors">' + authors + '</div>';
            html += '<div class="book-description">' + description + '</div>';
            html += '</div>';
            html += '</div>';
        });

        html += '</div>';
        container.innerHTML = html;
        console.log('Livres affichés avec succès');
    }

    function showBookDetails(bookId) {
        console.log('Affichage des détails pour:', bookId);
        const modal = document.getElementById('bookModal');
        const modalBody = document.getElementById('modalBody');
        
        modal.style.display = 'block';
        modalBody.innerHTML = '<div class="loading"><div class="loading-spinner"></div><p style="margin-top: 1rem;">Chargement des détails...</p></div>';

        const url = 'https://www.googleapis.com/books/v1/volumes/' + bookId;

        fetch(url)
            .then(response => response.json())
            .then(data => {
                displayBookDetails(data);
            })
            .catch(error => {
                console.error('Erreur:', error);
                modalBody.innerHTML = '<div class="no-results"><h2>❌ Erreur</h2><p>Impossible de charger les détails du livre.</p></div>';
            });
    }

    function displayBookDetails(book) {
        const info = book.volumeInfo;
        const modalBody = document.getElementById('modalBody');
        
        const thumbnail = info.imageLinks ? (info.imageLinks.large || info.imageLinks.medium || info.imageLinks.thumbnail) : '';
        const title = info.title || 'Sans titre';
        const authors = info.authors ? info.authors.join(', ') : 'Auteur inconnu';
        const publisher = info.publisher || 'Non spécifié';
        const publishedDate = info.publishedDate || 'Non spécifié';
        const pageCount = info.pageCount || 'Non spécifié';
        const language = info.language || 'Non spécifié';
        const categories = info.categories ? info.categories.join(', ') : 'Non spécifié';
        const description = info.description || 'Aucune description disponible';
        const isbn = info.industryIdentifiers ? info.industryIdentifiers[0].identifier : 'Non spécifié';

        let html = '<div>';
        
        // Image de couverture
        if (thumbnail) {
            html += '<img src="' + thumbnail.replace('http:', 'https:') + '" alt="' + title + '" class="modal-book-cover">';
        } else {
            html += '<div class="modal-book-cover" style="display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); height: 400px; font-size: 5rem;">📚</div>';
        }
        
        html += '</div><div class="modal-book-info">';
        html += '<h2>' + title + '</h2>';
        html += '<div class="authors">' + authors + '</div>';
        
        html += '<div class="book-meta">';
        html += '<div class="meta-item"><span class="meta-label">Éditeur:</span> <span class="meta-value">' + publisher + '</span></div>';
        html += '<div class="meta-item"><span class="meta-label">Date:</span> <span class="meta-value">' + publishedDate + '</span></div>';
        html += '<div class="meta-item"><span class="meta-label">Pages:</span> <span class="meta-value">' + pageCount + '</span></div>';
        html += '<div class="meta-item"><span class="meta-label">Langue:</span> <span class="meta-value">' + language + '</span></div>';
        html += '<div class="meta-item"><span class="meta-label">ISBN:</span> <span class="meta-value">' + isbn + '</span></div>';
        html += '<div class="meta-item"><span class="meta-label">Catégories:</span> <span class="meta-value">' + categories + '</span></div>';
        html += '</div>';
        
        html += '<div class="book-description-full">' + description + '</div>';
        
        html += '<div class="action-buttons">';
        html += '<button class="btn-add-library" onclick="addToLibrary(\'' + book.id + '\', \'' + title.replace(/'/g, "\\'") + '\', \'' + authors.replace(/'/g, "\\'") + '\', \'' + isbn + '\')">➕ Ajouter à ma bibliothèque</button>';
        html += '</div>';
        
        html += '</div>';
        
        modalBody.innerHTML = html;
    }

    function closeModal() {
        document.getElementById('bookModal').style.display = 'none';
    }

    function addToLibrary(bookId, title, authors, isbn) {
        console.log('Ajout à la bibliothèque:', title);
        
        // Fermer le modal de détails
        closeModal();
        
        // Récupérer les informations complètes du livre
        const url = 'https://www.googleapis.com/books/v1/volumes/' + bookId;
        
        fetch(url)
            .then(response => response.json())
            .then(data => {
                const info = data.volumeInfo;
                const bookTitle = info.title || 'Sans titre';
                const bookAuthors = info.authors ? info.authors.join(', ') : 'Auteur inconnu';
                const bookYear = info.publishedDate || '';
                const bookIsbn = info.industryIdentifiers ? info.industryIdentifiers[0].identifier : '';
                
                // Créer un formulaire caché et le soumettre
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/addFromApi';
                
                const inputTitre = document.createElement('input');
                inputTitre.type = 'hidden';
                inputTitre.name = 'titre';
                inputTitre.value = bookTitle;
                form.appendChild(inputTitre);
                
                const inputAuteur = document.createElement('input');
                inputAuteur.type = 'hidden';
                inputAuteur.name = 'auteur';
                inputAuteur.value = bookAuthors;
                form.appendChild(inputAuteur);
                
                const inputAnnee = document.createElement('input');
                inputAnnee.type = 'hidden';
                inputAnnee.name = 'annee';
                inputAnnee.value = bookYear;
                form.appendChild(inputAnnee);
                
                const inputIsbn = document.createElement('input');
                inputIsbn.type = 'hidden';
                inputIsbn.name = 'isbn';
                inputIsbn.value = bookIsbn;
                form.appendChild(inputIsbn);
                
                document.body.appendChild(form);
                form.submit();
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('❌ Erreur lors de l\'ajout du livre');
            });
    }

    // Fermer le modal en cliquant en dehors
    window.onclick = function(event) {
        const modal = document.getElementById('bookModal');
        if (event.target == modal) {
            closeModal();
        }
    }
</script>
</body>
</html>
