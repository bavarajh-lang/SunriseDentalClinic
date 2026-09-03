<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("upcomingAppointments") == null
            && request.getAttribute("dashboardError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/patient/Dashboard"
        );

        return;
    }

    Integer upcomingAppointmentsValue =
            (Integer) request.getAttribute(
                    "upcomingAppointments"
            );

    Integer pendingRequestsValue =
            (Integer) request.getAttribute(
                    "pendingRequests"
            );

    Integer completedTreatmentsValue =
            (Integer) request.getAttribute(
                    "completedTreatments"
            );

    Integer unpaidBillsValue =
            (Integer) request.getAttribute(
                    "unpaidBills"
            );

    String dashboardError =
            (String) request.getAttribute(
                    "dashboardError"
            );

    int upcomingAppointments =
            upcomingAppointmentsValue != null
            ? upcomingAppointmentsValue
            : 0;

    int pendingRequests =
            pendingRequestsValue != null
            ? pendingRequestsValue
            : 0;

    int completedTreatments =
            completedTreatmentsValue != null
            ? completedTreatmentsValue
            : 0;

    int unpaidBills =
            unpaidBillsValue != null
            ? unpaidBillsValue
            : 0;
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Patient Dashboard | Sunrise Dental Clinic
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
            width: 250px;
            min-width: 250px;
            background: #0f5f87;
            color: white;
            padding: 25px 20px;
        }

        .logo {
            font-size: 21px;
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
            text-decoration: none;
            color: white;
            padding: 12px 14px;
            margin-bottom: 8px;
            border-radius: 6px;
            transition: 0.2s;
        }

        .menu a:hover,
        .menu .active {
            background: rgba(255,255,255,0.20);
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
            text-decoration: none;
            color: #b91c1c;
            font-weight: bold;
        }

        .content {
            padding: 30px;
            min-width: 0;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 6px;
            font-size: 32px;
        }

        .page-title p {
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

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 22px;
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

        .stat-note {
            margin-top: 8px;
            color: #9ca3af;
            font-size: 11px;
            line-height: 1.5;
        }

        .quick-actions {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
        }

        .quick-actions h2 {
            margin-bottom: 20px;
            color: #0f5f87;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(5,1fr);
            gap: 16px;
        }

        .action-card {
            display: block;
            text-decoration: none;
            background: #eef7fb;
            padding: 20px;
            border-radius: 8px;
            color: #1f2937;
            border: 1px solid transparent;
            transition: 0.2s;
        }

        .action-card:hover {
            transform: translateY(-2px);
            background: #dceff7;
            border-color: #b8d9e8;
        }

        .action-card h3 {
            color: #0f5f87;
            margin-bottom: 7px;
            font-size: 16px;
        }

        .action-card p {
            font-size: 13px;
            color: #6b7280;
            line-height: 1.5;
        }

        .section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .section h2 {
            color: #0f5f87;
            margin-bottom: 18px;
        }

        .workflow {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 18px;
            border-radius: 8px;
            color: #4b5563;
            font-size: 13px;
            line-height: 1.7;
        }

        @media(max-width: 1250px) {

            .action-grid {
                grid-template-columns: repeat(3,1fr);
            }
        }

        @media(max-width: 950px) {

            .stats {
                grid-template-columns: repeat(2,1fr);
            }

            .action-grid {
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
            .action-grid {
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
            PATIENT
        </div>

        <nav class="menu">

            <a class="active"
               href="<%= request.getContextPath() %>/patient/Dashboard">

                Dashboard

            </a>

            <a href="<%= request.getContextPath() %>/BookAppointment">

                Book Appointment

            </a>

            <a href="<%= request.getContextPath() %>/patient/MyAppointments">

                My Appointments

            </a>

            <a href="<%= request.getContextPath() %>/patient/TreatmentHistory">

                Treatment History

            </a>

            <a href="<%= request.getContextPath() %>/patient/MyBills">

                My Bills

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

            <div class="page-title">

                <h1>
                    Patient Dashboard
                </h1>

                <p>
                    Book appointments, track treatment progress
                    and review your billing information.
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
                        Upcoming Appointments
                    </h3>

                    <p>
                        <%= upcomingAppointments %>
                    </p>

                    <div class="stat-note">
                        Your confirmed upcoming appointments.
                    </div>

                </div>

                <div class="stat-card">

                    <h3>
                        Pending Requests
                    </h3>

                    <p>
                        <%= pendingRequests %>
                    </p>

                    <div class="stat-note">
                        Appointment requests awaiting confirmation.
                    </div>

                </div>

                <div class="stat-card">

                    <h3>
                        Completed Treatments
                    </h3>

                    <p>
                        <%= completedTreatments %>
                    </p>

                    <div class="stat-note">
                        Your completed dental treatment records.
                    </div>

                </div>

                <div class="stat-card">

                    <h3>
                        Unpaid Bills
                    </h3>

                    <p>
                        <%= unpaidBills %>
                    </p>

                    <div class="stat-note">
                        Bills currently waiting for payment.
                    </div>

                </div>

            </div>

            <section class="quick-actions">

                <h2>
                    Quick Actions
                </h2>

                <div class="action-grid">

                    <a href="<%= request.getContextPath() %>/BookAppointment"
                       class="action-card">

                        <h3>
                            Book Appointment
                        </h3>

                        <p>
                            Select a dental service, dentist,
                            appointment date and time.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/patient/MyAppointments"
                       class="action-card">

                        <h3>
                            My Appointments
                        </h3>

                        <p>
                            View pending, confirmed,
                            completed and cancelled appointments.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/patient/TreatmentHistory"
                       class="action-card">

                        <h3>
                            Treatment History
                        </h3>

                        <p>
                            Review diagnosis, completed treatments,
                            actual treatment items and dentist notes.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/patient/MyBills"
                       class="action-card">

                        <h3>
                            My Bills
                        </h3>

                        <p>
                            Review generated bills,
                            payment status and secure digital receipts.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/Help"
                       class="action-card">

                        <h3>
                            Help
                        </h3>

                        <p>
                            View guidance for appointments,
                            treatments, billing and system usage.
                        </p>

                    </a>

                </div>

            </section>

            <section class="section">

                <h2>
                    Patient Workflow
                </h2>

                <div class="workflow">

                    Select Book Appointment →
                    choose requested dental service →
                    select dentist, date and time →
                    submit appointment request →
                    check appointment status in My Appointments →
                    attend the confirmed appointment →
                    review completed treatment in Treatment History →
                    bill is generated →
                    review the bill in My Bills →
                    cashier processes the payment →
                    open the secure digital QR receipt.

                </div>

            </section>

        </div>

    </main>

</div>

</body>

</html>