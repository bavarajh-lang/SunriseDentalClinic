<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="model.Payment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("todayPayments") == null
            && request.getAttribute("dailySummaryError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/cashier/DailySummary"
        );

        return;
    }

    Integer todayPayments =
            (Integer) request.getAttribute("todayPayments");

    BigDecimal todayRevenue =
            (BigDecimal) request.getAttribute("todayRevenue");

    BigDecimal cashTotal =
            (BigDecimal) request.getAttribute("cashTotal");

    BigDecimal cardTotal =
            (BigDecimal) request.getAttribute("cardTotal");

    BigDecimal bankTransferTotal =
            (BigDecimal) request.getAttribute("bankTransferTotal");

    List<Payment> payments =
            (List<Payment>) request.getAttribute("payments");

    String dailySummaryError =
            (String) request.getAttribute("dailySummaryError");

    if (todayPayments == null) {
        todayPayments = 0;
    }

    if (todayRevenue == null) {
        todayRevenue = BigDecimal.ZERO;
    }

    if (cashTotal == null) {
        cashTotal = BigDecimal.ZERO;
    }

    if (cardTotal == null) {
        cardTotal = BigDecimal.ZERO;
    }

    if (bankTransferTotal == null) {
        bankTransferTotal = BigDecimal.ZERO;
    }

    DecimalFormat moneyFormat =
            new DecimalFormat("#,##0.00");

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat("dd MMM yyyy - hh:mm a");

    SimpleDateFormat reportDateFormat =
            new SimpleDateFormat("dd MMMM yyyy");

    String reportDate =
            reportDateFormat.format(
                    new Date()
            );
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Daily Summary | Sunrise Dental Clinic
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
            margin-bottom: 7px;
            font-size: 32px;
        }

        .page-header p {
            color: #6b7280;
            line-height: 1.6;
        }

        .header-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            border: none;
            border-radius: 7px;
            padding: 11px 16px;
            font-size: 13px;
            font-weight: bold;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #0f5f87;
            color: white;
        }

        .btn-primary:hover {
            background: #0b4f71;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
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

        .report-info {
            background: white;
            border-radius: 10px;
            padding: 18px 22px;
            margin-bottom: 22px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .report-info h2 {
            color: #0f5f87;
            font-size: 18px;
            margin-bottom: 5px;
        }

        .report-info p {
            color: #6b7280;
            font-size: 13px;
        }

        .report-date {
            background: #eef7fb;
            color: #0f5f87;
            padding: 8px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(5,1fr);
            gap: 16px;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .card h3 {
            color: #6b7280;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .card strong {
            display: block;
            color: #0f5f87;
            font-size: 23px;
            word-break: break-word;
        }

        .card p {
            color: #9ca3af;
            font-size: 10px;
            margin-top: 8px;
            line-height: 1.5;
        }

        .summary-section {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .section-header h2 {
            color: #0f5f87;
            font-size: 20px;
        }

        .record-count {
            display: inline-block;
            background: #eef7fb;
            color: #0f5f87;
            padding: 6px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1100px;
            border-collapse: collapse;
        }

        th {
            background: #eef7fb;
            color: #374151;
            text-align: left;
            padding: 13px 12px;
            font-size: 11px;
            border-bottom: 1px solid #dbe4ea;
            white-space: nowrap;
        }

        td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 12px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: #fafcfd;
        }

        .payment-id {
            color: #0f5f87;
            font-weight: bold;
            white-space: nowrap;
        }

        .bill-no {
            color: #1f2937;
            font-weight: bold;
            white-space: nowrap;
        }

        .patient-name {
            color: #1f2937;
            font-weight: bold;
            margin-bottom: 3px;
        }

        .patient-no {
            color: #6b7280;
            font-size: 10px;
        }

        .amount {
            color: #0f5f87;
            font-weight: bold;
            white-space: nowrap;
        }

        .method {
            display: inline-block;
            background: #eef7fb;
            color: #0f5f87;
            padding: 5px 9px;
            border-radius: 15px;
            font-size: 10px;
            font-weight: bold;
            white-space: nowrap;
        }

        .status {
            display: inline-block;
            background: #dcfce7;
            color: #166534;
            padding: 5px 9px;
            border-radius: 15px;
            font-size: 10px;
            font-weight: bold;
        }

        .paid-time {
            color: #4b5563;
            white-space: nowrap;
        }

        .reference {
            color: #4b5563;
            word-break: break-word;
        }

        .empty-state {
            padding: 45px 20px;
            text-align: center;
        }

        .empty-state h3 {
            color: #0f5f87;
            margin-bottom: 9px;
        }

        .empty-state p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.6;
        }

        .report-footer {
            margin-top: 25px;
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 16px 18px;
            border-radius: 8px;
        }

        .report-footer h3 {
            color: #0f5f87;
            font-size: 14px;
            margin-bottom: 6px;
        }

        .report-footer p {
            color: #4b5563;
            font-size: 12px;
            line-height: 1.6;
        }

        @media(max-width: 1250px) {

            .stats {
                grid-template-columns: repeat(3,1fr);
            }
        }

        @media(max-width: 950px) {

            .stats {
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

            .page-header,
            .report-info,
            .section-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .stats {
                grid-template-columns: 1fr;
            }
        }

        @media print {

            body {
                background: white;
            }

            .sidebar,
            .topbar,
            .header-actions {
                display: none !important;
            }

            .layout {
                display: block;
            }

            .main {
                width: 100%;
            }

            .content {
                padding: 0;
            }

            .page-header {
                margin-bottom: 20px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .report-info,
            .card,
            .summary-section {
                box-shadow: none;
                border: 1px solid #d1d5db;
            }

            .stats {
                grid-template-columns: repeat(3,1fr);
                gap: 10px;
            }

            .card {
                padding: 12px;
            }

            .card strong {
                font-size: 17px;
            }

            .table-wrapper {
                overflow: visible;
            }

            table {
                min-width: 0;
                width: 100%;
            }

            th,
            td {
                font-size: 9px;
                padding: 7px 5px;
            }

            .report-footer {
                background: white;
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

        <nav class="menu">

            <a href="<%= request.getContextPath() %>/cashier/Dashboard">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PendingBills">
                Pending Bills
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PaymentHistory">
                Payment History
            </a>

            <a href="<%= request.getContextPath() %>/cashier/DailySummary"
               class="active">
                Daily Summary
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
                        Daily Payment Summary
                    </h1>

                    <p>
                        Review today's successful patient payments,
                        collection totals and payment methods.
                    </p>

                </div>

                <div class="header-actions">

                    <a href="<%= request.getContextPath() %>/cashier/Dashboard"
                       class="btn btn-secondary">

                        Back to Dashboard

                    </a>

                    <button type="button"
                            class="btn btn-primary"
                            onclick="window.print()">

                        Print Summary

                    </button>

                </div>

            </div>

            <%
                if (dailySummaryError != null) {
            %>

            <div class="error-message">

                <strong>
                    Summary Error
                </strong>

                <br>

                <%= dailySummaryError %>

            </div>

            <%
                }
            %>

            <div class="report-info">

                <div>

                    <h2>
                        Sunrise Dental Clinic
                    </h2>

                    <p>
                        Cashier Daily Collection Report
                    </p>

                </div>

                <div class="report-date">
                    <%= reportDate %>
                </div>

            </div>

            <div class="stats">

                <div class="card">

                    <h3>
                        Today's Payments
                    </h3>

                    <strong>
                        <%= todayPayments %>
                    </strong>

                    <p>
                        Successful payment transactions.
                    </p>

                </div>

                <div class="card">

                    <h3>
                        Total Revenue
                    </h3>

                    <strong>
                        Rs. <%= moneyFormat.format(todayRevenue) %>
                    </strong>

                    <p>
                        Total collected today.
                    </p>

                </div>

                <div class="card">

                    <h3>
                        Cash
                    </h3>

                    <strong>
                        Rs. <%= moneyFormat.format(cashTotal) %>
                    </strong>

                    <p>
                        Cash payments collected.
                    </p>

                </div>

                <div class="card">

                    <h3>
                        Card
                    </h3>

                    <strong>
                        Rs. <%= moneyFormat.format(cardTotal) %>
                    </strong>

                    <p>
                        Card payments collected.
                    </p>

                </div>

                <div class="card">

                    <h3>
                        Bank Transfer
                    </h3>

                    <strong>
                        Rs. <%= moneyFormat.format(bankTransferTotal) %>
                    </strong>

                    <p>
                        Bank transfers collected.
                    </p>

                </div>

            </div>

            <div class="summary-section">

                <div class="section-header">

                    <h2>
                        Today's Payment Transactions
                    </h2>

                    <span class="record-count">

                        <%= todayPayments %>
                        RECORDS

                    </span>

                </div>

                <%
                    if (payments != null
                            && !payments.isEmpty()) {
                %>

                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>Payment ID</th>
                                <th>Bill No</th>
                                <th>Appointment</th>
                                <th>Patient</th>
                                <th>Method</th>
                                <th>Reference</th>
                                <th>Amount</th>
                                <th>Cashier</th>
                                <th>Paid At</th>
                                <th>Status</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                for (Payment payment : payments) {
                            %>

                            <tr>

                                <td>

                                    <span class="payment-id">

                                        PAY-<%= String.format(
                                                "%06d",
                                                payment.getPaymentId()
                                        ) %>

                                    </span>

                                </td>

                                <td>

                                    <span class="bill-no">
                                        <%= payment.getBillNo() %>
                                    </span>

                                </td>

                                <td>
                                    <%= payment.getAppointmentNo() %>
                                </td>

                                <td>

                                    <div class="patient-name">
                                        <%= payment.getPatientName() %>
                                    </div>

                                    <div class="patient-no">
                                        <%= payment.getPatientNo() %>
                                    </div>

                                </td>

                                <td>

                                    <span class="method">

                                        <%
                                            if ("BANK_TRANSFER".equals(
                                                    payment.getMethod())) {
                                        %>

                                        BANK TRANSFER

                                        <%
                                            } else if ("CARD".equals(
                                                    payment.getMethod())) {
                                        %>

                                        CARD

                                        <%
                                            } else {
                                        %>

                                        CASH

                                        <%
                                            }
                                        %>

                                    </span>

                                </td>

                                <td class="reference">

                                    <%
                                        if (payment.getReference() != null
                                                && !payment.getReference()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <%= payment.getReference() %>

                                    <%
                                        } else {
                                    %>

                                    N/A

                                    <%
                                        }
                                    %>

                                </td>

                                <td class="amount">

                                    Rs.
                                    <%= moneyFormat.format(
                                            payment.getAmount()
                                    ) %>

                                </td>

                                <td>
                                    <%= payment.getCashierName() %>
                                </td>

                                <td class="paid-time">

                                    <%
                                        if (payment.getPaidAt() != null) {
                                    %>

                                    <%= dateTimeFormat.format(
                                            payment.getPaidAt()
                                    ) %>

                                    <%
                                        } else {
                                    %>

                                    -

                                    <%
                                        }
                                    %>

                                </td>

                                <td>

                                    <span class="status">
                                        SUCCESS
                                    </span>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>

                <%
                    } else {
                %>

                <div class="empty-state">

                    <h3>
                        No Payments Today
                    </h3>

                    <p>
                        No successful patient payments have
                        been recorded for today.
                    </p>

                </div>

                <%
                    }
                %>

                <div class="report-footer">

                    <h3>
                        Daily Collection Summary
                    </h3>

                    <p>
                        Total successful payments:
                        <strong><%= todayPayments %></strong>
                        &nbsp; | &nbsp;
                        Total collection:
                        <strong>
                            Rs. <%= moneyFormat.format(todayRevenue) %>
                        </strong>
                    </p>

                </div>

            </div>

        </div>

    </main>

</div>

</body>

</html>