<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard API - Smart Library</title>
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
            max-width: 1400px;
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
            font-size: 32px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .stat-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #6b7280;
            font-size: 14px;
        }

        .api-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 30px;
        }

        .api-section h2 {
            color: #667eea;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quick-search {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .quick-search input {
            flex: 1;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .trending-books {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
        }

        .trending-book {
            background: #f9fafb;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .trending-book:hover {
            background: #667eea;
            color: white;
            transform: scale(1.05);
        }

        .api-status {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .status-item {
            flex: 1;
            padding: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .status-online {
            background: #d1fae5;
            color: #065f46;
        }

        .status-offline {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .status-online .status-dot {
            background: #10b981;
        }

        .status-offline .status-dot {
            background: #ef4444;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        .back-link {
            display: inline-block;
            padding: 12px 24px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            margin-bottom: 20px;
            transition: all 0.3s;
        }

        .back-link:hover {
            background: #667eea;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/" class="back-link">← Retour à l'accueil</a>

    <div class="header">
        <h1>📊 Dashboard API - Smart Library</h1>
        <p>Tableau de bord des intégrations API et statistiques en temps réel</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">📚</div>
            <div class="stat-value" id="totalBooks">-</div>
            <div class="stat-label">Livres dans la bibliothèque</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">🔍</div>
            <div class="stat-value" id="apiSearches">0</div>
            <div class="stat-label">Recherches API aujourd'hui</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">⚡</div>
            <div class="stat-value" id="apiResponseTime">-</div>
            <div class="stat-label">Temps de réponse moyen</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div class="stat-value" id="successRate">100%</div>
            <div class="stat-label">Taux de succès</div>
        </div>
    </div>

    <div class="api-section">
        <h2>🌐 État des APIs</h2>
        <div class="api-status">
            <div class="status-item status-online">
                <div class="status-dot"></div>
                <div>
                    <strong>Open Library API</strong>
                    <div style="font-size: 12px; opacity: 0.8;">Opérationnelle</div>
                </div>
            </div>

            <div class="status-item status-online">
                <div class="status-dot"></div>
                <div>
                    <strong>Google Books API</strong>
                    <div style="font-size: 12px; opacity: 0.8;">Opérationnelle</div>
                </div>
            </div>
        </div>
    </div>

    <div class="api-section">
        <h2>🔥 Recherche rapide</h2>
        <div class="quick-search">
            <input type="text"
                   id="quickSearch"
                   placeholder="Chercher un livre sur Open Library..."
                   onkeypress="if(event.key==='Enter') performQuickSearch()">
            <button class="btn btn-primary" onclick="performQuickSearch()">
                🔍 Rechercher
            </button>
        </div>
        <div id="quickResults"></div>
    </div>

    <div class="api-section">
        <h2>📈 Livres tendance</h2>
        <p style="color: #6b7280; margin-bottom: 15px;">
            Cliquez sur un livre pour le rechercher et l'ajouter à votre bibliothèque
        </p>
        <div class="trending-books">
            <div class="trending-book" onclick="searchTrending('Harry Potter')">
                <div style="font-size: 30px; margin-bottom: 5px;">⚡</div>
                <strong>Harry Potter</strong>
            </div>
            <div class="trending-book" onclick="searchTrending('1984')">
                <div style="font-size: 30px; margin-bottom: 5px;">👁️</div>
                <strong>1984</strong>
            </div>
            <div class="trending-book" onclick="searchTrending('Le Petit Prince')">
                <div style="font-size: 30px; margin-bottom: 5px;">👑</div>
                <strong>Le Petit Prince</strong>
            </div>
            <div class="trending-book" onclick="searchTrending('Dune')">
                <div style="font-size: 30px; margin-bottom: 5px;">🏜️</div>
                <strong>Dune</strong>
            </div>
            <div class="trending-book" onclick="searchTrending('The Hobbit')">
                <div style="font-size: 30px; margin-bottom: 5px;">🧙</div>
                <strong>The Hobbit</strong>
            </div>
            <div class="trending-book" onclick="searchTrending('Pride and Prejudice')">
                <div style="font-size: 30px; margin-bottom: 5px;">💝</div>
                <strong>Pride & Prejudice</strong>
            </div>
        </div>
    </div>
</div>

<script>
    let apiCallCount = 0;
    let totalResponseTime = 0;
    let successfulCalls = 0;

    // Charger les statistiques au démarrage
    window.onload = function() {
        loadStatistics();
        checkApiStatus();
    };

    async function loadStatistics() {
        // Simuler le chargement des stats (vous pouvez créer un endpoint dédié)
        document.getElementById('totalBooks').textContent = '...';

        // Compter les livres via une requête simple
        try {
            const response = await fetch('${pageContext.request.contextPath}/livres');
            // Parser pour compter (simplification)
            document.getElementById('totalBooks').textContent = '?';
        } catch (error) {
            console.error('Erreur de chargement:', error);
        }
    }

    async function checkApiStatus() {
        // Tester Open Library
        try {
            const start = Date.now();
            const response = await fetch('https://openlibrary.org/search.json?q=test&limit=1');
            const time = Date.now() - start;

            if (response.ok) {
                updateApiStats(time, true);
            }
        } catch (error) {
            updateApiStats(0, false);
        }
    }

    function updateApiStats(responseTime, success) {
        apiCallCount++;
        if (success) {
            successfulCalls++;
            totalResponseTime += responseTime;

            const avgTime = Math.round(totalResponseTime / successfulCalls);
            document.getElementById('apiResponseTime').textContent = avgTime + 'ms';
        }

        document.getElementById('apiSearches').textContent = apiCallCount;

        const successRate = Math.round((successfulCalls / apiCallCount) * 100);
        document.getElementById('successRate').textContent = successRate + '%';
    }

    async function performQuickSearch() {
        const query = document.getElementById('quickSearch').value;
        if (!query.trim()) return;

        const resultsDiv = document.getElementById('quickResults');
        resultsDiv.innerHTML = '<p style="color: #6b7280;">🔄 Recherche en cours...</p>';

        try {
            const start = Date.now();
            const response = await fetch(`${pageContext.request.contextPath}/api/books/search?query=${encodeURIComponent(query)}`);
            const responseTime = Date.now() - start;
            const data = await response.json();

            updateApiStats(responseTime, data.success);

            if (data.success && data.books && data.books.length > 0) {
                resultsDiv.innerHTML = `
                    <div style="margin-top: 15px; padding: 15px; background: #f0fdf4; border-radius: 8px;">
                        <strong style="color: #10b981;">✅ ${data.books.length} résultat(s) trouvé(s)</strong>
                        <div style="margin-top: 10px;">
                            ${data.books.slice(0, 3).map(book => `
                                <div style="padding: 10px; margin: 5px 0; background: white; border-radius: 5px;">
                                    📖 <strong>${book.titre}</strong> - ${book.auteur} (${book.annee || '?'})
                                </div>
                            `).join('')}
                        </div>
                        <a href="${pageContext.request.contextPath}/pages/search-books.jsp"
                           style="display: inline-block; margin-top: 10px; color: #667eea; text-decoration: none; font-weight: 600;">
                            → Voir tous les résultats et ajouter des livres
                        </a>
                    </div>
                `;
            } else {
                resultsDiv.innerHTML = '<p style="color: #991b1b; background: #fee2e2; padding: 10px; border-radius: 8px; margin-top: 10px;">❌ Aucun résultat trouvé</p>';
            }
        } catch (error) {
            updateApiStats(0, false);
            resultsDiv.innerHTML = `<p style="color: #991b1b;">❌ Erreur: ${error.message}</p>`;
        }
    }

    function searchTrending(bookName) {
        document.getElementById('quickSearch').value = bookName;
        performQuickSearch();
    }
</script>
</body>
</html>