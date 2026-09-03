<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("pendingRequests") == null
            && request.getAttribute("dashboardError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/assistant/Dashboard"
        );

        return;
    }

    Integer pendingRequestsValue =
            (Integer) request.getAttribute("pendingRequests");

    Integer todayConfirmedValue =
            (Integer) request.getAttribute("todayConfirmed");

    Integer completedTreatmentsValue =
            (Integer) request.getAttribute("completedTreatments");

    Integer billsToGenerateValue =
            (Integer) request.getAttribute("billsToGenerate");

    String dashboardError =
            (String) request.getAttribute("dashboardError");

    int pendingRequests =
            pendingRequestsValue != null
            ? pendingRequestsValue
            : 0;

    int todayConfirmed =
            todayConfirmedValue != null
            ? todayConfirmedValue
            : 0;

    int completedTreatments =
            completedTreatmentsValue != null
            ? completedTreatmentsValue
            : 0;

    int billsToGenerate =
            billsToGenerateValue != null
            ? billsToGenerateValue
            : 0;
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Assistant Dashboard | Sunrise Dental Clinic
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
            line-height: 1.6;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 22px;
            line-height: 1.5;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 18px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            border: 1px solid transparent;
            transition: 0.2s;
        }

        .card:hover {
            transform: translateY(-2px);
            border-color: #d8eaf2;
        }

        .card h3 {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .card p {
            font-size: 28px;
            font-weight: bold;
            color: #0f5f87;
        }

        .card-note {
            color: #9ca3af;
            font-size: 11px;
            margin-top: 8px;
            line-height: 1.5;
        }

        .section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .section-title {
            color: #0f5f87;
            margin-bottom: 18px;
            font-size: 20px;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(4,1fr);
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
            border-color: #b8d9e8;
            transform: translateY(-2px);
        }

        .action h3 {
            color: #0f5f87;
            margin-bottom: 7px;
            font-size: 16px;
        }

        .action p {
            color: #6b7280;
            font-size: 13px;
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
            margin-bottom: 8px;
            font-size: 15px;
        }

        .workflow-box p {
            color: #4b5563;
            font-size: 13px;
            line-height: 1.7;
        }

        @media(max-width: 1150px) {

            .stats {
                grid-template-columns: repeat(2,1fr);
            }

            .actions {
                grid-template-columns: repeat(2,1fr);
            }
        }

        @media(max-width: 700px) {

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
            DENTIST ASSISTANT
        </div>

        <nav class="menu">

            <a class="active"
               href="<%= request.getContextPath() %>/assistant/Dashboard">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/assistant/PendingAppointments">
                Pending Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments">
                Confirmed Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/TreatmentRecords">
                Treatment Records
            </a>

            <a href="<%= request.getContextPath() %>/AppointmentSearch">
                Appointment Search
            </a>

            <a href="<%= request.getContextPath() %>/Help">
                Help
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
                    Dentist Assistant Dashboard
                </h1>

                <p>
                    Manage your assigned dentist's appointments,
                    treatment records and patient billing workflow.
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

                <div class="card">

                    <h3>
                        Pending Requests
                    </h3>

                    <p>
                        <%= pendingRequests %>
                    </p>

                    <div class="card-note">
                        Appointment requests awaiting review
                        for your assigned dentist.
                    </div>

                </div>

                <div class="card">

                    <h3>
                        Today's Confirmed
                    </h3>

                    <p>
                        <%= todayConfirmed %>
                    </p>

                    <div class="card-note">
                        Confirmed appointments scheduled
                        for your dentist today.
                    </div>

                </div>

                <div class="card">

                    <h3>
                        Completed Treatments
                    </h3>

                    <p>
                        <%= completedTreatments %>
                    </p>

                    <div class="card-note">
                        Completed appointments with recorded
                        treatment information.
                    </div>

                </div>

                <div class="card">

                    <h3>
                        Bills to Generate
                    </h3>

                    <p>
                        <%= billsToGenerate %>
                    </p>

                    <div class="card-note">
                        Completed treatments that do not
                        yet have a generated bill.
                    </div>

                </div>

            </div>

            <div class="section">

                <h2 class="section-title">
                    Quick Actions
                </h2>

                <div class="actions">

                    <a href="<%= request.getContextPath() %>/assistant/PendingAppointments"
                       class="action">

                        <h3>
                            Pending Appointments
                        </h3>

                        <p>
                            Review appointment requests for your
                            assigned dentist and confirm, reschedule
                            or cancel where required.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments"
                       class="action">

                        <h3>
                            Confirmed Appointments
                        </h3>

                        <p>
                            View confirmed appointments and
                            begin treatment recording after
                            the patient is treated.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/assistant/TreatmentRecords"
                       class="action">

                        <h3>
                            Treatment Records & Billing
                        </h3>

                        <p>
                            Review completed treatments,
                            treatment items and generate or
                            view patient bills.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/AppointmentSearch"
                       class="action">

                        <h3>
                            Appointment Search
                        </h3>

                        <p>
                            Search using an appointment number
                            and view patient, dentist, service
                            and appointment information.
                        </p>

                    </a>

                </div>

                <div class="workflow-box">

                    <h3>
                        Dentist Assistant Workflow
                    </h3>

                    <p>
                        Review Pending Appointments →
                        confirm the dentist's availability →
                        manage confirmed appointments →
                        record the actual treatment performed →
                        add treatment items or additional work →
                        complete the treatment →
                        generate or view the bill →
                        cashier handles the final payment.
                    </p>

                </div>

            </div>

        </div>

    </main>

</div>

</body>

</html>