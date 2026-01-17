<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Smart Library</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom, #f5f1e8 0%, #e8dcc4 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            max-width: 950px;
            width: 100%;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 70px rgba(0,0,0,0.25);
        }

        .register-image {
            background: linear-gradient(135deg, rgba(139, 111, 71, 0.85), rgba(101, 67, 33, 0.85)),
                        url('https://images.unsplash.com/photo-1512820790803-83ca734da794?w=800') center/cover;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 40px;
            color: white;
            position: relative;
        }

        .library-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .register-image h2 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 15px;
            text-align: center;
        }

        .register-image p {
            font-size: 1rem;
            text-align: center;
            opacity: 0.95;
            line-height: 1.6;
        }

        .register-form-container {
            padding: 50px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .register-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .register-header .icon {
            font-size: 50px;
            margin-bottom: 15px;
        }

        .register-header h1 {
            color: #654321;
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .register-header p {
            color: #636e72;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2d3436;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #8b6f47;
            background: white;
            box-shadow: 0 0 0 4px rgba(139, 111, 71, 0.1);
        }

        .form-group select {
            cursor: pointer;
        }

        .role-info {
            font-size: 0.75rem;
            color: #636e72;
            margin-top: 6px;
            line-height: 1.4;
            padding: 8px 12px;
            background: #f1f3f5;
            border-radius: 6px;
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            margin-top: 10px;
            box-shadow: 0 4px 15px rgba(101, 67, 33, 0.3);
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(101, 67, 33, 0.5);
            background: linear-gradient(135deg, #9d7d53 0%, #754d2d 100%);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .error-message {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: white;
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            text-align: center;
            box-shadow: 0 4px 15px rgba(238, 90, 111, 0.3);
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #636e72;
            font-size: 0.9rem;
        }

        .login-link a {
            color: #8b6f47;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: #654321;
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .register-wrapper {
                grid-template-columns: 1fr;
                max-width: 450px;
            }

            .register-image {
                display: none;
            }

            .register-form-container {
                padding: 35px 25px;
            }

            .form-group {
                margin-bottom: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <!-- Left Side - Image & Branding -->
        <div class="register-image">
            <div class="library-icon">
                <svg width="80" height="80" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="40" y="80" width="20" height="60" fill="white"/>
                    <rect x="45" y="130" width="10" height="3" fill="rgba(255,255,255,0.7)"/>
                    <rect x="70" y="60" width="20" height="80" fill="white"/>
                    <rect x="75" y="130" width="10" height="3" fill="rgba(255,255,255,0.7)"/>
                    <rect x="100" y="70" width="20" height="70" fill="white"/>
                    <rect x="105" y="130" width="10" height="3" fill="rgba(255,255,255,0.7)"/>
                    <rect x="130" y="50" width="20" height="90" fill="white"/>
                    <rect x="135" y="130" width="10" height="3" fill="rgba(255,255,255,0.7)"/>
                    <rect x="30" y="140" width="140" height="4" fill="rgba(255,255,255,0.9)"/>
                </svg>
            </div>
            <h2>Rejoignez<br>Smart Library</h2>
            <p>Créez votre compte et profitez d'une expérience de gestion de bibliothèque moderne et intuitive.</p>
        </div>

        <!-- Right Side - Register Form -->
        <div class="register-form-container">
            <div class="register-header">
                <div class="icon">
                    <svg width="50" height="50" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="40" y="80" width="20" height="60" fill="#654321"/>
                        <rect x="45" y="130" width="10" height="3" fill="#8b6f47"/>
                        <rect x="70" y="60" width="20" height="80" fill="#654321"/>
                        <rect x="75" y="130" width="10" height="3" fill="#8b6f47"/>
                        <rect x="100" y="70" width="20" height="70" fill="#654321"/>
                        <rect x="105" y="130" width="10" height="3" fill="#8b6f47"/>
                        <rect x="130" y="50" width="20" height="90" fill="#654321"/>
                        <rect x="135" y="130" width="10" height="3" fill="#8b6f47"/>
                        <rect x="30" y="140" width="140" height="4" fill="#8b6f47"/>
                    </svg>
                </div>
                <h1>Smart Library</h1>
                <p>Créer un nouveau compte</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="nom">Nom complet</label>
                    <input type="text" id="nom" name="nom" required placeholder="Entrez votre nom complet">
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required placeholder="exemple@email.com">
                </div>

                <div class="form-group">
                    <label for="username">Nom d'utilisateur</label>
                    <input type="text" id="username" name="username" required placeholder="Choisissez un nom d'utilisateur">
                </div>

                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" required placeholder="Créez un mot de passe sécurisé">
                </div>

                <div class="form-group">
                    <label for="role">Type de compte</label>
                    <select id="role" name="role" required>
                        <option value="LECTEUR">Lecteur (Utilisateur)</option>
                        <option value="BIBLIOTHECAIRE">Bibliothécaire (Administrateur)</option>
                    </select>
                    <div class="role-info">
                        <strong>Lecteur :</strong> Emprunter et réserver des livres<br>
                        <strong>Bibliothécaire :</strong> Gérer la bibliothèque complète
                    </div>
                </div>

                <button type="submit" class="btn-register">S'inscrire</button>
            </form>

            <div class="login-link">
                <p>Déjà un compte ? <a href="${pageContext.request.contextPath}/pages/login.jsp">Se connecter</a></p>
            </div>
        </div>
    </div>
</body>
</html>
