<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Smart Library</title>
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

        .login-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            max-width: 950px;
            width: 100%;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 70px rgba(0,0,0,0.25);
        }

        .login-image {
            background: linear-gradient(135deg, rgba(139, 111, 71, 0.85), rgba(101, 67, 33, 0.85)),
                        url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=800') center/cover;
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

        .login-image h2 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 15px;
            text-align: center;
        }

        .login-image p {
            font-size: 1rem;
            text-align: center;
            opacity: 0.95;
            line-height: 1.6;
        }

        .login-form-container {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-header .icon {
            font-size: 50px;
            margin-bottom: 15px;
        }

        .login-header h1 {
            color: #654321;
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .login-header p {
            color: #636e72;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2d3436;
            font-weight: 500;
            font-size: 0.95rem;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 15px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #8b6f47;
            background: white;
            box-shadow: 0 0 0 4px rgba(139, 111, 71, 0.1);
        }

        .btn-login {
            width: 100%;
            padding: 15px;
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

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(101, 67, 33, 0.5);
            background: linear-gradient(135deg, #9d7d53 0%, #754d2d 100%);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .error-message {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: white;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-size: 0.9rem;
            text-align: center;
            box-shadow: 0 4px 15px rgba(238, 90, 111, 0.3);
        }

        .success-message {
            background: linear-gradient(135deg, #51cf66, #40c057);
            color: white;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-size: 0.9rem;
            text-align: center;
            box-shadow: 0 4px 15px rgba(64, 192, 87, 0.3);
        }

        .register-link {
            text-align: center;
            margin-top: 25px;
            color: #636e72;
            font-size: 0.9rem;
        }

        .register-link a {
            color: #8b6f47;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .register-link a:hover {
            color: #654321;
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .login-wrapper {
                grid-template-columns: 1fr;
                max-width: 450px;
            }

            .login-image {
                display: none;
            }

            .login-form-container {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <!-- Left Side - Image & Branding -->
        <div class="login-image">
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
            <h2>Bienvenue sur<br>Smart Library</h2>
            <p>Votre bibliothèque numérique moderne pour gérer livres, lecteurs et emprunts en toute simplicité.</p>
        </div>

        <!-- Right Side - Login Form -->
        <div class="login-form-container">
            <div class="login-header">
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
                <p>Connectez-vous à votre compte</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="username">Nom d'utilisateur</label>
                    <input type="text" id="username" name="username" required placeholder="Entrez votre nom d'utilisateur">
                </div>

                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" required placeholder="Entrez votre mot de passe">
                </div>

                <button type="submit" class="btn-login">Se connecter</button>
            </form>

            <div class="register-link">
                <p>Pas encore de compte ? <a href="${pageContext.request.contextPath}/pages/register.jsp">S'inscrire</a></p>
            </div>
        </div>
    </div>
</body>
</html>
