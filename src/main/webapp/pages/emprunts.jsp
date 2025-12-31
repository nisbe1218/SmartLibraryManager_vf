<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Emprunts - SmartLibrary</title>
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
    <h2>📋 Gestion des Emprunts</h2>
    <p>Ajoutez et consultez tous les emprunts de votre bibliothèque</p>
  </div>

  <div class="add-form">
    <h3>➕ Enregistrer un nouvel emprunt</h3>
    <form action="emprunts" method="post">
      <div class="form-row">
        <div class="form-group">
          <label for="livreId">Livre</label>
          <select id="livreId" name="livreId" required>
            <option value="">Sélectionner un livre...</option>
            <c:forEach var="livre" items="${livres}">
              <option value="${livre.id}">${livre.titre}<c:if test="${not empty livre.auteur}"> - ${livre.auteur.prenom} ${livre.auteur.nom}</c:if></option>
            </c:forEach>
          </select>
        </div>
        <div class="form-group">
          <label for="lecteurId">Lecteur</label>
          <select id="lecteurId" name="lecteurId" required>
            <option value="">Sélectionner un lecteur...</option>
            <c:forEach var="lecteur" items="${lecteurs}">
              <option value="${lecteur.id}">${lecteur.nom} - ${lecteur.email}</option>
            </c:forEach>
          </select>
        </div>
        <button type="submit" class="btn-primary">✨ Enregistrer</button>
      </div>
    </form>
  </div>

  <div class="table-container">
    <div class="table-header">
      <h3>📋 Liste des emprunts (<span class="badge">${emprunts.size()}</span>)</h3>
      <input type="text" class="search-box" id="searchBox" placeholder="🔍 Rechercher..." onkeyup="filterTable()">
    </div>

    <c:choose>
      <c:when test="${empty emprunts}">
        <div class="empty-state">
          <div class="empty-state-icon">📋</div>
          <h3>Aucun emprunt enregistré</h3>
          <p>Commencez par enregistrer votre premier emprunt ci-dessus</p>
        </div>
      </c:when>
      <c:otherwise>
        <table id="empruntsTable">
          <thead>
          <tr>
            <th>ID</th>
            <th>Livre</th>
            <th>Lecteur</th>
            <th>Date d'emprunt</th>
            <th>Date de retour</th>
            <th>Statut</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="emprunt" items="${emprunts}">
            <tr>
              <td>#${emprunt.id}</td>
              <td><c:if test="${not empty emprunt.livre}">${emprunt.livre.titre}</c:if></td>
              <td><c:if test="${not empty emprunt.lecteur}">${emprunt.lecteur.nom}</c:if></td>
              <td>${emprunt.dateEmprunt}</td>
              <td><c:choose><c:when test="${not empty emprunt.dateRetour}">${emprunt.dateRetour}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
              <td>
                <c:choose>
                  <c:when test="${empty emprunt.dateRetour}">
                    <span class="status-badge status-actif">🟢 En cours</span>
                    <form action="${pageContext.request.contextPath}/emprunts" method="post" style="display:inline;">
                      <input type="hidden" name="renduId" value="${emprunt.id}" />
                      <button type="submit" class="btn-primary" style="padding:4px 8px; font-size:12px; margin-left:5px;">✓ Marquer rendu</button>
                    </form>
                  </c:when>
                  <c:otherwise>
                    <span class="status-badge status-rendu">✓ Rendu</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <form action="emprunts" method="post" style="display:inline;" onsubmit="return confirm('Voulez-vous vraiment supprimer cet emprunt ?');">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="id" value="${emprunt.id}">
                  <button type="submit" class="btn-delete" title="Supprimer cet emprunt">
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

<script>
  function filterTable() {
    const input = document.getElementById('searchBox');
    const filter = input.value.toUpperCase();
    const table = document.getElementById('empruntsTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
      const td = tr[i].getElementsByTagName('td');
      let found = false;
      for (let j = 0; j < td.length; j++) {
        if (td[j]) {
          const txtValue = td[j].textContent || td[j].innerText;
          if (txtValue.toUpperCase().indexOf(filter) > -1) { found = true; break; }
        }
      }
      tr[i].style.display = found ? '' : 'none';
    }
  }
</script>
</body>
</html>
