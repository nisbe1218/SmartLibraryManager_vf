<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche de livres - Open Library API</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 30px;
            text-align: center;
        }

        .header h1 {
            color: #667eea;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
        }

        .search-box {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 30px;
        }

        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-input {
            flex: 1;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-search {
            background: #667eea;
            color: white;
        }

        .btn-search:hover {
            background: #5568d3;
            transform: translateY(-2px);
        }

        .btn-add {
            background: #10b981;
            color: white;
            padding: 10px 20px;
            font-size: 14px;
        }

        .btn-add:hover {
            background: #059669;
        }

        .btn-back {
            background: #6b7280;
            color: white;
            display: inline-block;
            text-decoration: none;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background: #4b5563;
        }

        .loading {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 15px;
            display: none;
        }

        .spinner {
            border: 4px solid #f3f4f6;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .results {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .book-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .book-title {
            color: #1f2937;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .book-info {
            color: #6b7280;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .book-info strong {
            color: #374151;
        }

        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 600;
        }

        .success {
            background: #d1fae5;
            color: #065f46;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }

        .no-results {
            background: white;
            padding: 60px;
            border-radius: 15px;
            text-align: center;
            color: #6b7280;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/livres" class="btn btn-back">← Retour aux livres</a>

    <div class="header">
        <h1>🔍 Recherche de livres</h1>
        <p>Recherchez des livres dans la base Open Library et ajoutez-les à votre bibliothèque</p>
    </div>

    <div class="search-box">
        <form class="search-form" onsubmit="searchBooks(event)">
            <input type="text"
                   id="searchQuery"
                   class="search-input"
                   placeholder="Entrez un titre, auteur ou ISBN..."
                   required>
            <button type="submit" class="btn btn-search">Rechercher</button>
        </form>
    </div>

    <div id="message"></div>

    <div id="loading" class="loading">
        <div class="spinner"></div>
        <p>Recherche en cours...</p>
    </div>

    <div id="results" class="results"></div>
</div>

<script>
    async function searchBooks(event) {
        event.preventDefault();

        const query = document.getElementById('searchQuery').value;
        const loading = document.getElementById('loading');
        const results = document.getElementById('results');
        const message = document.getElementById('message');

        // Afficher le loading
        loading.style.display = 'block';
        results.innerHTML = '';
        message.innerHTML = '';

        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/books/search?query=${encodeURIComponent(query)}`);
            const data = await response.json();

            loading.style.display = 'none';

            if (data.success && data.books && data.books.length > 0) {
                results.innerHTML = data.books.map(book => `
                    <div class="book-card">
                        <div class="book-title">${escapeHtml(book.titre)}</div>
                        <div class="book-info">
                            <strong>📚 Auteur:</strong> ${escapeHtml(book.auteur)}
                        </div>
                        <div class="book-info">
                            <strong>📅 Année:</strong> ${book.annee || 'Non renseignée'}
                        </div>
                        ${book.isbn ? `<div class="book-info"><strong>🔢 ISBN:</strong> ${book.isbn}</div>` : ''}
                        <button class="btn btn-add" onclick="addBook('${escapeHtml(book.titre)}', '${escapeHtml(book.auteur)}', ${book.annee})">
                            ➕ Ajouter à ma bibliothèque
                        </button>
                    </div>
                `).join('');
            } else {
                results.innerHTML = '<div class="no-results">Aucun résultat trouvé. Essayez une autre recherche.</div>';
            }
        } catch (error) {
            loading.style.display = 'none';
            message.innerHTML = `<div class="message error">❌ Erreur: ${error.message}</div>`;
        }
    }

    async function addBook(titre, auteur, annee) {
        const message = document.getElementById('message');

        try {
            const formData = new URLSearchParams();
            formData.append('titre', titre);
            formData.append('auteur', auteur);
            formData.append('annee', annee || '0');

            const response = await fetch('${pageContext.request.contextPath}/api/books/search', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                message.innerHTML = '<div class="message success">✅ Livre ajouté avec succès à votre bibliothèque !</div>';
                setTimeout(() => {
                    message.innerHTML = '';
                }, 3000);
            } else {
                message.innerHTML = `<div class="message error">❌ ${data.error}</div>`;
            }
        } catch (error) {
            message.innerHTML = `<div class="message error">❌ Erreur: ${error.message}</div>`;
        }
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>
</body>
</html>