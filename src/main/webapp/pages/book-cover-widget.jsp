<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Widget de couverture de livre -->
<style>
  .book-cover-widget {
    position: relative;
    width: 150px;
    height: 220px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    border-radius: 8px;
    overflow: hidden;
  }

  .book-cover-widget:hover {
    transform: translateY(-5px) scale(1.05);
    box-shadow: 0 8px 16px rgba(0,0,0,0.2);
  }

  .book-cover-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .book-cover-placeholder {
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    color: white;
    padding: 15px;
    text-align: center;
  }

  .book-cover-title {
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 8px;
    line-height: 1.3;
  }

  .book-cover-author {
    font-size: 12px;
    opacity: 0.9;
  }

  .book-cover-loading {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white;
  }

  .spinner-small {
    border: 3px solid rgba(255,255,255,0.3);
    border-top: 3px solid white;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    animation: spin 1s linear infinite;
  }

  .cover-error {
    background: #fee2e2;
    color: #991b1b;
    font-size: 12px;
    padding: 10px;
  }
</style>

<script>
  /**
   * Charge et affiche la couverture d'un livre depuis Open Library
   * @param {string} containerId - ID du conteneur HTML
   * @param {string} isbn - ISBN du livre
   * @param {string} titre - Titre du livre (fallback)
   * @param {string} auteur - Auteur du livre (fallback)
   */
  function loadBookCover(containerId, isbn, titre, auteur) {
    const container = document.getElementById(containerId);
    if (!container) return;

    // Afficher le loading
    container.innerHTML = `
        <div class="book-cover-widget">
            <div class="book-cover-loading">
                <div class="spinner-small"></div>
            </div>
        </div>
    `;

    if (isbn && isbn.trim() !== '') {
      // Essayer de charger depuis Open Library
      const coverUrl = `https://covers.openlibrary.org/b/isbn/${isbn}-M.jpg`;

      const img = new Image();
      img.onload = function() {
        container.innerHTML = `
                <div class="book-cover-widget">
                    <img src="${coverUrl}"
                         alt="Couverture de ${titre}"
                         class="book-cover-img">
                </div>
            `;
      };

      img.onerror = function() {
        // Si l'image n'existe pas, afficher le placeholder
        showPlaceholder(container, titre, auteur);
      };

      img.src = coverUrl;
    } else {
      // Pas d'ISBN, afficher directement le placeholder
      showPlaceholder(container, titre, auteur);
    }
  }

  /**
   * Affiche un placeholder coloré avec le titre et l'auteur
   */
  function showPlaceholder(container, titre, auteur) {
    container.innerHTML = `
        <div class="book-cover-widget">
            <div class="book-cover-placeholder">
                <div class="book-cover-title">${escapeHtml(titre || 'Sans titre')}</div>
                <div class="book-cover-author">${escapeHtml(auteur || 'Auteur inconnu')}</div>
            </div>
        </div>
    `;
  }

  /**
   * Recherche et affiche les informations enrichies d'un livre
   */
  async function showBookDetails(livreId) {
    try {
      const response = await fetch(`${pageContext.request.contextPath}/api/books/enrich/${livreId}`);
      const data = await response.json();

      if (data.success && data.data) {
        const info = data.data;

        // Créer une modale avec les détails
        const modal = document.createElement('div');
        modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.7);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 10000;
            `;

        modal.innerHTML = `
                <div style="background: white; padding: 30px; border-radius: 15px; max-width: 600px; max-height: 80vh; overflow-y: auto;">
                    <h2 style="margin-bottom: 20px; color: #667eea;">${info.titre || 'Détails du livre'}</h2>

                    ${info.couverture ? `<img src="${info.couverture}" style="max-width: 200px; margin-bottom: 20px;">` : ''}

                    ${info.description ? `
                        <div style="margin-bottom: 15px;">
                            <strong>Description:</strong>
                            <p>${info.description}</p>
                        </div>
                    ` : ''}

                    ${info.categories ? `<p><strong>Catégorie:</strong> ${info.categories}</p>` : ''}
                    ${info.nombrePages ? `<p><strong>Pages:</strong> ${info.nombrePages}</p>` : ''}
                    ${info.langue ? `<p><strong>Langue:</strong> ${info.langue}</p>` : ''}
                    ${info.editeur ? `<p><strong>Éditeur:</strong> ${info.editeur}</p>` : ''}

                    <button onclick="this.closest('div[style*=fixed]').remove()"
                            style="margin-top: 20px; padding: 10px 20px; background: #667eea; color: white; border: none; border-radius: 8px; cursor: pointer;">
                        Fermer
                    </button>
                </div>
            `;

        modal.onclick = function(e) {
          if (e.target === modal) modal.remove();
        };

        document.body.appendChild(modal);
      } else {
        alert('Aucune information supplémentaire disponible');
      }
    } catch (error) {
      console.error('Erreur:', error);
      alert('Erreur lors du chargement des détails');
    }
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
</script>

<!-- Exemple d'utilisation dans une JSP -->
<!--
<div id="cover-${livre.id}"></div>
<script>
loadBookCover('cover-${livre.id}', '${livre.isbn}', '${livre.titre}', '${livre.auteur.nom}');
</script>
-->