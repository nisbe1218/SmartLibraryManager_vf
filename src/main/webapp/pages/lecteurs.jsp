<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecteurs - SmartLibrary</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homepage-theme.css">
</head>
<body>
<header>
    <div class="header-content">
        <a href="${pageContext.request.contextPath}/" class="logo">
            <div class="logo-icon">📚</div>
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
        <h2>👥 Gestion des Lecteurs</h2>
        <p>Ajoutez et consultez tous les lecteurs de votre bibliothèque</p>
    </div>

    <div class="add-form">
        <h3>➕ Ajouter un nouveau lecteur</h3>
        <form action="lecteurs" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="nom">Nom du lecteur</label>
                    <input type="text" id="nom" name="nom" placeholder="Ex: Dupont" required>
                </div>
                <div class="form-group">
                    <label for="email">Email du lecteur</label>
                    <input type="email" id="email" name="email" placeholder="Ex: dupont@example.com" required>
                </div>
                <button type="submit" class="btn-primary">✨ Ajouter</button>
            </div>
        </form>
    </div>

    <div class="table-container">
        <div class="table-header">
            <h3>📋 Liste des lecteurs (<span class="badge">${lecteurs.size()}</span>)</h3>
            <input type="text" class="search-box" id="searchBox" placeholder="🔍 Rechercher un lecteur..." onkeyup="filterTable()">
        </div>

        <c:choose>
            <c:when test="${empty lecteurs}">
                <div class="empty-state">
                    <div class="empty-state-icon">👥</div>
                    <h3>Aucun lecteur trouvé</h3>
                    <p>Commencez par ajouter votre premier lecteur ci-dessus</p>
                </div>
            </c:when>
            <c:otherwise>
                <table id="lecteursTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Email</th>
                        <th>Nombre d'emprunts</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="l" items="${lecteurs}">
                        <tr>
                            <td>#${l.id}</td>
                            <td>${l.nom}</td>
                            <td>${l.email}</td>
                            <td>${l.nombreEmprunts}</td>
                            <td>
                                <form action="lecteurs" method="post" style="display:inline;" onsubmit="return confirm('Voulez-vous vraiment supprimer ce lecteur ?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${l.id}">
                                    <button type="submit" class="btn-delete" title="Supprimer ce lecteur">
                                        🗑️ Supprimer
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

<script>
    function filterTable() {
        const input = document.getElementById('searchBox');
        const filter = input.value.toUpperCase();
        const table = document.getElementById('lecteursTable');
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
</script>
</body>
</html>
