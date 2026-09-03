<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Integer totalPatientsValue =
            (Integer) request.getAttribute("totalPatients");

    Integer activeDentistsValue =
            (Integer) request.getAttribute("activeDentists");

    Integer todayAppointmentsValue =
            (Integer) request.getAttribute("todayAppointments");

    BigDecimal todayRevenueValue =
            (BigDecimal) request.getAttribute("todayRevenue");

    String dashboardError =
            (String) request.getAttribute("dashboardError");

    int totalPatients =
            totalPatientsValue != null
            ? totalPatientsValue
            : 0;

    int activeDentists =
            activeDentistsValue != null
            ? activeDentistsValue
            : 0;

    int todayAppointments =
            todayAppointmentsValue != null
            ? todayAppointmentsValue
            : 0;

    BigDecimal todayRevenue =
            todayRevenueValue != null
            ? todayRevenueValue
            : BigDecimal.ZERO;

    DecimalFormat moneyFormat =
            new DecimalFormat("#,##0.00");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Admin Dashboard | Sunrise Dental Clinic
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        html,
        body {
            width: 100%;
            min-height: 100%;
            overflow-x: hidden;
        }

        body {
            background: #f4f8fb;
            color: #1f2937;
        }

        .layout {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        .sidebar {
            width: 260px;
            min-width: 260px;
            background: #0f5f87;
            color: white;
            padding: 25px 20px;
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .role-label {
            color: #d6edf7;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 35px;
        }

        .menu a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 12px 14px;
            margin-bottom: 7px;
            border-radius: 6px;
            transition: 0.2s;
        }

        .menu a:hover,
        .menu .active {
            background: rgba(255,255,255,0.18);
        }

        .main {
            flex: 1;
            min-width: 0;
        }

        .topbar {
            background: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }

        .welcome {
            font-weight: bold;
        }

        .logout {
            color: #b91c1c;
            text-decoration: none;
            font-weight: bold;
        }

        .content {
            padding: 30px;
            min-width: 0;
        }

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            color: #0f5f87;
            margin-bottom: 6px;
            font-size: 32px;
        }

        .page-header p {
            color: #6b7280;
            line-height: 1.5;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            border: 1px solid transparent;
            transition: 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            border-color: #d8eaf2;
        }

        .stat-card h3 {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .stat-card p {
            font-size: 28px;
            font-weight: bold;
            color: #0f5f87;
        }

        .revenue-value {
            font-size: 24px !important;
        }

        .section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
        }

        .section h2 {
            color: #0f5f87;
            margin-bottom: 18px;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .action {
            display: block;
            text-decoration: none;
            background: #eef7fb;
            padding: 20px;
            border-radius: 8px;
            color: #1f2937;
            border: 1px solid transparent;
            transition: 0.2s;
        }

        .action:hover {
            background: #e2f2f8;
            border-color: #b8dce9;
            transform: translateY(-2px);
        }

        .action h3 {
            color: #0f5f87;
            margin-bottom: 6px;
        }

        .action p {
            font-size: 13px;
            color: #6b7280;
            line-height: 1.5;
        }

        .workflow-box {
            margin-top: 25px;
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 18px;
            border-radius: 8px;
        }

        .workflow-box h3 {
            color: #0f5f87;
            font-size: 15px;
            margin-bottom: 7px;
        }

        .workflow-box p {
            color: #4b5563;
            font-size: 13px;
            line-height: 1.6;
        }

        @media(max-width: 1100px) {

            .stats,
            .actions {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 750px) {

            .sidebar {
                display: none;
            }

            .content {
                padding: 20px;
            }

            .topbar {
                padding: 16px 20px;
            }

            .stats,
            .actions {
                grid-template-columns: 1fr;
            }
        }

    </style>

</head>

<body>

<div class="layout">

    <aside class="sidebar">

        <div class="logo">
            Sunrise Dental
        </div>

        <div class="role-label">
            ADMINISTRATION
        </div>

        <nav class="menu">

            <a class="active"
               href="<%= request.getContextPath() %>/admin/Dashboard">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageDentists">
                Manage Dentists
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageAssistants">
                Manage Assistants
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageCashiers">
                Manage Cashiers
            </a>

            <a href="<%= request.getContextPath() %>/AppointmentSearch">
                Appointment Search
            </a>

            <a href="<%= request.getContextPath() %>/admin/Patients">
                Patients
            </a>

            <a href="<%= request.getContextPath() %>/admin/Appointments">
                Appointments
            </a>

            <a href="<%= request.getContextPath() %>/admin/Payments">
                Payments
            </a>

            <a href="<%= request.getContextPath() %>/admin/Reports">
                Reports
            </a>

            <a href="<%= request.getContextPath() %>/admin/AuditLogs">
                Audit Logs
            </a>

        </nav>

    </aside>

    <main class="main">

        <div class="topbar">

            <div class="welcome">

                Welcome,
                <%= session.getAttribute("fullName") %>

            </div>

            <a href="<%= request.getContextPath() %>/LogoutServlet"
               class="logout">

                Logout

            </a>

        </div>

        <div class="content">

            <div class="page-header">

                <h1>
                    Admin Dashboard
                </h1>

                <p>
                    Manage clinic staff, patients, appointments,
                    payments, reports and system activities.
                </p>

            </div>

            <%
                if (dashboardError != null) {
            %>

            <div class="error-message">

                <strong>
                    Dashboard Error
                </strong>

                <br>

                <%= dashboardError %>

            </div>

            <%
                }
            %>

            <div class="stats">

                <div class="stat-card">

                    <h3>
                        Total Patients
                    </h3>

                    <p>
                        <%= totalPatients %>
                    </p>

                </div>

                <div class="stat-card">

                    <h3>
                        Active Dentists
                    </h3>

                    <p>
                        <%= activeDentists %>
                    </p>

                </div>

                <div class="stat-card">

                    <h3>
                        Today's Appointments
                    </h3>

                    <p>
                        <%= todayAppointments %>
                    </p>

                </div>

                <div class="stat-card">

                    <h3>
                        Today's Revenue
                    </h3>

                    <p class="revenue-value">

                        Rs.
                        <%= moneyFormat.format(todayRevenue) %>

                    </p>

                </div>

            </div>

            <div class="section">

                <h2>
                    Quick Management
                </h2>

                <div class="actions">

                    <a href="<%= request.getContextPath() %>/admin/ManageDentists"
                       class="action">

                        <h3>
                            Manage Dentists
                        </h3>

                        <p>
                            Add, update or disable clinic dentists.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/ManageAssistants"
                       class="action">

                        <h3>
                            Manage Assistants
                        </h3>

                        <p>
                            Create assistants and assign them
                            to dentists.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/ManageCashiers"
                       class="action">

                        <h3>
                            Manage Cashiers
                        </h3>

                        <p>
                            Add, disable or replace the clinic cashier.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/AppointmentSearch"
                       class="action">

                        <h3>
                            Appointment Search
                        </h3>

                        <p>
                            Search an appointment number and
                            view complete appointment information.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/Patients"
                       class="action">

                        <h3>
                            Patients
                        </h3>

                        <p>
                            View registered patients,
                            contact details and appointment activity.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/Appointments"
                       class="action">

                        <h3>
                            Appointments
                        </h3>

                        <p>
                            Search, filter and review all
                            clinic appointment activity.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/Payments"
                       class="action">

                        <h3>
                            Payments
                        </h3>

                        <p>
                            Review payment transactions,
                            methods and clinic revenue.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/Reports"
                       class="action">

                        <h3>
                            Reports
                        </h3>

                        <p>
                            Generate appointment and
                            revenue reports by date period.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/admin/AuditLogs"
                       class="action">

                        <h3>
                            Audit Logs
                        </h3>

                        <p>
                            Review important user and
                            system activities.
                        </p>

                    </a>

                </div>

                <div class="workflow-box">

                    <h3>
                        Administration Workflow
                    </h3>

                    <p>
                        Manage clinic staff →
                        review patients →
                        search and monitor appointments →
                        review payment transactions →
                        generate clinic reports →
                        inspect important system activities.
                    </p>

                </div>

            </div>

        </div>

    </main>

</div>

</body>

</html>