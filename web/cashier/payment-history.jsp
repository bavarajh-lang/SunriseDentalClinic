<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Payment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("payments") == null
            && request.getAttribute("paymentHistoryError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/cashier/PaymentHistory"
        );

        return;
    }

    List<Payment> payments =
            (List<Payment>) request.getAttribute("payments");

    String paymentHistoryError =
            (String) request.getAttribute("paymentHistoryError");

    DecimalFormat moneyFormat =
            new DecimalFormat("#,##0.00");

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat("dd MMM yyyy - hh:mm a");

    int totalPayments = 0;

    BigDecimal totalCollected =
            BigDecimal.ZERO;

    if (payments != null) {

        totalPayments =
                payments.size();

        for (Payment payment : payments) {

            if (payment != null
                    && payment.getAmount() != null) {

                totalCollected =
                        totalCollected.add(
                                payment.getAmount()
                        );
            }
        }
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Payment History | Sunrise Dental Clinic
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

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 22px;
            line-height: 1.5;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .summary-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .summary-card h3 {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .summary-card strong {
            color: #0f5f87;
            font-size: 27px;
        }

        .history-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .history-header h2 {
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
            min-width: 1250px;
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
            font-weight: bold;
            color: #1f2937;
            white-space: nowrap;
        }

        .patient-name {
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 3px;
        }

        .patient-no {
            color: #6b7280;
            font-size: 11px;
        }

        .amount {
            font-weight: bold;
            color: #0f5f87;
            white-space: nowrap;
        }

        .method {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 15px;
            background: #eef7fb;
            color: #0f5f87;
            font-size: 10px;
            font-weight: bold;
            white-space: nowrap;
        }

        .reference {
            color: #4b5563;
            word-break: break-word;
            max-width: 150px;
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

        .btn-receipt {
            display: inline-block;
            background: #0f5f87;
            color: white;
            text-decoration: none;
            padding: 8px 11px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: bold;
            white-space: nowrap;
            transition: 0.2s;
        }

        .btn-receipt:hover {
            background: #0b4f71;
        }

        .empty-state {
            background: white;
            border-radius: 12px;
            padding: 55px 25px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .empty-state h2 {
            color: #0f5f87;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6b7280;
            line-height: 1.6;
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

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .history-header {
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

        <nav class="menu">

            <a href="<%= request.getContextPath() %>/cashier/Dashboard">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PendingBills">
                Pending Bills
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PaymentHistory"
               class="active">
                Payment History
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PaymentHistory">
                Receipts
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
                    Payment History
                </h1>

                <p>
                    View completed patient payments and open
                    previously generated payment receipts.
                </p>

            </div>

            <%
                if (paymentHistoryError != null) {
            %>

            <div class="error-message">

                <strong>
                    Error!
                </strong>

                <br>

                <%= paymentHistoryError %>

            </div>

            <%
                }
            %>

            <div class="summary-grid">

                <div class="summary-card">

                    <h3>
                        Successful Payments
                    </h3>

                    <strong>
                        <%= totalPayments %>
                    </strong>

                </div>

                <div class="summary-card">

                    <h3>
                        Total Collected
                    </h3>

                    <strong>
                        Rs. <%= moneyFormat.format(totalCollected) %>
                    </strong>

                </div>

            </div>

            <%
                if (payments != null
                        && !payments.isEmpty()) {
            %>

            <div class="history-card">

                <div class="history-header">

                    <h2>
                        Completed Payments
                    </h2>

                    <span class="record-count">

                        <%= totalPayments %>
                        RECORDS

                    </span>

                </div>

                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>Payment ID</th>
                                <th>Bill</th>
                                <th>Appointment</th>
                                <th>Patient</th>
                                <th>Amount</th>
                                <th>Method</th>
                                <th>Reference</th>
                                <th>Cashier</th>
                                <th>Paid At</th>
                                <th>Status</th>
                                <th>Receipt</th>

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

                                <td class="amount">

                                    Rs.
                                    <%= moneyFormat.format(
                                            payment.getAmount()
                                    ) %>

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

                                <td>

                                    <a
                                        href="<%= request.getContextPath() %>/cashier/Receipt?billId=<%= payment.getBillId() %>"
                                        class="btn-receipt">

                                        View Receipt

                                    </a>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>

            </div>

            <%
                } else {
            %>

            <div class="empty-state">

                <h2>
                    No Payment History
                </h2>

                <p>
                    No successful patient payments have
                    been recorded yet.
                </p>

            </div>

            <%
                }
            %>

        </div>

    </main>

</div>

</body>

</html>