<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.library.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Bibliothécaire - Smart Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(to bottom, #f5f1e8 0%, #e8dcc4 100%);
            min-height: 100vh;
        }
        .dashboard {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            padding: 25px 35px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(101, 67, 33, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            color: #ffffff;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .header h1 svg {
            width: 32px;
            height: 32px;
        }
        .header-subtitle {
            color: rgba(255,255,255,0.8);
            font-size: 14px;
            margin-top: 4px;
        }
        .header .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .user-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(255,255,255,0.15);
            border-radius: 50px;
            color: white;
            font-size: 14px;
            font-weight: 500;
        }
        .user-badge svg {
            width: 20px;
            height: 20px;
        }
        .btn-logout {
            padding: 10px 24px;
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(235, 51, 73, 0.3);
        }
        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(235, 51, 73, 0.4);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 28px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s;
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, var(--card-color), transparent);
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .stat-card:nth-child(1) { --card-color: #8b6f47; }
        .stat-card:nth-child(2) { --card-color: #b8956a; }
        .stat-card:nth-child(3) { --card-color: #00b894; }
        .stat-card:nth-child(4) { --card-color: #d63031; }
        .stat-icon {
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            flex-shrink: 0;
        }
        .stat-card:nth-child(1) .stat-icon {
            background: linear-gradient(135deg, #8b6f4715, #8b6f4725);
        }
        .stat-card:nth-child(2) .stat-icon {
            background: linear-gradient(135deg, #b8956a15, #b8956a25);
        }
        .stat-card:nth-child(3) .stat-icon {
            background: linear-gradient(135deg, #00b89415, #00b89425);
        }
        .stat-card:nth-child(4) .stat-icon {
            background: linear-gradient(135deg, #d6303115, #d6303125);
        }
        .stat-icon svg {
            width: 36px;
            height: 36px;
        }
        .stat-info h3 {
            color: #7f8c8d;
            font-size: 13px;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        .stat-info p {
            color: #2c3e50;
            font-size: 36px;
            font-weight: 700;
        }
        .section {
            background: white;
            padding: 30px;
            border-radius: 16px;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
        }
        .section h2 {
            color: #654321;
            margin-bottom: 25px;
            font-size: 22px;
            border-bottom: 3px solid #8b6f47;
            padding-bottom: 15px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .section h2 svg {
            width: 24px;
            height: 24px;
        }
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 20px;
        }
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 15px;
        }
        .table th {
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
        }
        .table th:first-child {
            border-top-left-radius: 10px;
        }
        .table th:last-child {
            border-top-right-radius: 10px;
        }
        .table td {
            padding: 16px;
            border-bottom: 1px solid #ecf0f1;
            font-size: 14px;
            color: #2c3e50;
        }
        .table tr:last-child td {
            border-bottom: none;
        }
        .table tbody tr {
            transition: all 0.2s;
        }
        .table tbody tr:hover {
            background: #f8f9fa;
            transform: scale(1.005);
        }
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .badge-warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffe5a1 100%);
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .badge-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .badge-info {
            background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn svg {
            width: 16px;
            height: 16px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #00b894 0%, #00a383 100%);
            color: white;
            box-shadow: 0 3px 10px rgba(0, 184, 148, 0.3);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 184, 148, 0.4);
        }
        .btn-success {
            background: linear-gradient(135deg, #00b894 0%, #00a383 100%);
            color: white;
            box-shadow: 0 3px 10px rgba(0, 184, 148, 0.3);
        }
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 184, 148, 0.4);
        }
        .btn-danger {
            background: linear-gradient(135deg, #d63031 0%, #c0392b 100%);
            color: white;
            box-shadow: 0 3px 10px rgba(214, 48, 49, 0.3);
        }
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(214, 48, 49, 0.4);
        }
        .alert {
            padding: 18px 24px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            box-shadow: 0 3px 15px rgba(0,0,0,0.1);
        }
        .alert svg {
            width: 22px;
            height: 22px;
            flex-shrink: 0;
        }
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border: 2px solid #28a745;
        }
        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 2px solid #dc3545;
        }
        .tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 25px;
            border-bottom: 2px solid #ecf0f1;
        }
        .tab {
            padding: 14px 24px;
            cursor: pointer;
            border: none;
            background: none;
            font-size: 15px;
            color: #7f8c8d;
            transition: all 0.3s;
            border-bottom: 3px solid transparent;
            font-weight: 500;
            position: relative;
        }
        .tab:hover {
            color: #8b6f47;
            background: rgba(139, 111, 71, 0.05);
        }
        .tab.active {
            color: #8b6f47;
            border-bottom: 3px solid #8b6f47;
            font-weight: 700;
            background: rgba(139, 111, 71, 0.08);
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
        }
        .modal.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            padding: 35px;
            border-radius: 20px;
            max-width: 650px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: -35px -35px 30px -35px;
            padding: 30px 35px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            border-radius: 20px 20px 0 0;
        }
        .modal-header h2 {
            color: #ffffff;
            font-size: 26px;
            margin: 0;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .modal-header h2 svg {
            width: 28px;
            height: 28px;
            stroke: #ffffff;
        }
        .close-modal {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            font-size: 28px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            color: #7f8c8d;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .close-modal:hover {
            background: #e74c3c;
            color: white;
            transform: rotate(90deg);
        }
        .form-group-modal {
            margin-bottom: 24px;
            position: relative;
        }
        .form-group-modal:last-of-type {
            margin-bottom: 30px;
        }
        .form-group-modal label {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
            color: #654321;
            font-weight: 600;
            font-size: 14px;
            letter-spacing: 0.3px;
        }
        .form-group-modal label svg {
            width: 20px;
            height: 20px;
            stroke: #8b6f47;
            flex-shrink: 0;
        }
        .form-group-modal label .required {
            color: #d63031;
            margin-left: 2px;
        }
        .form-group-modal input,
        .form-group-modal select,
        .form-group-modal textarea {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e8dcc4;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: 'Poppins', 'Segoe UI', sans-serif;
            background: #fefdfb;
            color: #2c3e50;
        }
        .form-group-modal input::placeholder,
        .form-group-modal textarea::placeholder {
            color: #95a5a6;
            font-style: italic;
        }
        .form-group-modal select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%238b6f47' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 45px;
        }
        .form-group-modal input:focus,
        .form-group-modal select:focus,
        .form-group-modal textarea:focus {
            outline: none;
            border-color: #8b6f47;
            box-shadow: 0 0 0 4px rgba(139, 111, 71, 0.12), 0 3px 8px rgba(139, 111, 71, 0.1);
            background: #ffffff;
            transform: translateY(-1px);
        }
        .form-group-modal textarea {
            resize: vertical;
            min-height: 110px;
            line-height: 1.6;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
        }
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            .modal-content {
                padding: 25px;
            }
        }
        .form-section-title {
            font-size: 15px;
            font-weight: 600;
            color: #8b6f47;
            margin: 30px 0 15px 0;
            padding-bottom: 8px;
            border-bottom: 2px solid #f0ebe0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-section-title:first-of-type {
            margin-top: 0;
        }
        .form-section-title svg {
            width: 18px;
            height: 18px;
            stroke: #8b6f47;
        }
        .image-upload-container {
            display: flex;
            gap: 20px;
            align-items: flex-start;
        }
        .image-upload-container input[type="file"] {
            flex: 1;
        }
        .image-preview {
            width: 140px;
            height: 200px;
            border: 2px dashed #8b6f47;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: #fefdfb;
            position: relative;
        }
        .image-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 15px;
            text-align: center;
        }
        .image-placeholder svg {
            width: 40px;
            height: 40px;
            stroke: #8b6f47;
            opacity: 0.5;
        }
        .image-placeholder span {
            font-size: 12px;
            color: #8b6f47;
            line-height: 1.4;
        }
        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .btn-submit-modal {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            box-shadow: 0 5px 20px rgba(139, 111, 71, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .btn-submit-modal svg {
            width: 20px;
            height: 20px;
        }
        .btn-submit-modal:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(139, 111, 71, 0.4);
        }
        .btn-submit-modal:active {
            transform: translateY(-1px);
        }
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            margin-top: 25px;
        }
        .book-card {
            background: white;
            border-radius: 16px;
            padding: 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            overflow: hidden;
            border: 1px solid #f0ebe0;
        }
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(139, 111, 71, 0.15);
        }
        .book-cover {
            width: 100%;
            height: 280px;
            object-fit: cover;
            background: linear-gradient(135deg, #e8dcc4 0%, #d4c5a9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .book-cover-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #e8dcc4 0%, #d4c5a9 100%);
        }
        .book-cover-placeholder svg {
            width: 80px;
            height: 80px;
            stroke: #8b6f47;
            opacity: 0.3;
        }
        .book-info {
            padding: 20px;
        }
        .book-title {
            font-size: 18px;
            font-weight: 700;
            color: #654321;
            margin-bottom: 10px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .book-meta {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: #8b6f47;
            font-size: 14px;
        }
        .book-meta svg {
            width: 16px;
            height: 16px;
            stroke: #8b6f47;
            flex-shrink: 0;
        }
        .book-description {
            color: #7f8c8d;
            font-size: 13px;
            line-height: 1.6;
            margin-top: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .btn-details {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #8b6f47 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-details:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 111, 71, 0.3);
        }
        .btn-details svg {
            width: 18px;
            height: 18px;
        }
        #bookDetailsModal .modal-content {
            max-width: 700px;
        }
        .detail-row {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 15px;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0ebe0;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #8b6f47;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .detail-label svg {
            width: 18px;
            height: 18px;
            stroke: #8b6f47;
        }
        .detail-value {
            color: #654321;
        }
        .book-cover-large {
            width: 200px;
            height: 300px;
            margin: 0 auto 25px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .book-cover-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .btn-delete-book {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #d63031 0%, #c0392b 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .btn-delete-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(214, 48, 49, 0.4);
        }
        .btn-delete-book svg {
            width: 20px;
            height: 20px;
        }
    </style>
</head>
<body>
    <%
        Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
        List<Livre> tousLesLivres = (List<Livre>) request.getAttribute("tousLesLivres");
        List<Emprunt> empruntsEnCours = (List<Emprunt>) request.getAttribute("empruntsEnCours");
        List<Emprunt> reservations = (List<Emprunt>) request.getAttribute("reservations");
        List<Emprunt> empruntsEnRetard = (List<Emprunt>) request.getAttribute("empruntsEnRetard");
        List<Emprunt> derniers10Emprunts = (List<Emprunt>) request.getAttribute("derniers10Emprunts");
        Map<String, Long> statistiquesLivres = (Map<String, Long>) request.getAttribute("statistiquesLivres");
        Integer nombreTotalLivres = (Integer) request.getAttribute("nombreTotalLivres");
        Integer nombreTotalLecteurs = (Integer) request.getAttribute("nombreTotalLecteurs");
        Integer nombreEmpruntsActifs = (Integer) request.getAttribute("nombreEmpruntsActifs");
        
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        session.removeAttribute("success");
        session.removeAttribute("error");
    %>

    <div class="dashboard">
        <div class="header">
            <div>
                <h1>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                    </svg>
                    Tableau de bord Bibliothécaire
                </h1>
                <p class="header-subtitle">Gestion de la bibliothèque</p>
            </div>
            <div class="user-info">
                <div class="user-badge">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                    <%= utilisateur.getUsername() %>
                </div>
                <a href="${pageContext.request.contextPath}/pages/google-books-search.jsp" class="btn btn-primary">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                    Rechercher des livres
                </a>
                <button onclick="openModal()" class="btn btn-success">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    Ajouter un livre
                </button>
                <a href="${pageContext.request.contextPath}/statistiques" class="btn btn-info" style="background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                    </svg>
                    Statistiques
                </a>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-logout">Déconnexion</a>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert alert-success">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
                <%= success %>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
                <%= error %>
            </div>
        <% } %>

        <!-- Statistiques -->
        <div class="stats-grid">
            <div class="stat-card" onclick="window.location.href='${pageContext.request.contextPath}/pages/google-books-search.jsp'" style="cursor: pointer;">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#8b6f47" stroke-width="2">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>Total de livres</h3>
                    <p><%= nombreTotalLivres %></p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#b8956a" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>Lecteurs inscrits</h3>
                    <p><%= nombreTotalLecteurs %></p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#00b894" stroke-width="2">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>Emprunts actifs</h3>
                    <p><%= nombreEmpruntsActifs %></p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#d63031" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>En retard</h3>
                    <p style="color: #e74c3c;"><%= empruntsEnRetard.size() %></p>
                </div>
            </div>
        </div>

        <!-- Graphique des 10 derniers livres prêtés -->
        <div class="section">
            <h2>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
                Top 10 des livres les plus empruntés récemment
            </h2>
            <div class="chart-container">
                <canvas id="statsChart"></canvas>
            </div>
        </div>

        <!-- Collection de livres -->
        <div class="section">
            <h2>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                </svg>
                Catalogue de la bibliothèque
            </h2>
            <div class="books-grid">
                <% 
                if (tousLesLivres != null && !tousLesLivres.isEmpty()) {
                    for (Livre livre : tousLesLivres) {
                %>
                    <div class="book-card">
                        <div class="book-cover">
                            <% if (livre.getImageUrl() != null && !livre.getImageUrl().isEmpty()) { %>
                                <img src="<%= livre.getImageUrl() %>" alt="<%= livre.getTitre() %>">
                            <% } else { %>
                                <div class="book-cover-placeholder">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                            <% } %>
                        </div>
                        <div class="book-info">
                            <h3 class="book-title"><%= livre.getTitre() %></h3>
                            <div class="book-meta">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <%= livre.getAuteur() != null ? livre.getAuteur().getPrenom() + " " + livre.getAuteur().getNom() : "Auteur inconnu" %>
                            </div>
                            <div class="book-meta">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <%= livre.getAnnee() != null ? livre.getAnnee() : "Année inconnue" %>
                            </div>
                            <% if (livre.getIsbn() != null && !livre.getIsbn().isEmpty()) { %>
                                <div class="book-meta">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="2" y="6" width="20" height="12" rx="2"></rect>
                                        <line x1="2" y1="10" x2="22" y2="10"></line>
                                    </svg>
                                    <%= livre.getIsbn() %>
                                </div>
                            <% } %>
                            <% if (livre.getDescription() != null && !livre.getDescription().isEmpty()) { %>
                                <p class="book-description"><%= livre.getDescription() %></p>
                            <% } else { %>
                                <p class="book-description">Aucune description disponible...</p>
                            <% } %>
                            <button class="btn-details" onclick="showBookDetails(<%= livre.getId() %>, '<%= livre.getTitre().replace("'", "\\'") %>', '<%= livre.getAuteur() != null ? (livre.getAuteur().getPrenom() + " " + livre.getAuteur().getNom()).replace("'", "\\'") : "Auteur inconnu" %>', '<%= livre.getAnnee() != null ? livre.getAnnee() : "" %>', '<%= livre.getIsbn() != null ? livre.getIsbn().replace("'", "\\'") : "" %>', '<%= livre.getDescription() != null ? livre.getDescription().replace("'", "\\'").replace("\n", " ") : "Aucune description disponible" %>', '<%= livre.getImageUrl() != null ? livre.getImageUrl().replace("'", "\\'") : "" %>')">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="16" x2="12" y2="12"></line>
                                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                </svg>
                                Voir les détails
                            </button>
                        </div>
                    </div>
                <% 
                    }
                } else {
                %>
                    <p style="color: #7f8c8d; grid-column: 1/-1; text-align: center; padding: 40px;">Aucun livre dans la bibliothèque.</p>
                <% } %>
            </div>
        </div>

        <!-- Gestion des emprunts -->
        <div class="section">
            <h2>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="8" y1="6" x2="21" y2="6"></line>
                    <line x1="8" y1="12" x2="21" y2="12"></line>
                    <line x1="8" y1="18" x2="21" y2="18"></line>
                    <line x1="3" y1="6" x2="3.01" y2="6"></line>
                    <line x1="3" y1="12" x2="3.01" y2="12"></line>
                    <line x1="3" y1="18" x2="3.01" y2="18"></line>
                </svg>
                Gestion des emprunts
            </h2>
            <div class="tabs">
                <button class="tab active" onclick="showTab('actifs')">Emprunts actifs (<%= empruntsEnCours.size() %>)</button>
                <button class="tab" onclick="showTab('reservations')">Réservations (<%= reservations.size() %>)</button>
                <button class="tab" onclick="showTab('retards')">En retard (<%= empruntsEnRetard.size() %>)</button>
            </div>

            <div id="actifs" class="tab-content active">
                <% if (empruntsEnCours.isEmpty()) { %>
                    <p style="color: #7f8c8d;">Aucun emprunt actif.</p>
                <% } else { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Livre</th>
                                <th>Lecteur</th>
                                <th>Date d'emprunt</th>
                                <th>Date de retour prévue</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Emprunt emprunt : empruntsEnCours) { %>
                                <tr>
                                    <td><%= emprunt.getLivre().getTitre() %></td>
                                    <td><%= emprunt.getLecteur().getNom() %></td>
                                    <td><%= emprunt.getDateEmprunt() %></td>
                                    <td><%= emprunt.getDateRetourPrevue() %></td>
                                    <td>
                                        <% if (emprunt.isEnRetard()) { %>
                                            <span class="badge badge-danger">En retard</span>
                                        <% } else { %>
                                            <span class="badge badge-success">En cours</span>
                                        <% } %>
                                    </td>
                                    <td class="action-buttons">
                                        <form method="post" action="${pageContext.request.contextPath}/dashboard-bibliothecaire" style="display: inline;">
                                            <input type="hidden" name="action" value="rendre">
                                            <input type="hidden" name="empruntId" value="<%= emprunt.getId() %>">
                                            <button type="submit" class="btn btn-success">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>
                                                Marquer rendu
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>

            <div id="reservations" class="tab-content">
                <% if (reservations.isEmpty()) { %>
                    <p style="color: #7f8c8d;">Aucune réservation en attente.</p>
                <% } else { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Livre</th>
                                <th>Lecteur</th>
                                <th>Date de réservation</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Emprunt reservation : reservations) { %>
                                <tr>
                                    <td><%= reservation.getLivre().getTitre() %></td>
                                    <td><%= reservation.getLecteur().getNom() %></td>
                                    <td><%= reservation.getDateReservation() %></td>
                                    <td><span class="badge badge-warning">Réservé</span></td>
                                    <td class="action-buttons">
                                        <form method="post" action="${pageContext.request.contextPath}/dashboard-bibliothecaire" style="display: inline;">
                                            <input type="hidden" name="action" value="activer-reservation">
                                            <input type="hidden" name="reservationId" value="<%= reservation.getId() %>">
                                            <button type="submit" class="btn btn-primary">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                    <polyline points="12 5 19 12 12 19"></polyline>
                                                </svg>
                                                Activer l'emprunt
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>

            <div id="retards" class="tab-content">
                <% if (empruntsEnRetard.isEmpty()) { %>
                    <p style="color: #7f8c8d;">Aucun emprunt en retard.</p>
                <% } else { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Livre</th>
                                <th>Lecteur</th>
                                <th>Date d'emprunt</th>
                                <th>Date de retour prévue</th>
                                <th>Jours de retard</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Emprunt emprunt : empruntsEnRetard) { %>
                                <tr style="background: #fff3cd;">
                                    <td><%= emprunt.getLivre().getTitre() %></td>
                                    <td><%= emprunt.getLecteur().getNom() %></td>
                                    <td><%= emprunt.getDateEmprunt() %></td>
                                    <td><%= emprunt.getDateRetourPrevue() %></td>
                                    <td><span class="badge badge-danger"><%= Math.abs(emprunt.getJoursRestants()) %> jours</span></td>
                                    <td class="action-buttons">
                                        <form method="post" action="${pageContext.request.contextPath}/dashboard-bibliothecaire" style="display: inline;">
                                            <input type="hidden" name="action" value="rendre">
                                            <input type="hidden" name="empruntId" value="<%= emprunt.getId() %>">
                                            <button type="submit" class="btn btn-danger">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>
                                                Marquer rendu
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>

        <!-- Modal Ajouter un livre -->
        <div id="addBookModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                        Ajouter un nouveau livre
                    </h2>
                    <button class="close-modal" onclick="closeModal()">&times;</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/dashboard-bibliothecaire">
                    <input type="hidden" name="action" value="ajouter-livre">
                    
                    <div class="form-section-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        Informations principales
                    </div>

                    <div class="form-group-modal">
                        <label for="titre">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                            </svg>
                            Titre du livre
                            <span class="required">*</span>
                        </label>
                        <input type="text" id="titre" name="titre" required placeholder="Ex: Les Misérables" autocomplete="off">
                    </div>

                    <div class="form-row">
                        <div class="form-group-modal">
                            <label for="prenomAuteur">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                Prénom de l'auteur
                                <span class="required">*</span>
                            </label>
                            <input type="text" id="prenomAuteur" name="prenomAuteur" required placeholder="Ex: Victor" autocomplete="off">
                        </div>

                        <div class="form-group-modal">
                            <label for="nomAuteur">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                Nom de l'auteur
                                <span class="required">*</span>
                            </label>
                            <input type="text" id="nomAuteur" name="nomAuteur" required placeholder="Ex: Hugo" autocomplete="off">
                        </div>
                    </div>

                    <div class="form-section-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                            <line x1="8" y1="21" x2="16" y2="21"></line>
                            <line x1="12" y1="17" x2="12" y2="21"></line>
                        </svg>
                        Détails du livre
                    </div>

                    <div class="form-row">
                        <div class="form-group-modal">
                            <label for="annee">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                Année
                                <span class="required">*</span>
                            </label>
                            <input type="number" id="annee" name="annee" required min="1000" max="2100" placeholder="1862">
                        </div>

                        <div class="form-group-modal">
                            <label for="isbn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="2" y="6" width="20" height="12" rx="2"></rect>
                                    <line x1="2" y1="10" x2="22" y2="10"></line>
                                </svg>
                                ISBN
                            </label>
                            <input type="text" id="isbn" name="isbn" placeholder="978-2-07-036822-9">
                        </div>
                    </div>

                    <div class="form-group-modal">
                        <label for="genre">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                                <polyline points="2 17 12 22 22 17"></polyline>
                                <polyline points="2 12 12 17 22 12"></polyline>
                            </svg>
                            Genre littéraire
                        </label>
                        <select id="genre" name="genre">
                            <option value="">Sélectionnez un genre</option>
                            <option value="Roman">Roman</option>
                            <option value="Science-Fiction">Science-Fiction</option>
                            <option value="Fantastique">Fantastique</option>
                            <option value="Thriller">Thriller</option>
                            <option value="Policier">Policier</option>
                            <option value="Biographie">Biographie</option>
                            <option value="Histoire">Histoire</option>
                            <option value="Philosophie">Philosophie</option>
                            <option value="Poésie">Poésie</option>
                            <option value="Théâtre">Théâtre</option>
                            <option value="Essai">Essai</option>
                            <option value="Autre">Autre</option>
                        </select>
                    </div>

                    <div class="form-group-modal">
                        <label for="couverture">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                            Image de couverture
                        </label>
                        <div class="image-upload-container">
                            <input type="file" id="couverture" name="couverture" accept="image/*" onchange="previewCoverImage(event)">
                            <div class="image-preview" id="imagePreview">
                                <div class="image-placeholder">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                        <polyline points="21 15 16 10 5 21"></polyline>
                                    </svg>
                                    <span>Aucune image sélectionnée</span>
                                </div>
                                <img id="coverPreview" style="display: none;">
                            </div>
                        </div>
                    </div>

                    <div class="form-group-modal">
                        <label for="description">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                            </svg>
                            Description
                        </label>
                        <textarea id="description" name="description" placeholder="Résumé ou description du livre..." rows="4"></textarea>
                    </div>

                    <button type="submit" class="btn-submit-modal">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        Ajouter le livre
                    </button>
                </form>
            </div>
        </div>

        <!-- Modal Détails du livre -->
        <div id="bookDetailsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                        Détails du livre
                    </h2>
                    <button class="close-modal" onclick="closeDetailsModal()">&times;</button>
                </div>
                <div id="bookDetailsContent">
                    <!-- Le contenu sera inséré dynamiquement par JavaScript -->
                </div>
            </div>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById('addBookModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('addBookModal').classList.remove('active');
            // Réinitialiser l'aperçu de l'image
            document.getElementById('coverPreview').style.display = 'none';
            document.getElementById('coverPreview').src = '';
            document.querySelector('.image-placeholder').style.display = 'flex';
        }

        function closeDetailsModal() {
            document.getElementById('bookDetailsModal').classList.remove('active');
        }
        
        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text || '';
            return div.innerHTML;
        }
        
        function escapeJs(text) {
            if (!text) return '';
            return text.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, ' ').replace(/\r/g, ' ');
        }

        function showBookDetails(id, titre, auteur, annee, isbn, description, imageUrl) {
            var content = '';
            
            if (imageUrl && imageUrl.trim() !== '') {
                content += '<div class="book-cover-large">';
                content += '<img src="' + escapeHtml(imageUrl) + '" alt="' + escapeHtml(titre) + '">';
                content += '</div>';
            }
            
            content += '<div class="detail-row">';
            content += '<div class="detail-label">';
            content += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
            content += '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>';
            content += '<path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>';
            content += '</svg>';
            content += 'Titre';
            content += '</div>';
            content += '<div class="detail-value"><strong>' + escapeHtml(titre) + '</strong></div>';
            content += '</div>';
            
            content += '<div class="detail-row">';
            content += '<div class="detail-label">';
            content += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
            content += '<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>';
            content += '<circle cx="12" cy="7" r="4"></circle>';
            content += '</svg>';
            content += 'Auteur';
            content += '</div>';
            content += '<div class="detail-value">' + escapeHtml(auteur) + '</div>';
            content += '</div>';
            
            if (annee && annee !== '') {
                content += '<div class="detail-row">';
                content += '<div class="detail-label">';
                content += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
                content += '<rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>';
                content += '<line x1="16" y1="2" x2="16" y2="6"></line>';
                content += '<line x1="8" y1="2" x2="8" y2="6"></line>';
                content += '<line x1="3" y1="10" x2="21" y2="10"></line>';
                content += '</svg>';
                content += 'Année';
                content += '</div>';
                content += '<div class="detail-value">' + escapeHtml(annee) + '</div>';
                content += '</div>';
            }
            
            if (isbn && isbn !== '') {
                content += '<div class="detail-row">';
                content += '<div class="detail-label">';
                content += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
                content += '<rect x="2" y="6" width="20" height="12" rx="2"></rect>';
                content += '<line x1="2" y1="10" x2="22" y2="10"></line>';
                content += '</svg>';
                content += 'ISBN';
                content += '</div>';
                content += '<div class="detail-value">' + escapeHtml(isbn) + '</div>';
                content += '</div>';
            }
            
            content += '<div class="detail-row">';
            content += '<div class="detail-label">';
            content += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
            content += '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>';
            content += '</svg>';
            content += 'Description';
            content += '</div>';
            content += '<div class="detail-value">' + escapeHtml(description) + '</div>';
            content += '</div>';
            
            content += '<button class="btn-delete-book" onclick="deleteBook(' + id + ', \'' + escapeJs(titre) + '\')">';
            content += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">';
            content += '<polyline points="3 6 5 6 21 6"></polyline>';
            content += '<path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>';
            content += '<line x1="10" y1="11" x2="10" y2="17"></line>';
            content += '<line x1="14" y1="11" x2="14" y2="17"></line>';
            content += '</svg>';
            content += 'Supprimer ce livre';
            content += '</button>';
            
            document.getElementById('bookDetailsContent').innerHTML = content;
            document.getElementById('bookDetailsModal').classList.add('active');
        }

        function deleteBook(livreId, titre) {
            if (confirm('Êtes-vous sûr de vouloir supprimer le livre "' + titre + '" ?\n\nCette action est irréversible.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/dashboard-bibliothecaire';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'supprimer-livre';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'livreId';
                idInput.value = livreId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function previewCoverImage(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('coverPreview');
                    const placeholder = document.querySelector('.image-placeholder');
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    placeholder.style.display = 'none';
                }
                reader.readAsDataURL(file);
            }
        }

        // Fermer le modal en cliquant à l'extérieur
        window.onclick = function(event) {
            const addModal = document.getElementById('addBookModal');
            const detailsModal = document.getElementById('bookDetailsModal');
            if (event.target === addModal) {
                closeModal();
            }
            if (event.target === detailsModal) {
                closeDetailsModal();
            }
        }

        function showTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            document.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
        }

        // Graphique des statistiques
        const ctx = document.getElementById('statsChart').getContext('2d');
        const statistiques = <%= new com.google.gson.Gson().toJson(statistiquesLivres) %>;
        
        const labels = Object.keys(statistiques);
        const data = Object.values(statistiques);

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Nombre d\'emprunts',
                    data: data,
                    backgroundColor: 'rgba(52, 152, 219, 0.6)',
                    borderColor: 'rgba(52, 152, 219, 1)',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    title: {
                        display: false
                    }
                }
            }
        });
    </script>
</body>
</html>
