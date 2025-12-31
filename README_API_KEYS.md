# Gérer les clés API (Google Books / ISBNdb)

Ce projet lit les clés API dans l'ordre suivant (priorité décroissante) :

1. Variable d'environnement (ex: `GOOGLE_BOOKS_API_KEY`)
2. Propriété système Java (ex: `-Dgoogle.books.api.key=...`)
3. Fichier `config.properties` sur le classpath (ex: `src/main/resources/config.properties`)

Exemples :

- Sur Windows PowerShell (session courante) :
  $env:GOOGLE_BOOKS_API_KEY = "votre_cle"

- Pour définir une propriété système lors du lancement Maven :
  .\mvnw.cmd -Dgoogle.books.api.key=VOTRE_CLE clean package

- Utiliser un fichier `config.properties` (ne pas committer ce fichier) :
  Créez `src/main/resources/config.properties` en copiant `src/main/resources/config.properties.example` et mettez vos clés.

Sécurité :
- Ne commitez jamais vos clés dans le dépôt.
- Préférez les variables d'environnement pour CI/CD et environnements de production.
