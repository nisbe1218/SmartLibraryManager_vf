# Correction du problème de datasource WildFly

## 🔴 Problème actuel
WildFly utilise la datasource H2 embarquée au lieu de MariaDB, causant des erreurs SQL car Hibernate génère du SQL MySQL/MariaDB.

## ✅ Solution : Configurer une datasource MariaDB dans WildFly

### Étape 1 : Copier le driver MariaDB dans WildFly

1. Localisez le JAR MariaDB dans votre projet :
   ```
   target/smartlibrary/WEB-INF/lib/mariadb-java-client-3.3.x.jar
   ```

2. Copiez-le dans WildFly :
   ```powershell
   Copy-Item "target\smartlibrary\WEB-INF\lib\mariadb-java-client-*.jar" "D:\wildfly-36.0.0.Final\standalone\deployments\"
   ```

3. Créez un fichier `.dodeploy` pour forcer le déploiement :
   ```powershell
   New-Item -ItemType File "D:\wildfly-36.0.0.Final\standalone\deployments\mariadb-java-client-3.3.3.jar.dodeploy"
   ```

### Étape 2 : Configurer la datasource via CLI WildFly

1. **Démarrez WildFly** (si ce n'est pas déjà fait)

2. **Ouvrez une nouvelle fenêtre PowerShell** et lancez CLI :
   ```powershell
   cd D:\wildfly-36.0.0.Final\bin
   .\jboss-cli.bat --connect
   ```

3. **Ajoutez le driver** :
   ```
   /subsystem=datasources/jdbc-driver=mariadb:add(driver-name=mariadb, driver-module-name=org.mariadb.jdbc, driver-class-name=org.mariadb.jdbc.Driver, driver-xa-datasource-class-name=org.mariadb.jdbc.MariaDbDataSource)
   ```

4. **Créez la datasource** :
   ```
   data-source add --name=SmartLibraryDS --jndi-name=java:jboss/datasources/SmartLibraryDS --driver-name=mariadb --connection-url=jdbc:mariadb://localhost:3306/smartlibrary?useSSL=false --user-name=library_user --password=library_pwd --use-ccm=true --max-pool-size=25 --blocking-timeout-wait-millis=5000 --enabled=true --driver-class=org.mariadb.jdbc.Driver --jta=true --use-java-context=true --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter
   ```

5. **Testez la connexion** :
   ```
   /subsystem=datasources/data-source=SmartLibraryDS:test-connection-in-pool
   ```

6. **Rechargez WildFly** :
   ```
   reload
   ```

7. **Quittez CLI** :
   ```
   exit
   ```

### Étape 3 : Modifier persistence.xml pour utiliser JTA

Modifiez `src/main/resources/META-INF/persistence.xml` :

```xml
<persistence xmlns="https://jakarta.ee/xml/ns/persistence" version="3.0">
    <persistence-unit name="libraryPU" transaction-type="JTA">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <jta-data-source>java:jboss/datasources/SmartLibraryDS</jta-data-source>

        <class>com.library.model.Auteur</class>
        <class>com.library.model.Livre</class>
        <class>com.library.model.Lecteur</class>
        <class>com.library.model.Emprunt</class>

        <properties>
            <property name="hibernate.dialect" value="org.hibernate.dialect.MariaDBDialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
            <property name="hibernate.jdbc.batch_size" value="50"/>
            <property name="hibernate.order_inserts" value="true"/>
            <property name="hibernate.order_updates" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```

### Étape 4 : Vérifier que MariaDB est démarré

```powershell
# Vérifiez que MariaDB est actif
netstat -ano | findstr ":3306"
```

Si MariaDB n'est pas démarré, lancez-le via XAMPP ou services Windows.

### Étape 5 : Créer la base de données (si nécessaire)

```sql
CREATE DATABASE IF NOT EXISTS smartlibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'library_user'@'localhost' IDENTIFIED BY 'library_pwd';
GRANT ALL PRIVILEGES ON smartlibrary.* TO 'library_user'@'localhost';
FLUSH PRIVILEGES;
```

### Étape 6 : Rebuild et redeploy

```powershell
cd "C:\Users\PC DELL\IdeaProjects\SmartLibraryManager"
.\mvnw.cmd clean package -DskipTests
```

Puis redéployez via IntelliJ.

---

## 🚀 Alternative rapide : Utiliser H2 compatible

Si vous voulez juste tester rapidement, modifiez `persistence.xml` pour utiliser H2 :

```xml
<property name="hibernate.dialect" value="org.hibernate.dialect.H2Dialect"/>
<property name="jakarta.persistence.jdbc.driver" value="org.h2.Driver"/>
<property name="jakarta.persistence.jdbc.url" value="jdbc:h2:mem:smartlibrary;DB_CLOSE_DELAY=-1"/>
<property name="jakarta.persistence.jdbc.user" value="sa"/>
<property name="jakarta.persistence.jdbc.password" value=""/>
```

⚠️ **ATTENTION** : H2 en mode mémoire (`mem:`) perd toutes les données au redémarrage.

---

## ✅ Vérification

Après configuration, les logs devraient afficher :
```
Database version: 10.4.32  ← MariaDB au lieu de 2.2.224 (H2)
```
