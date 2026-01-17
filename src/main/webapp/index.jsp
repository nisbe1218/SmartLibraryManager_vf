<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartLibrary - Bibliothèque en ligne</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom, #f9f6f1 0%, #ffffff 100%);
            min-height: 100vh;
        }

        /* Header Navigation */
        .top-nav {
            background: #ffffff;
            padding: 1.5rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .nav-links {
            display: flex;
            gap: 3rem;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: #2d3436;
            font-weight: 500;
            font-size: 1rem;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: #00b894;
        }

        /* Hero Section */
        .hero-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            align-items: center;
            padding: 4rem 3rem;
            max-width: 1400px;
            margin: 0 auto;
            min-height: calc(100vh - 100px);
        }

        .hero-content {
            padding-right: 4rem;
        }

        .hero-title {
            font-size: 4.5rem;
            color: #2d5a5a;
            margin-bottom: 2rem;
            line-height: 1.2;
            font-weight: 600;
        }

        .hero-description {
            font-size: 1.125rem;
            color: #636e72;
            line-height: 1.8;
            margin-bottom: 3rem;
            max-width: 500px;
        }

        .learn-more-btn {
            background: linear-gradient(135deg, #d4842f 0%, #c67228 100%);
            color: white;
            padding: 1rem 3rem;
            border: none;
            border-radius: 50px;
            font-size: 1.125rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(212, 132, 47, 0.3);
            text-decoration: none;
            display: inline-block;
        }

        .learn-more-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(212, 132, 47, 0.4);
        }

        .arrow-icon {
            margin-left: 1rem;
            font-size: 1.5rem;
            display: inline-block;
            transition: transform 0.3s ease;
        }

        .learn-more-btn:hover .arrow-icon {
            transform: translateX(5px);
        }

        /* Book Shelves Illustration */
        .shelves-container {
            position: relative;
            width: 100%;
            max-width: 650px;
        }

        .shelf {
            background: #8b6f47;
            height: 12px;
            border-radius: 4px;
            margin-bottom: 120px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            position: relative;
        }

        .shelf:last-child {
            margin-bottom: 0;
        }

        .books-row {
            position: absolute;
            bottom: 12px;
            left: 0;
            right: 0;
            display: flex;
            gap: 8px;
            padding: 0 20px;
        }

        .book {
            height: 110px;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: relative;
            transition: transform 0.3s ease;
        }

        .book:hover {
            transform: translateY(-5px);
        }

        /* Book spine details */
        .book::before {
            content: '';
            position: absolute;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60%;
            height: 3px;
            background: rgba(255,255,255,0.3);
            border-radius: 2px;
        }

        .book::after {
            content: '';
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60%;
            height: 3px;
            background: rgba(255,255,255,0.3);
            border-radius: 2px;
        }

        /* Decorative circles */
        .circle {
            position: absolute;
            border-radius: 50%;
            background: #e8dcc4;
        }

        .circle-1 {
            width: 80px;
            height: 80px;
            top: 50px;
            left: 50%;
            transform: translateX(-50%);
        }

        .circle-2 {
            width: 60px;
            height: 60px;
            bottom: 180px;
            left: 15%;
        }

        .circle-3 {
            width: 100px;
            height: 100px;
            bottom: 60px;
            right: 10%;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 12px;
            margin: 2rem auto;
            max-width: 800px;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            color: #166534;
            border: 2px solid #86efac;
        }

        .alert-error {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
            border: 2px solid #fca5a5;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .hero-section {
                grid-template-columns: 1fr;
                padding: 2rem;
            }

            .hero-content {
                padding-right: 0;
                text-align: center;
                margin-bottom: 3rem;
            }

            .hero-title {
                font-size: 3rem;
            }

            .hero-description {
                margin: 0 auto 2rem;
            }

            .shelves-container {
                margin: 0 auto;
            }

            .top-nav {
                padding: 1rem 2rem;
            }

            .nav-links {
                gap: 1.5rem;
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .nav-links {
                flex-wrap: wrap;
                gap: 1rem;
                font-size: 0.9rem;
            }

            .shelf {
                margin-bottom: 100px;
            }

            .books-row {
                gap: 5px;
            }

            .book {
                height: 90px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="top-nav">
        <div style="display: flex; align-items: center; gap: 10px;">
            <svg width="40" height="40" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="40" y="80" width="20" height="60" fill="#2d5a5a"/>
                <rect x="45" y="130" width="10" height="3" fill="#8b6f47"/>
                <rect x="70" y="60" width="20" height="80" fill="#2d5a5a"/>
                <rect x="75" y="130" width="10" height="3" fill="#8b6f47"/>
                <rect x="100" y="70" width="20" height="70" fill="#2d5a5a"/>
                <rect x="105" y="130" width="10" height="3" fill="#8b6f47"/>
                <rect x="130" y="50" width="20" height="90" fill="#2d5a5a"/>
                <rect x="135" y="130" width="10" height="3" fill="#8b6f47"/>
                <rect x="30" y="140" width="140" height="4" fill="#654321"/>
            </svg>
            <span style="font-size: 1.5rem; font-weight: 600; color: #2d5a5a;">SmartLibrary</span>
        </div>
    </nav>

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">
            ${sessionScope.message}
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-error">
            ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title">Bibliothèque en ligne</h1>
            <p class="hero-description">
                Gérez votre bibliothèque de manière simple et efficace. Suivez vos auteurs, livres, lecteurs et emprunts en un seul endroit moderne et intuitif.
            </p>
            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="learn-more-btn">
                Se connecter
                <span class="arrow-icon">→</span>
            </a>
        </div>

        <!-- Book Shelves Illustration -->
        <div class="shelves-container">
            <!-- Decorative circles -->
            <div class="circle circle-1"></div>
            <div class="circle circle-2"></div>
            <div class="circle circle-3"></div>

            <!-- Shelf 1 -->
            <div class="shelf">
                <div class="books-row">
                    <div class="book" style="width: 45px; background: linear-gradient(135deg, #00b894 0%, #00a383 100%);"></div>
                    <div class="book" style="width: 60px; background: linear-gradient(135deg, #6c5ce7 0%, #5f4fd1 100%);"></div>
                    <div class="book" style="width: 50px; background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);"></div>
                    <div class="book" style="width: 70px; background: linear-gradient(135deg, #fdcb6e 0%, #e17055 100%);"></div>
                    <div class="book" style="width: 55px; background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);"></div>
                    <div class="book" style="width: 48px; background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);"></div>
                    <div class="book" style="width: 65px; background: linear-gradient(135deg, #55efc4 0%, #00b894 100%);"></div>
                    <div class="book" style="width: 52px; background: linear-gradient(135deg, #ff7675 0%, #d63031 100%);"></div>
                    <div class="book" style="width: 58px; background: linear-gradient(135deg, #fab1a0 0%, #e17055 100%);"></div>
                </div>
            </div>

            <!-- Shelf 2 -->
            <div class="shelf">
                <div class="books-row">
                    <div class="book" style="width: 62px; background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);"></div>
                    <div class="book" style="width: 48px; background: linear-gradient(135deg, #dfe6e9 0%, #b2bec3 100%);"></div>
                    <div class="book" style="width: 70px; background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);"></div>
                    <div class="book" style="width: 55px; background: linear-gradient(135deg, #00b894 0%, #00a383 100%);"></div>
                    <div class="book" style="width: 50px; background: linear-gradient(135deg, #6c5ce7 0%, #5f4fd1 100%);"></div>
                    <div class="book" style="width: 68px; background: linear-gradient(135deg, #e17055 0%, #d63031 100%);"></div>
                    <div class="book" style="width: 45px; background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);"></div>
                    <div class="book" style="width: 58px; background: linear-gradient(135deg, #55efc4 0%, #00b894 100%);"></div>
                    <div class="book" style="width: 52px; background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);"></div>
                </div>
            </div>

            <!-- Shelf 3 -->
            <div class="shelf">
                <div class="books-row">
                    <div class="book" style="width: 58px; background: linear-gradient(135deg, #fab1a0 0%, #e17055 100%);"></div>
                    <div class="book" style="width: 52px; background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);"></div>
                    <div class="book" style="width: 65px; background: linear-gradient(135deg, #fdcb6e 0%, #e17055 100%);"></div>
                    <div class="book" style="width: 48px; background: linear-gradient(135deg, #ff7675 0%, #d63031 100%);"></div>
                    <div class="book" style="width: 70px; background: linear-gradient(135deg, #00b894 0%, #00a383 100%);"></div>
                    <div class="book" style="width: 55px; background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);"></div>
                    <div class="book" style="width: 50px; background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);"></div>
                    <div class="book" style="width: 62px; background: linear-gradient(135deg, #55efc4 0%, #00b894 100%);"></div>
                    <div class="book" style="width: 45px; background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);"></div>
                </div>
            </div>

            <!-- Shelf 4 -->
            <div class="shelf">
                <div class="books-row">
                    <div class="book" style="width: 50px; background: linear-gradient(135deg, #6c5ce7 0%, #5f4fd1 100%);"></div>
                    <div class="book" style="width: 68px; background: linear-gradient(135deg, #e17055 0%, #d63031 100%);"></div>
                    <div class="book" style="width: 55px; background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);"></div>
                    <div class="book" style="width: 48px; background: linear-gradient(135deg, #00b894 0%, #00a383 100%);"></div>
                    <div class="book" style="width: 62px; background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);"></div>
                    <div class="book" style="width: 52px; background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);"></div>
                    <div class="book" style="width: 70px; background: linear-gradient(135deg, #55efc4 0%, #00b894 100%);"></div>
                    <div class="book" style="width: 45px; background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);"></div>
                    <div class="book" style="width: 58px; background: linear-gradient(135deg, #fab1a0 0%, #e17055 100%);"></div>
                </div>
            </div>
        </div>
    </section>
</body>
</html>
