<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Utilisateur" %>
<%
    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
    if (utilisateur == null || utilisateur.getRole() != Utilisateur.Role.BIBLIOTHECAIRE) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - Smart Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
            color: #1a1d1f;
            line-height: 1.6;
        }
        
        /* Page container avec sidebar simulation */
        .dashboard {
            max-width: 1600px;
            margin: 0 auto;
            padding: 0;
            display: grid;
            grid-template-columns: 1fr;
            gap: 0;
        }
        
        /* Header professionnel premium */
        .header {
            background: linear-gradient(135deg, #1a1d1f 0%, #2d3436 100%);
            padding: 32px 48px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.12);
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 3px solid #8b6f47;
        }
        
        .header-wrapper {
            max-width: 1600px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
        }
        
        .header-left {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .header h1 {
            color: #ffffff;
            font-size: 32px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 16px;
            letter-spacing: -0.5px;
        }
        
        .header h1 svg {
            width: 36px;
            height: 36px;
            filter: drop-shadow(0 2px 8px rgba(139, 111, 71, 0.5));
        }
        
        .header-subtitle {
            color: rgba(255,255,255,0.7);
            font-size: 14px;
            font-weight: 400;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .header-buttons {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        
        .action-btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        
        .action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            transition: left 0.5s;
        }
        
        .action-btn:hover::before {
            left: 100%;
        }
        
        .action-btn svg {
            width: 18px;
            height: 18px;
        }
        
        .btn-export {
            background: linear-gradient(135deg, #00b894 0%, #00a383 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 184, 148, 0.3);
        }
        
        .btn-export:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 184, 148, 0.4);
        }
        
        .btn-back {
            background: rgba(255,255,255,0.1);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }
        
        .btn-back:hover {
            background: rgba(255,255,255,0.15);
            transform: translateY(-2px);
        }
        
        /* Content area */
        .content-area {
            padding: 40px 48px;
            max-width: 1600px;
            margin: 0 auto;
            width: 100%;
        }
        
        /* Stats grid moderne */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            padding: 28px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.06);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--card-gradient);
            transition: height 0.3s;
        }
        
        .stat-card:hover::before {
            height: 5px;
        }
        
        .stat-card:nth-child(1) { 
            --card-gradient: linear-gradient(90deg, #8b6f47, #b8956a);
            --card-icon-bg: rgba(139, 111, 71, 0.1);
            --card-icon-color: #8b6f47;
        }
        .stat-card:nth-child(2) { 
            --card-gradient: linear-gradient(90deg, #667eea, #764ba2);
            --card-icon-bg: rgba(102, 126, 234, 0.1);
            --card-icon-color: #667eea;
        }
        .stat-card:nth-child(3) { 
            --card-gradient: linear-gradient(90deg, #00b894, #00cec9);
            --card-icon-bg: rgba(0, 184, 148, 0.1);
            --card-icon-color: #00b894;
        }
        .stat-card:nth-child(4) { 
            --card-gradient: linear-gradient(90deg, #fdcb6e, #f39c12);
            --card-icon-bg: rgba(253, 203, 110, 0.1);
            --card-icon-color: #f39c12;
        }
        .stat-card:nth-child(5) { 
            --card-gradient: linear-gradient(90deg, #d63031, #e17055);
            --card-icon-bg: rgba(214, 48, 49, 0.1);
            --card-icon-color: #d63031;
        }
        
        .stat-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.12);
        }
        
        .stat-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        
        .stat-card h3 {
            color: #6c757d;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: var(--card-icon-bg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--card-icon-color);
        }
        
        .stat-icon svg {
            width: 24px;
            height: 24px;
        }
        
        .stat-value {
            font-size: 42px;
            font-weight: 700;
            color: #1a1d1f;
            line-height: 1;
            margin-bottom: 8px;
        }
        
        .stat-change {
            font-size: 13px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .stat-change.positive {
            color: #00b894;
        }
        
        .stat-change.negative {
            color: #d63031;
        }
        
        .stat-change svg {
            width: 16px;
            height: 16px;
        }
        
        /* Charts section */
        .charts-section {
            display: grid;
            gap: 24px;
        }
        
        .chart-container {
            background: white;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.06);
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f3f5;
        }
        
        .chart-header h2 {
            color: #1a1d1f;
            font-size: 22px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .chart-header svg {
            width: 24px;
            height: 24px;
            color: #8b6f47;
        }
        
        .chart-period {
            font-size: 13px;
            color: #6c757d;
            background: #f8f9fa;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .charts-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 24px;
        }
        
        canvas {
            max-height: 380px;
        }
        
        .full-width-chart {
            grid-column: 1 / -1;
        }
        
        /* Loading élégant */
        .loading {
            text-align: center;
            padding: 80px 40px;
            color: #6c757d;
        }
        
        .loading-spinner {
            width: 48px;
            height: 48px;
            border: 4px solid #f1f3f5;
            border-top-color: #8b6f47;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .loading-text {
            font-size: 16px;
            font-weight: 600;
        }
        
        /* Responsive */
        @media (max-width: 1200px) {
            .charts-row {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .header {
                padding: 24px;
            }
            
            .content-area {
                padding: 24px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <!-- Header Premium -->
        <div class="header">
            <div class="header-wrapper">
                <div class="header-left">
                    <h1>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                            <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                        </svg>
                        Tableau de Bord Analytique
                    </h1>
                    <div class="header-subtitle">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 16px; height: 16px;">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                        Mis à jour en temps réel • Smart Library Management
                    </div>
                </div>

                <div class="header-buttons">
                    <a href="${pageContext.request.contextPath}/statistiques?action=export-excel" class="action-btn btn-export">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="12" y1="18" x2="12" y2="12"></line>
                            <line x1="9" y1="15" x2="15" y2="15"></line>
                        </svg>
                        Export CSV
                    </a>
                    <a href="${pageContext.request.contextPath}/statistiques?action=export-pdf" class="action-btn btn-export">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                        </svg>
                        Export Rapport
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard-bibliothecaire" class="action-btn btn-back">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        Retour
                    </a>
                </div>
            </div>
        </div>

        <!-- Loading State -->
        <div id="loading" class="loading">
            <div class="loading-spinner"></div>
            <div class="loading-text">Chargement des statistiques...</div>
        </div>

        <!-- Content Area -->
        <div id="statsContent" class="content-area" style="display: none;">
            <!-- KPI Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <h3>Total Emprunts</h3>
                        <div class="stat-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value" id="totalEmprunts">0</div>
                    <div class="stat-change positive">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="19" x2="12" y2="5"></line>
                            <polyline points="5 12 12 5 19 12"></polyline>
                        </svg>
                        Tous les temps
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <h3>Total Livres</h3>
                        <div class="stat-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value" id="totalLivres">0</div>
                    <div class="stat-change positive">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="19" x2="12" y2="5"></line>
                            <polyline points="5 12 12 5 19 12"></polyline>
                        </svg>
                        Collection totale
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <h3>Lecteurs Actifs</h3>
                        <div class="stat-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value" id="totalLecteurs">0</div>
                    <div class="stat-change positive">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="19" x2="12" y2="5"></line>
                            <polyline points="5 12 12 5 19 12"></polyline>
                        </svg>
                        Membres inscrits
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <h3>Emprunts En Cours</h3>
                        <div class="stat-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value" id="empruntsActifs">0</div>
                    <div class="stat-change positive">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                        </svg>
                        Actifs maintenant
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <h3>Retards</h3>
                        <div class="stat-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value" id="empruntsRetard" style="color: #d63031;">0</div>
                    <div class="stat-change negative">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                            <line x1="9" y1="9" x2="15" y2="15"></line>
                        </svg>
                        Nécessite attention
                    </div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-section">
                <div class="charts-row">
                    <div class="chart-container">
                        <div class="chart-header">
                            <h2>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                                Top 10 Livres
                            </h2>
                            <div class="chart-period">Les plus empruntés</div>
                        </div>
                        <canvas id="topLivresChart"></canvas>
                    </div>
                    
                    <div class="chart-container">
                        <div class="chart-header">
                            <h2>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="2" y1="12" x2="22" y2="12"></line>
                                    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                                </svg>
                                Répartition Statuts
                            </h2>
                            <div class="chart-period">Distribution actuelle</div>
                        </div>
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>

                <div class="chart-container full-width-chart">
                    <div class="chart-header">
                        <h2>
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                            </svg>
                            Tendance des Emprunts
                        </h2>
                        <div class="chart-period">12 derniers mois</div>
                    </div>
                    <canvas id="trendChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <script>
        let topLivresChart, statusChart, trendChart;

        async function loadStatistics() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/statistiques?action=api');
                const data = await response.json();
                
                // Mettre à jour les cartes
                document.getElementById('totalEmprunts').textContent = data.totalEmprunts;
                document.getElementById('totalLivres').textContent = data.totalLivres;
                document.getElementById('totalLecteurs').textContent = data.totalLecteurs;
                document.getElementById('empruntsActifs').textContent = data.empruntsActifs;
                document.getElementById('empruntsRetard').textContent = data.empruntsRetard;
                
                // Créer les graphiques
                createTopLivresChart(data.topLivres);
                createStatusChart(data.statusDistribution);
                createTrendChart(data.empruntsByMonth);
                
                // Afficher le contenu
                document.getElementById('loading').style.display = 'none';
                document.getElementById('statsContent').style.display = 'block';
                
            } catch (error) {
                console.error('Erreur:', error);
                document.getElementById('loading').innerHTML = '❌ Erreur lors du chargement des statistiques';
            }
        }

        function createTopLivresChart(data) {
            const ctx = document.getElementById('topLivresChart');
            const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 400, 0);
            gradient.addColorStop(0, 'rgba(139, 111, 71, 0.85)');
            gradient.addColorStop(1, 'rgba(184, 149, 106, 0.5)');
            
            topLivresChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.map(item => item.titre.length > 25 ? item.titre.substring(0, 25) + '...' : item.titre),
                    datasets: [{
                        label: 'Emprunts',
                        data: data.map(item => item.nombre),
                        backgroundColor: gradient,
                        borderColor: '#8b6f47',
                        borderWidth: 0,
                        borderRadius: 8,
                        barThickness: 28
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(26, 29, 31, 0.95)',
                            padding: 16,
                            cornerRadius: 10,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    return 'Emprunts: ' + context.parsed.x;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.04)',
                                drawBorder: false
                            },
                            ticks: {
                                font: { size: 12, weight: '500' },
                                color: '#6c757d',
                                precision: 0
                            }
                        },
                        y: {
                            grid: { display: false },
                            ticks: {
                                font: { size: 11, weight: '500' },
                                color: '#1a1d1f'
                            }
                        }
                    }
                }
            });
        }

        function createStatusChart(data) {
            const ctx = document.getElementById('statusChart');
            const labels = Object.keys(data);
            const values = Object.values(data);
            
            const colors = {
                'EN_COURS': '#667eea',
                'RETOURNE': '#00b894',
                'RETARD': '#d63031'
            };
            
            statusChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels.map(l => {
                        switch(l) {
                            case 'EN_COURS': return 'En cours';
                            case 'RETOURNE': return 'Retournés';
                            case 'RETARD': return 'En retard';
                            default: return l;
                        }
                    }),
                    datasets: [{
                        data: values,
                        backgroundColor: labels.map(l => colors[l] || '#fdcb6e'),
                        borderWidth: 4,
                        borderColor: '#ffffff',
                        hoverOffset: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '60%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                font: { size: 13, weight: '600' },
                                color: '#1a1d1f',
                                usePointStyle: true,
                                pointStyle: 'circle',
                                boxWidth: 12
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(26, 29, 31, 0.95)',
                            padding: 16,
                            cornerRadius: 10,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.parsed;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = Math.round((value / total) * 100);
                                    return label + ': ' + value + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }

        function createTrendChart(data) {
            const ctx = document.getElementById('trendChart');
            const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 320);
            gradient.addColorStop(0, 'rgba(0, 184, 148, 0.35)');
            gradient.addColorStop(1, 'rgba(0, 184, 148, 0)');
            
            const labels = Object.keys(data);
            const values = Object.values(data);
            
            trendChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Emprunts',
                        data: values,
                        borderColor: '#00b894',
                        backgroundColor: gradient,
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#00b894',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 3,
                        pointRadius: 5,
                        pointHoverRadius: 8,
                        pointHoverBorderWidth: 3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        intersect: false,
                        mode: 'index'
                    },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(26, 29, 31, 0.95)',
                            padding: 16,
                            cornerRadius: 10,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            displayColors: false,
                            callbacks: {
                                title: function(context) {
                                    return context[0].label;
                                },
                                label: function(context) {
                                    return 'Emprunts: ' + context.parsed.y;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.04)',
                                drawBorder: false
                            },
                            ticks: {
                                font: { size: 12, weight: '500' },
                                color: '#6c757d',
                                precision: 0,
                                padding: 12
                            }
                        },
                        x: {
                            grid: { display: false, drawBorder: false },
                            ticks: {
                                font: { size: 12, weight: '500' },
                                color: '#6c757d',
                                maxRotation: 0
                            }
                        }
                    }
                }
            });
        }

        // Charger les statistiques au chargement de la page
        document.addEventListener('DOMContentLoaded', loadStatistics);
    </script>
</body>
</html>
