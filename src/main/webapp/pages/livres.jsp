<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livres - SmartLibrary</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homepage-theme.css">
</head>
<body>
<header>
    <div class="header-content">
        <a href="${pageContext.request.contextPath}/" class="logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="SmartLibrary Logo" class="logo-icon">
            <h1>SmartLibrary</h1>
        </a>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/auteurs">👤 Auteurs</a></li>
                <li><a href="${pageContext.request.contextPath}/livres">📖 Livres</a></li>
                <li><a href="${pageContext.request.contextPath}/lecteurs">👥 Lecteurs</a></li>
                <li><a href="${pageContext.request.contextPath}/emprunts">📋 Emprunts</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="container">
    <div class="page-title">
        <h2>📚 Gestion des Livres</h2>
        <p>Gérez votre collection de livres et enrichissez-les avec Google Books</p>
    </div>

    <div class="add-form">
        <h3><span>➕</span> Ajouter un nouveau livre</h3>
        <form action="livres" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="titre">Titre du livre</label>
                    <input type="text" id="titre" name="titre" placeholder="Ex: Les Misérables" required>
                </div>
                <div class="form-group">
                    <label for="annee">Année de publication</label>
                    <input type="number" id="annee" name="annee" placeholder="Ex: 1862" min="1000" max="2100" required>
                </div>
                <div class="form-group">
                    <label for="auteurId">Auteur</label>
                    <select id="auteurId" name="auteurId" required>
                        <option value="">Sélectionner un auteur...</option>
                        <c:forEach var="auteur" items="${auteurs}">
                            <option value="${auteur.id}">${auteur.prenom} ${auteur.nom}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn-primary">✨ Ajouter</button>
            </div>
        </form>
    </div>

    <div class="table-container">
        <div class="table-header">
            <h3><span>📋</span> Liste des livres (<span class="badge">${livres.size()}</span>)</h3>
            <input type="text" class="search-box" id="searchBox" placeholder="🔍 Rechercher..." onkeyup="filterTable()">
        </div>

        <c:choose>
            <c:when test="${empty livres}">
                <div class="empty-state">
                    <div class="empty-state-icon">📖</div>
                    <h3>Aucun livre trouvé</h3>
                    <p>Commencez par ajouter votre premier livre ci-dessus</p>
                </div>
            </c:when>
            <c:otherwise>
                <table id="livresTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Titre</th>
                        <th>Année</th>
                        <th>Auteur</th>
                        <th>Emprunts</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="livre" items="${livres}">
                        <tr>
                            <td>#${livre.id}</td>
                            <td>${livre.titre}</td>
                            <td>${livre.anneePublication}</td>
                            <td>
                                <c:if test="${not empty livre.auteur}">
                                    ${livre.auteur.prenom} ${livre.auteur.nom}
                                </c:if>
                            </td>
                            <td>
                                <c:set var="nbEmprunts" value="0"/>
                                <c:if test="${not empty livre.emprunts}">
                                    <c:set var="nbEmprunts" value="${livre.emprunts.size()}"/>
                                </c:if>
                                    ${nbEmprunts} emprunt(s)
                            </td>
                            <td>
                                <button class="btn-enrich" data-livre-id="${livre.id}" data-livre-titre="${livre.titre}" onclick="enrichirLivre(this.dataset.livreId, this.dataset.livreTitre)" title="Enrichir avec Google Books">
                                    🔍 Enrichir
                                </button>
                                <form action="livres" method="post" style="display:inline; margin-left: 0.5rem;" onsubmit="return confirm('Voulez-vous vraiment supprimer ce livre ?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${livre.id}">
                                    <button type="submit" class="btn-delete" title="Supprimer ce livre">
                                        🗑️
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal d'enrichissement -->
<div id="enrichModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">📚 Informations enrichies</h2>
            <button class="close" onclick="fermerModal()">&times;</button>
        </div>
        <div class="modal-body" id="enrichContent">
            <!-- Contenu chargé dynamiquement -->
        </div>
        <div class="modal-footer">
            <button class="btn-close" onclick="fermerModal()">Fermer</button>
        </div>
    </div>
