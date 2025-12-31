# Configuration de l'API Google Books

## Vue d'ensemble
Ce projet utilise l'API Google Books pour enrichir les informations des livres (descriptions, catégories, couvertures, etc.).

## Prérequis
1. Créer un projet dans [Google Cloud Console](https://console.cloud.google.com/)
2. Activer l'API "Books API" pour votre projet
3. Créer une clé API dans "API et services" → "Identifiants"

## Configuration de la clé API

La clé API peut être fournie de **3 façons** (par ordre de priorité) :

### 1. Variable d'environnement (Recommandé pour production)
```powershell
# Windows PowerShell
$env:GOOGLE_BOOKS_API_KEY = 'VOTRE_CLE_ICI'
```

```bash
# Linux/Mac
export GOOGLE_BOOKS_API_KEY='VOTRE_CLE_ICI'
```

### 2. Propriété système JVM
Ajouter lors du démarrage de WildFly :
```
-Dgoogle.books.api.key=VOTRE_CLE_ICI
```

Dans IntelliJ IDEA :
- Run → Edit Configurations → Votre configuration WildFly
- VM options : `-Dgoogle.books.api.key=VOTRE_CLE_ICI`

### 3. Fichier config.properties (Développement local uniquement)
Créer/éditer `src/main/resources/config.properties` :
```properties
google.books.api.key=VOTRE_CLE_ICI
```

⚠️ **ATTENTION** : Ne jamais committer ce fichier avec une vraie clé dans un dépôt public !

## Sécurité

### Restrictions recommandées pour la clé API
Dans Google Cloud Console → API et services → Identifiants → Votre clé :

1. **Restriction d'API** : Limiter à "Books API" uniquement
2. **Restrictions d'application** :
   - Pour un site web : ajouter les HTTP referrers autorisés
   - Pour un serveur : ajouter les adresses IP autorisées

### Rotation de clé
Si votre clé a été exposée (logs, captures d'écran, dépôt public) :
1. Révoquer la clé exposée dans Google Cloud Console
2. Créer une nouvelle clé avec restrictions appropriées
3. Mettre à jour la configuration (env var / JVM property)

## Endpoints disponibles

### 1. Vérification de la clé API
**GET** `/api/keys/check`

Teste la présence et la validité de la clé Google Books.

**Exemple** :
```powershell
Invoke-RestMethod -Uri 'http://127.0.0.1:8080/smartlibrary/api/keys/check' -Method Get
```

**Réponse (succès)** :
```json
{
  "success": true,
  "message": "Google Books key OK (status 200)",
  "data": {
    "keyPresent": true,
    "keyLength": 39,
    "keySource": "CONFIG_FILE",
    "httpStatus": 200,
    "requestUrl": "https://www.googleapis.com/books/v1/volumes?q=...",
    "providerResponse": { ... }
  },
  "timestamp": "2025-11-08T17:24:00.233"
}
```

**Réponse (erreur - clé manquante)** :
```json
{
  "success": false,
  "message": "Google Books API key absente...",
  "timestamp": "2025-11-08T17:24:00.233"
}
```

**Réponse (erreur - API non activée)** :
```json
{
  "success": false,
  "message": "Google Books returned authorization error (401/403)...",
  "data": {
    "httpStatus": 403,
    "body": "{ \"error\": { \"message\": \"Books API has not been used...\" } }"
  },
  "timestamp": "2025-11-08T17:24:00.233"
}
```

### 2. Enrichissement d'un livre
**GET** `/api/books/enrich/{id}`

Enrichit les informations d'un livre existant en interrogeant Google Books API.

**Paramètres** :
- `{id}` : ID du livre dans la base de données

**Exemple** :
```powershell
# Enrichir le livre avec ID=1
Invoke-RestMethod -Uri 'http://127.0.0.1:8080/smartlibrary/api/books/enrich/1' -Method Get
```

**Réponse (succès)** :
```json
{
  "success": true,
  "message": "Informations enrichies récupérées",
  "data": {
    "id": 1,
    "titre": "The Adventures of Tom Sawyer",
    "description": "The adventures of a mischievous young boy...",
    "categories": "Fiction",
    "nombrePages": 244,
    "couverture": "https://books.google.com/books/content?id=...",
    "langue": "en",
    "editeur": "Signet Classics"
  },
  "timestamp": "2025-11-08T17:30:00.123"
}
```

**Réponse (erreur - livre non trouvé)** :
```json
{
  "success": false,
  "message": "Livre non trouvé",
  "timestamp": "2025-11-08T17:30:00.123"
}
```

**Réponse (erreur - clé manquante)** :
```json
{
  "success": false,
  "message": "Google Books API key manquante. Configurez GOOGLE_BOOKS_API_KEY...",
  "timestamp": "2025-11-08T17:30:00.123"
}
```

**Réponse (aucune info trouvée)** :
```json
{
  "success": false,
  "message": "Aucune information supplémentaire trouvée pour ce livre",
  "timestamp": "2025-11-08T17:30:00.123"
}
```

## Dépannage

### Erreur 403 "Books API has not been used"
**Solution** : Activer l'API Books dans Google Cloud Console
1. Aller sur https://console.cloud.google.com/apis/library
2. Rechercher "Books API"
3. Cliquer sur "Activer"
4. Attendre ~30 secondes
5. Redémarrer l'application

### Erreur "API key absente"
**Vérifications** :
1. La clé est-elle bien définie ? (env var / JVM property / config.properties)
2. Le serveur a-t-il été redémarré après avoir ajouté la clé ?
3. Vérifier les logs au démarrage :
   - `Google Books API key detected (length=39)` → OK
   - `No Google Books API key configured` → KO

### Erreur 401/403 "Authorization error"
**Causes possibles** :
1. L'API Books n'est pas activée pour votre projet → voir ci-dessus
2. La clé a des restrictions qui bloquent l'appel :
   - Vérifier les restrictions d'API (doit inclure "Books API")
   - Vérifier les restrictions HTTP referrers / IP
3. La clé est invalide ou révoquée → créer une nouvelle clé

## Limites et quotas

Google Books API (gratuit) :
- **1000 requêtes/jour** (par défaut)
- Pour augmenter le quota, activer la facturation dans Google Cloud

Consultez vos quotas actuels :
- Google Cloud Console → API et services → Tableau de bord → Books API

## Développement local

### Build et déploiement
```powershell
# Compiler le projet
.\mvnw.cmd clean package -DskipTests

# Le WAR est généré dans target/smartlibrary.war
```

### Test rapide après déploiement
```powershell
# 1. Vérifier la clé
Invoke-RestMethod -Uri 'http://127.0.0.1:8080/smartlibrary/api/keys/check'

# 2. Tester l'enrichissement (ajuster l'ID selon votre base)
Invoke-RestMethod -Uri 'http://127.0.0.1:8080/smartlibrary/api/books/enrich/1'
```

## Références
- [Documentation Google Books API](https://developers.google.com/books/docs/v1/using)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Gestion des clés API](https://cloud.google.com/docs/authentication/api-keys)
