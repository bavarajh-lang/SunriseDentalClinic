<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("pendingBills") == null
            && request.getAttribute("dashboardError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/cashier/Dashboard"
        );

        return;
    }

    Integer pendingBills =
            (Integer) request.getAttribute("pendingBills");

    Integer todayPayments =
            (Integer) request.getAttribute("todayPayments");

    BigDecimal todayRevenue =
            (BigDecimal) request.getAttribute("todayRevenue");

    Integer paidBills =
            (Integer) request.getAttribute("paidBills");

    String dashboardError =
            (String) request.getAttribute("dashboardError");

    if (pendingBills == null) {
        pendingBills = 0;
    }

    if (todayPayments == null) {
        todayPayments = 0;
    }

    if (todayRevenue == null) {
        todayRevenue = BigDecimal.ZERO;
    }

    if (paidBills == null) {
        paidBills = 0;
    }

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
        Cashier Dashboard | Sunrise Dental Clinic
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
            grid-template-columns: repeat(5,1fr);
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
            line-height: 1.6;
        }

        @media(max-width: 1300px) {

            .actions {
                grid-template-columns: repeat(3,1fr);
            }
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
            CASHIER
        </div>

        <nav class="menu">

            <a class="active"
               href="<%= request.getContextPath() %>/cashier/Dashboard">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PendingBills">
                Pending Bills
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PaymentHistory">
                Payment History
            </a>

            <a href="<%= request.getContextPath() %>/cashier/DailySummary">
                Daily Summary
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
                    Cashier Dashboard
                </h1>

                <p>
                    Manage patient bills, payments,
                    receipts, daily collections and appointment searches.
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
                        Pending Bills
                    </h3>

                    <p>
                        <%= pendingBills %>
                    </p>

                    <div class="card-note">
                        Bills waiting for payment.
                    </div>

                </div>

                <div class="card">

                    <h3>
                        Today's Payments
                    </h3>

                    <p>
                        <%= todayPayments %>
                    </p>

                    <div class="card-note">
                        Successful payments processed today.
                    </div>

                </div>

                <div class="card">

                    <h3>
                        Today's Revenue
                    </h3>

                    <p>
                        Rs. <%= moneyFormat.format(todayRevenue) %>
                    </p>

                    <div class="card-note">
                        Total successful payment value today.
                    </div>

                </div>

                <div class="card">

                    <h3>
                        Paid Bills
                    </h3>

                    <p>
                        <%= paidBills %>
                    </p>

                    <div class="card-note">
                        Fully completed patient bills.
                    </div>

                </div>

            </div>

            <div class="section">

                <h2 class="section-title">
                    Quick Actions
                </h2>

                <div class="actions">

                    <a href="<%= request.getContextPath() %>/cashier/PendingBills"
                       class="action">

                        <h3>
                            Pending Bills
                        </h3>

                        <p>
                            View patient bills waiting for
                            cashier payment.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/cashier/PendingBills"
                       class="action">

                        <h3>
                            Process Payment
                        </h3>

                        <p>
                            Select an unpaid bill and process
                            cash, card or bank transfer payment.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/cashier/PaymentHistory"
                       class="action">

                        <h3>
                            Payment History & Receipts
                        </h3>

                        <p>
                            View successful payments and open
                            printable secure QR receipts.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/cashier/DailySummary"
                       class="action">

                        <h3>
                            Daily Summary
                        </h3>

                        <p>
                            Review today's payment activity,
                            payment methods and total collection.
                        </p>

                    </a>

                    <a href="<%= request.getContextPath() %>/AppointmentSearch"
                       class="action">

                        <h3>
                            Appointment Search
                        </h3>

                        <p>
                            Search by appointment number and view
                            patient, dentist, service and schedule details.
                        </p>

                    </a>

                </div>

                <div class="workflow-box">

                    <h3>
                        Cashier Workflow
                    </h3>

                    <p>
                        Search an appointment when required →
                        review pending bills →
                        select a bill →
                        process payment →
                        open payment history →
                        view or print receipt →
                        provide secure QR digital receipt →
                        review Daily Summary.
                    </p>

                </div>

            </div>

        </div>

    </main>

</div>

</body>

</html>