</div>

<script>
    function filterTable() {
        const input = document.getElementById('searchBox');
        const filter = input.value.toUpperCase();
        const table = document.getElementById('livresTable');
        const tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            const td = tr[i].getElementsByTagName('td');
            let found = false;

            for (let j = 0; j < td.length; j++) {
                if (td[j]) {
                    const txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
            }

            tr[i].style.display = found ? '' : 'none';
        }
    }

    function enrichirLivre(livreId, titre) {
        const modal = document.getElementById('enrichModal');
        const content = document.getElementById('enrichContent');
        
        // Afficher le modal avec loader
        content.innerHTML = `
            <div class="loading">
                <div class="loading-spinner"></div>
                <p>⏳ Récupération des informations depuis Google Books...</p>
            </div>
        `;
        modal.style.display = 'block';
        
        // Appeler l'API d'enrichissement
        fetch('<c:url value="/api/books/enrich/" />' + livreId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    afficherInfosEnrichies(data.data);
                } else {
                    afficherErreur(data.message || 'Erreur lors de la récupération des informations');
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                afficherErreur('Impossible de contacter le serveur. Vérifiez votre connexion.');
            });
    }

    function afficherInfosEnrichies(livre) {
        let coverImage = '';
        if (livre.couverture) {
            const coverUrl = livre.couverture.replace('http://', 'https://');
            coverImage = '<img src="' + coverUrl + '" alt="Couverture" class="book-cover" onerror="this.style.display=\'none\'">';
        }
        
        let detailsHtml = '';
        if (livre.nombrePages) {
            detailsHtml += '<div class="detail-item"><div class="detail-label">📄 Nombre de pages</div><div class="detail-value">' + livre.nombrePages + ' pages</div></div>';
        }
        if (livre.editeur) {
            detailsHtml += '<div class="detail-item"><div class="detail-label">🏢 Éditeur</div><div class="detail-value">' + livre.editeur + '</div></div>';
        }
        if (livre.categories) {
            detailsHtml += '<div class="detail-item"><div class="detail-label">🏷️ Catégorie</div><div class="detail-value">' + livre.categories + '</div></div>';
        }
        if (livre.langue) {
            detailsHtml += '<div class="detail-item"><div class="detail-label">🌍 Langue</div><div class="detail-value">' + livre.langue.toUpperCase() + '</div></div>';
        }
        
        const html = coverImage + 
            '<div class="book-info">' +
                '<h3>📖 Description</h3>' +
                '<p>' + (livre.description || 'Aucune description disponible.') + '</p>' +
                '<h3>📊 Détails du livre</h3>' +
                '<div class="book-details">' + detailsHtml + '</div>' +
            '</div>';
        
        document.getElementById('enrichContent').innerHTML = html;
    }

    function afficherErreur(message) {
        const html = 
            '<div class="error-message">' +
                '<h3 style="margin-top:0;">❌ Erreur</h3>' +
                '<p style="margin-bottom:0;">' + message + '</p>' +
            '</div>' +
            '<p style="color: #64748b; margin-top: 15px;">💡 Suggestions :</p>' +
            '<ul style="color: #64748b; line-height: 1.8;">' +
                '<li>Vérifiez que la clé API Google Books est configurée</li>' +
                '<li>Vérifiez que l\'API Books est activée dans Google Cloud Console</li>' +
                '<li>Le livre existe peut-être pas dans la base de données Google Books</li>' +
            '</ul>';
        
        document.getElementById('enrichContent').innerHTML = html;
    }

    function fermerModal() {
        document.getElementById('enrichModal').style.display = 'none';
    }

    // Fermer le modal en cliquant en dehors
    window.onclick = function(event) {
        const modal = document.getElementById('enrichModal');
        if (event.target === modal) {
            fermerModal();
        }
    }

    // Fermer le modal avec la touche Échap
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            fermerModal();
        }
    });
</script>
</body>
</html>
