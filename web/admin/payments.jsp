<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Payment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    private String h(Object value) {

        if (value == null) {
            return "";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String displayValue(Object value) {

        if (value == null) {
            return "-";
        }

        String text =
                String.valueOf(value).trim();

        return text.isEmpty()
                ? "-"
                : h(text);
    }
%>

<%
    if (request.getAttribute("payments") == null
            && request.getAttribute("paymentError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/Payments"
        );

        return;
    }

    List<Payment> payments =
            (List<Payment>) request.getAttribute(
                    "payments"
            );

    Integer successfulPaymentsValue =
            (Integer) request.getAttribute(
                    "successfulPayments"
            );

    Integer todayPaymentsValue =
            (Integer) request.getAttribute(
                    "todayPayments"
            );

    BigDecimal totalRevenueValue =
            (BigDecimal) request.getAttribute(
                    "totalRevenue"
            );

    BigDecimal todayRevenueValue =
            (BigDecimal) request.getAttribute(
                    "todayRevenue"
            );

    String search =
            (String) request.getAttribute(
                    "search"
            );

    String selectedMethod =
            (String) request.getAttribute(
                    "selectedMethod"
            );

    String selectedDate =
            (String) request.getAttribute(
                    "selectedDate"
            );

    String paymentError =
            (String) request.getAttribute(
                    "paymentError"
            );

    int successfulPayments =
            successfulPaymentsValue != null
            ? successfulPaymentsValue
            : 0;

    int todayPayments =
            todayPaymentsValue != null
            ? todayPaymentsValue
            : 0;

    BigDecimal totalRevenue =
            totalRevenueValue != null
            ? totalRevenueValue
            : BigDecimal.ZERO;

    BigDecimal todayRevenue =
            todayRevenueValue != null
            ? todayRevenueValue
            : BigDecimal.ZERO;

    if (search == null) {
        search = "";
    }

    if (selectedMethod == null) {
        selectedMethod = "";
    }

    if (selectedDate == null) {
        selectedDate = "";
    }

    int displayedPayments =
            payments != null
            ? payments.size()
            : 0;

    DecimalFormat moneyFormat =
            new DecimalFormat(
                    "#,##0.00"
            );

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat(
                    "dd MMM yyyy - hh:mm a"
            );
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Payments | Sunrise Dental Clinic
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
            font-size: 32px;
            margin-bottom: 7px;
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
            display: block;
            font-size: 28px;
        }

        .money-value {
            font-size: 22px !important;
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
            margin-bottom: 16px;
            font-size: 19px;
        }

        .filters {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto auto;
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

        .field-group input,
        .field-group select {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            padding: 11px 12px;
            font-size: 13px;
            outline: none;
            background: white;
        }

        .field-group input:focus,
        .field-group select:focus {
            border-color: #0f5f87;
            box-shadow: 0 0 0 3px rgba(15,95,135,0.08);
        }

        .filter-button,
        .clear-button {
            padding: 11px 16px;
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

        .payments-card {
            background: white;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .table-header h2 {
            color: #0f5f87;
            font-size: 20px;
        }

        .record-count {
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
            min-width: 1350px;
            border-collapse: collapse;
        }

        th {
            background: #eef7fb;
            color: #374151;
            padding: 13px 12px;
            text-align: left;
            border-bottom: 1px solid #dbe4ea;
            font-size: 11px;
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

        .primary-text {
            font-weight: bold;
            margin-bottom: 3px;
        }

        .sub-text {
            color: #6b7280;
            font-size: 10px;
            line-height: 1.5;
        }

        .amount {
            font-weight: bold;
            color: #0f5f87;
            white-space: nowrap;
        }

        .method {
            display: inline-block;
            padding: 6px 9px;
            border-radius: 15px;
            background: #eef7fb;
            color: #0f5f87;
            font-size: 9px;
            font-weight: bold;
            white-space: nowrap;
        }

        .status {
            display: inline-block;
            padding: 6px 9px;
            border-radius: 15px;
            font-size: 9px;
            font-weight: bold;
            white-space: nowrap;
        }

        .status-success {
            background: #dcfce7;
            color: #166534;
        }

        .status-other {
            background: #fee2e2;
            color: #991b1b;
        }

        .date-time {
            white-space: nowrap;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
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

        @media(max-width: 1150px) {

            .stats {
                grid-template-columns: repeat(2,1fr);
            }

            .filters {
                grid-template-columns: repeat(2,1fr);
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
            .filters {
                grid-template-columns: 1fr;
            }

            .table-header {
                flex-direction: column;
                align-items: flex-start;
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

            <a class="active"
               href="<%= request.getContextPath() %>/admin/Payments">
                Payments
            </a>

            <a href="<%= request.getContextPath() %>/admin/reports.jsp">
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
                <%= h(session.getAttribute("fullName")) %>

            </div>

            <a href="<%= request.getContextPath() %>/LogoutServlet"
               class="logout">

                Logout

            </a>

        </div>

        <div class="content">

            <div class="page-header">

                <h1>
                    Payment Management
                </h1>

                <p>
                    Review clinic payment transactions,
                    patient billing activity and revenue.
                </p>

            </div>

            <%
                if (paymentError != null) {
            %>

            <div class="error-message">

                <strong>
                    Payment Error
                </strong>

                <br>

                <%= h(paymentError) %>

            </div>

            <%
                }
            %>

            <div class="stats">

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
                        Today's Payments
                    </h3>

                    <strong>
                        <%= todayPayments %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Total Revenue
                    </h3>

                    <strong class="money-value">
                        Rs. <%= moneyFormat.format(totalRevenue) %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Today's Revenue
                    </h3>

                    <strong class="money-value">
                        Rs. <%= moneyFormat.format(todayRevenue) %>
                    </strong>

                </div>

            </div>

            <div class="filter-card">

                <h2>
                    Search & Filter
                </h2>

                <form
                    action="<%= request.getContextPath() %>/admin/Payments"
                    method="get"
                    class="filters">

                    <div class="field-group">

                        <label>
                            Search Payment
                        </label>

                        <input
                            type="text"
                            name="search"
                            value="<%= h(search) %>"
                            placeholder="Bill, appointment, patient, reference or cashier">

                    </div>

                    <div class="field-group">

                        <label>
                            Payment Method
                        </label>

                        <select name="method">

                            <option value="">
                                All Methods
                            </option>

                            <option value="CASH"
                                    <%= "CASH".equals(selectedMethod)
                                    ? "selected"
                                    : "" %>>
                                Cash
                            </option>

                            <option value="CARD"
                                    <%= "CARD".equals(selectedMethod)
                                    ? "selected"
                                    : "" %>>
                                Card
                            </option>

                            <option value="BANK_TRANSFER"
                                    <%= "BANK_TRANSFER".equals(selectedMethod)
                                    ? "selected"
                                    : "" %>>
                                Bank Transfer
                            </option>

                        </select>

                    </div>

                    <div class="field-group">

                        <label>
                            Payment Date
                        </label>

                        <input
                            type="date"
                            name="paymentDate"
                            value="<%= h(selectedDate) %>">

                    </div>

                    <button
                        type="submit"
                        class="filter-button">

                        Apply Filter

                    </button>

                    <a href="<%= request.getContextPath() %>/admin/Payments"
                       class="clear-button">

                        Clear

                    </a>

                </form>

            </div>

            <div class="payments-card">

                <div class="table-header">

                    <h2>
                        Payment Transactions
                    </h2>

                    <span class="record-count">

                        <%= displayedPayments %>
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

                                <th>Payment</th>
                                <th>Bill</th>
                                <th>Appointment</th>
                                <th>Patient</th>
                                <th>Amount</th>
                                <th>Method</th>
                                <th>Reference</th>
                                <th>Status</th>
                                <th>Cashier</th>
                                <th>Paid At</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                for (Payment payment
                                        : payments) {

                                    String paymentStatus =
                                            payment.getStatus();

                                    String statusClass =
                                            "SUCCESS".equals(paymentStatus)
                                            ? "status-success"
                                            : "status-other";

                                    String paidAt =
                                            payment.getPaidAt() != null
                                            ? dateTimeFormat.format(
                                                    payment.getPaidAt()
                                            )
                                            : "-";

                                    BigDecimal paymentAmount =
                                            payment.getAmount() != null
                                            ? payment.getAmount()
                                            : BigDecimal.ZERO;
                            %>

                            <tr>

                                <td>

                                    <div class="payment-id">

                                        PAY-
                                        <%= String.format(
                                                "%06d",
                                                payment.getPaymentId()
                                        ) %>

                                    </div>

                                </td>

                                <td>

                                    <div class="primary-text">
                                        <%= displayValue(payment.getBillNo()) %>
                                    </div>

                                </td>

                                <td>

                                    <div class="primary-text">
                                        <%= displayValue(payment.getAppointmentNo()) %>
                                    </div>

                                </td>

                                <td>

                                    <div class="primary-text">
                                        <%= displayValue(payment.getPatientName()) %>
                                    </div>

                                    <div class="sub-text">
                                        <%= displayValue(payment.getPatientNo()) %>
                                    </div>

                                </td>

                                <td>

                                    <span class="amount">

                                        Rs.
                                        <%= moneyFormat.format(paymentAmount) %>

                                    </span>

                                </td>

                                <td>

                                    <span class="method">
                                        <%= displayValue(payment.getMethod()) %>
                                    </span>

                                </td>

                                <td>
                                    <%= displayValue(payment.getReference()) %>
                                </td>

                                <td>

                                    <span class="status <%= statusClass %>">

                                        <%= displayValue(paymentStatus) %>

                                    </span>

                                </td>

                                <td>

                                    <div class="primary-text">
                                        <%= displayValue(payment.getCashierName()) %>
                                    </div>

                                </td>

                                <td class="date-time">
                                    <%= paidAt %>
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
                        No Payments Found
                    </h3>

                    <p>
                        No payment transactions matched the
                        selected search, payment method or date.
                    </p>

                </div>

                <%
                    }
                %>

            </div>

        </div>

    </main>

</div>

</body>

</html>