<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("totalAppointments") == null
            && request.getAttribute("reportError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/Reports"
        );

        return;
    }

    Integer totalPatientsValue =
            (Integer) request.getAttribute("totalPatients");

    Integer activeDentistsValue =
            (Integer) request.getAttribute("activeDentists");

    Integer totalAppointmentsValue =
            (Integer) request.getAttribute("totalAppointments");

    Integer pendingAppointmentsValue =
            (Integer) request.getAttribute("pendingAppointments");

    Integer confirmedAppointmentsValue =
            (Integer) request.getAttribute("confirmedAppointments");

    Integer rescheduleAppointmentsValue =
            (Integer) request.getAttribute("rescheduleAppointments");

    Integer completedAppointmentsValue =
            (Integer) request.getAttribute("completedAppointments");

    Integer cancelledAppointmentsValue =
            (Integer) request.getAttribute("cancelledAppointments");

    Integer successfulPaymentsValue =
            (Integer) request.getAttribute("successfulPayments");

    BigDecimal totalRevenueValue =
            (BigDecimal) request.getAttribute("totalRevenue");

    BigDecimal cashRevenueValue =
            (BigDecimal) request.getAttribute("cashRevenue");

    BigDecimal cardRevenueValue =
            (BigDecimal) request.getAttribute("cardRevenue");

    BigDecimal bankTransferRevenueValue =
            (BigDecimal) request.getAttribute("bankTransferRevenue");

    String selectedFromDate =
            (String) request.getAttribute("selectedFromDate");

    String selectedToDate =
            (String) request.getAttribute("selectedToDate");

    String reportError =
            (String) request.getAttribute("reportError");

    int totalPatients =
            totalPatientsValue != null
            ? totalPatientsValue
            : 0;

    int activeDentists =
            activeDentistsValue != null
            ? activeDentistsValue
            : 0;

    int totalAppointments =
            totalAppointmentsValue != null
            ? totalAppointmentsValue
            : 0;

    int pendingAppointments =
            pendingAppointmentsValue != null
            ? pendingAppointmentsValue
            : 0;

    int confirmedAppointments =
            confirmedAppointmentsValue != null
            ? confirmedAppointmentsValue
            : 0;

    int rescheduleAppointments =
            rescheduleAppointmentsValue != null
            ? rescheduleAppointmentsValue
            : 0;

    int completedAppointments =
            completedAppointmentsValue != null
            ? completedAppointmentsValue
            : 0;

    int cancelledAppointments =
            cancelledAppointmentsValue != null
            ? cancelledAppointmentsValue
            : 0;

    int successfulPayments =
            successfulPaymentsValue != null
            ? successfulPaymentsValue
            : 0;

    BigDecimal totalRevenue =
            totalRevenueValue != null
            ? totalRevenueValue
            : BigDecimal.ZERO;

    BigDecimal cashRevenue =
            cashRevenueValue != null
            ? cashRevenueValue
            : BigDecimal.ZERO;

    BigDecimal cardRevenue =
            cardRevenueValue != null
            ? cardRevenueValue
            : BigDecimal.ZERO;

    BigDecimal bankTransferRevenue =
            bankTransferRevenueValue != null
            ? bankTransferRevenueValue
            : BigDecimal.ZERO;

    if (selectedFromDate == null) {
        selectedFromDate = "";
    }

    if (selectedToDate == null) {
        selectedToDate = "";
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
        Reports | Sunrise Dental Clinic
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
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 25px;
        }

        .page-header h1 {
            color: #0f5f87;
            font-size: 32px;
            margin-bottom: 7px;
        }

        .page-header p {
            color: #6b7280;
            line-height: 1.6;
        }

        .print-button {
            background: #0f5f87;
            color: white;
            border: none;
            padding: 11px 16px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            white-space: nowrap;
        }

        .print-button:hover {
            background: #0b4f71;
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

        .filter-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
        }

        .filter-card h2 {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 16px;
        }

        .filter-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto auto;
            gap: 12px;
            align-items: end;
        }

        .field-group label {
            display: block;
            color: #4b5563;
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 6px;
        }

        .field-group input {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            padding: 11px 12px;
            font-size: 13px;
            outline: none;
        }

        .field-group input:focus {
            border-color: #0f5f87;
            box-shadow: 0 0 0 3px rgba(15,95,135,0.08);
        }

        .filter-button,
        .clear-button {
            padding: 11px 17px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            text-align: center;
            white-space: nowrap;
        }

        .filter-button {
            border: none;
            background: #0f5f87;
            color: white;
            cursor: pointer;
        }

        .filter-button:hover {
            background: #0b4f71;
        }

        .clear-button {
            background: #e5e7eb;
            color: #374151;
        }

        .clear-button:hover {
            background: #d1d5db;
        }

        .report-period {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 25px;
            color: #4b5563;
            font-size: 13px;
        }

        .report-period strong {
            color: #0f5f87;
        }

        .main-stats {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .stat-card h3 {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .stat-card strong {
            color: #0f5f87;
            font-size: 28px;
            display: block;
        }

        .money-value {
            font-size: 22px !important;
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
            font-size: 20px;
        }

        .section-subtitle {
            color: #6b7280;
            font-size: 12px;
            line-height: 1.6;
            margin-top: -10px;
            margin-bottom: 20px;
        }

        .appointment-grid {
            display: grid;
            grid-template-columns: repeat(6,1fr);
            gap: 15px;
        }

        .appointment-box {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 18px;
        }

        .appointment-box span {
            color: #6b7280;
            font-size: 10px;
            display: block;
            margin-bottom: 8px;
            text-transform: uppercase;
            font-weight: bold;
        }

        .appointment-box strong {
            color: #0f5f87;
            font-size: 24px;
        }

        .revenue-grid {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 15px;
        }

        .revenue-box {
            background: #eef7fb;
            border-radius: 8px;
            padding: 20px;
        }

        .revenue-box span {
            display: block;
            color: #6b7280;
            font-size: 10px;
            font-weight: bold;
            margin-bottom: 9px;
            text-transform: uppercase;
        }

        .revenue-box strong {
            display: block;
            color: #0f5f87;
            font-size: 20px;
        }

        .summary-table {
            width: 100%;
            border-collapse: collapse;
        }

        .summary-table th,
        .summary-table td {
            padding: 13px 14px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            font-size: 12px;
        }

        .summary-table th {
            background: #eef7fb;
            color: #374151;
        }

        .summary-table td:last-child {
            font-weight: bold;
            color: #0f5f87;
        }

        .report-note {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            padding: 16px;
            border-radius: 8px;
            color: #6b7280;
            font-size: 12px;
            line-height: 1.6;
            margin-top: 20px;
        }

        @media(max-width: 1250px) {

            .appointment-grid {
                grid-template-columns: repeat(3,1fr);
            }

            .revenue-grid,
            .main-stats {
                grid-template-columns: repeat(2,1fr);
            }
        }

        @media(max-width: 850px) {

            .filter-form {
                grid-template-columns: 1fr 1fr;
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

            .page-header {
                flex-direction: column;
            }

            .main-stats,
            .appointment-grid,
            .revenue-grid,
            .filter-form {
                grid-template-columns: 1fr;
            }
        }

        @media print {

            body {
                background: white;
            }

            .sidebar,
            .topbar,
            .filter-card,
            .print-button {
                display: none !important;
            }

            .layout {
                display: block;
            }

            .main {
                width: 100%;
            }

            .content {
                padding: 10px;
            }

            .stat-card,
            .section {
                box-shadow: none;
                border: 1px solid #d1d5db;
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

            <a href="<%= request.getContextPath() %>/admin/Dashboard">
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

            <a class="active"
               href="<%= request.getContextPath() %>/admin/Reports">
                Reports
            </a>

            <a href="<%= request.getContextPath() %>/admin/audit-logs.jsp">
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

                <div>

                    <h1>
                        Clinic Reports
                    </h1>

                    <p>
                        Review appointment activity,
                        patient statistics and clinic revenue.
                    </p>

                </div>

                <button
                    type="button"
                    class="print-button"
                    onclick="window.print()">

                    Print Report

                </button>

            </div>

            <%
                if (reportError != null) {
            %>

            <div class="error-message">

                <strong>
                    Report Error
                </strong>

                <br>

                <%= reportError %>

            </div>

            <%
                }
            %>

            <div class="filter-card">

                <h2>
                    Report Period
                </h2>

                <form
                    action="<%= request.getContextPath() %>/admin/Reports"
                    method="get"
                    class="filter-form">

                    <div class="field-group">

                        <label>
                            From Date
                        </label>

                        <input
                            type="date"
                            name="fromDate"
                            value="<%= selectedFromDate %>">

                    </div>

                    <div class="field-group">

                        <label>
                            To Date
                        </label>

                        <input
                            type="date"
                            name="toDate"
                            value="<%= selectedToDate %>">

                    </div>

                    <button
                        type="submit"
                        class="filter-button">

                        Generate Report

                    </button>

                    <a href="<%= request.getContextPath() %>/admin/Reports"
                       class="clear-button">

                        Clear Dates

                    </a>

                </form>

            </div>

            <div class="report-period">

                <strong>
                    Current Report:
                </strong>

                <%
                    if (!selectedFromDate.isEmpty()
                            || !selectedToDate.isEmpty()) {
                %>

                    <%= selectedFromDate.isEmpty()
                            ? "Beginning"
                            : selectedFromDate %>

                    &nbsp; to &nbsp;

                    <%= selectedToDate.isEmpty()
                            ? "Today / Latest"
                            : selectedToDate %>

                <%
                    } else {
                %>

                    All available clinic records

                <%
                    }
                %>

            </div>

            <div class="main-stats">

                <div class="stat-card">

                    <h3>
                        Registered Patients
                    </h3>

                    <strong>
                        <%= totalPatients %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Active Dentists
                    </h3>

                    <strong>
                        <%= activeDentists %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Successful Payments
                    </h3>

                    <strong>
                        <%= successfulPayments %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Total Revenue
                    </h3>

                    <strong class="money-value">

                        Rs.
                        <%= moneyFormat.format(totalRevenue) %>

                    </strong>

                </div>

            </div>

            <div class="section">

                <h2>
                    Appointment Summary
                </h2>

                <p class="section-subtitle">
                    Appointment statistics for the selected report period.
                </p>

                <div class="appointment-grid">

                    <div class="appointment-box">

                        <span>
                            Total
                        </span>

                        <strong>
                            <%= totalAppointments %>
                        </strong>

                    </div>

                    <div class="appointment-box">

                        <span>
                            Pending
                        </span>

                        <strong>
                            <%= pendingAppointments %>
                        </strong>

                    </div>

                    <div class="appointment-box">

                        <span>
                            Confirmed
                        </span>

                        <strong>
                            <%= confirmedAppointments %>
                        </strong>

                    </div>

                    <div class="appointment-box">

                        <span>
                            Reschedule Requested
                        </span>

                        <strong>
                            <%= rescheduleAppointments %>
                        </strong>

                    </div>

                    <div class="appointment-box">

                        <span>
                            Completed
                        </span>

                        <strong>
                            <%= completedAppointments %>
                        </strong>

                    </div>

                    <div class="appointment-box">

                        <span>
                            Cancelled
                        </span>

                        <strong>
                            <%= cancelledAppointments %>
                        </strong>

                    </div>

                </div>

            </div>

            <div class="section">

                <h2>
                    Revenue Summary
                </h2>

                <p class="section-subtitle">
                    Revenue calculated from successful payment transactions only.
                </p>

                <div class="revenue-grid">

                    <div class="revenue-box">

                        <span>
                            Total Revenue
                        </span>

                        <strong>

                            Rs.
                            <%= moneyFormat.format(totalRevenue) %>

                        </strong>

                    </div>

                    <div class="revenue-box">

                        <span>
                            Cash
                        </span>

                        <strong>

                            Rs.
                            <%= moneyFormat.format(cashRevenue) %>

                        </strong>

                    </div>

                    <div class="revenue-box">

                        <span>
                            Card
                        </span>

                        <strong>

                            Rs.
                            <%= moneyFormat.format(cardRevenue) %>

                        </strong>

                    </div>

                    <div class="revenue-box">

                        <span>
                            Bank Transfer
                        </span>

                        <strong>

                            Rs.
                            <%= moneyFormat.format(bankTransferRevenue) %>

                        </strong>

                    </div>

                </div>

            </div>

            <div class="section">

                <h2>
                    Report Overview
                </h2>

                <table class="summary-table">

                    <thead>

                        <tr>

                            <th>
                                Report Item
                            </th>

                            <th>
                                Result
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        <tr>
                            <td>Total Patients</td>
                            <td><%= totalPatients %></td>
                        </tr>

                        <tr>
                            <td>Active Dentists</td>
                            <td><%= activeDentists %></td>
                        </tr>

                        <tr>
                            <td>Total Appointments</td>
                            <td><%= totalAppointments %></td>
                        </tr>

                        <tr>
                            <td>Pending Appointments</td>
                            <td><%= pendingAppointments %></td>
                        </tr>

                        <tr>
                            <td>Confirmed Appointments</td>
                            <td><%= confirmedAppointments %></td>
                        </tr>

                        <tr>
                            <td>Reschedule Requests</td>
                            <td><%= rescheduleAppointments %></td>
                        </tr>

                        <tr>
                            <td>Completed Appointments</td>
                            <td><%= completedAppointments %></td>
                        </tr>

                        <tr>
                            <td>Cancelled Appointments</td>
                            <td><%= cancelledAppointments %></td>
                        </tr>

                        <tr>
                            <td>Successful Payments</td>
                            <td><%= successfulPayments %></td>
                        </tr>

                        <tr>
                            <td>Total Revenue</td>
                            <td>
                                Rs.
                                <%= moneyFormat.format(totalRevenue) %>
                            </td>
                        </tr>

                    </tbody>

                </table>

                <div class="report-note">

                    Appointment figures use the selected appointment-date
                    period. Revenue figures use successful payment
                    transactions within the selected payment-date period.

                </div>

            </div>

        </div>

    </main>

</div>

</body>

</html>