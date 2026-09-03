<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="model.PatientBill"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("bills") == null
            && request.getAttribute("billError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/patient/MyBills"
        );

        return;
    }

    List<PatientBill> bills =
            (List<PatientBill>) request.getAttribute(
                    "bills"
            );

    Integer totalBillsValue =
            (Integer) request.getAttribute(
                    "totalBills"
            );

    Integer unpaidBillsValue =
            (Integer) request.getAttribute(
                    "unpaidBills"
            );

    Integer paidBillsValue =
            (Integer) request.getAttribute(
                    "paidBills"
            );

    String billError =
            (String) request.getAttribute(
                    "billError"
            );

    int totalBills =
            totalBillsValue != null
            ? totalBillsValue
            : 0;

    int unpaidBills =
            unpaidBillsValue != null
            ? unpaidBillsValue
            : 0;

    int paidBills =
            paidBillsValue != null
            ? paidBillsValue
            : 0;

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
        My Bills | Sunrise Dental Clinic
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

        .stats {
            display: grid;
            grid-template-columns: repeat(3,1fr);
            gap: 18px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 22px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .stat-card h3 {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .stat-card p {
            color: #0f5f87;
            font-size: 29px;
            font-weight: bold;
        }

        .stat-note {
            color: #9ca3af;
            font-size: 11px;
            margin-top: 8px;
            line-height: 1.5;
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

        .bill-list {
            display: grid;
            gap: 20px;
        }

        .bill-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .bill-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            padding-bottom: 18px;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
        }

        .bill-number {
            color: #0f5f87;
            font-size: 20px;
            margin-bottom: 5px;
        }

        .appointment-number {
            color: #6b7280;
            font-size: 13px;
        }

        .status {
            display: inline-block;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }

        .status-paid {
            background: #dcfce7;
            color: #166534;
        }

        .status-unpaid {
            background: #fef3c7;
            color: #92400e;
        }

        .status-partial {
            background: #e0e7ff;
            color: #3730a3;
        }

        .status-default {
            background: #e5e7eb;
            color: #374151;
        }

        .bill-details {
            display: grid;
            grid-template-columns: repeat(3,1fr);
            gap: 16px;
        }

        .detail-box {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
        }

        .detail-label {
            display: block;
            color: #6b7280;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 7px;
        }

        .detail-value {
            color: #1f2937;
            font-size: 14px;
            line-height: 1.5;
        }

        .amount {
            color: #0f5f87;
            font-weight: bold;
        }

        .total-box {
            margin-top: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 18px;
            border-radius: 8px;
        }

        .total-label {
            color: #4b5563;
            font-weight: bold;
        }

        .total-amount {
            color: #0f5f87;
            font-size: 24px;
            font-weight: bold;
        }

        .payment-message {
            margin-top: 18px;
            padding: 15px;
            border-radius: 8px;
            font-size: 13px;
            line-height: 1.6;
        }

        .payment-message.unpaid {
            background: #fff7ed;
            border: 1px solid #fed7aa;
            color: #9a3412;
        }

        .payment-message.paid {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: #166534;
        }

        .actions {
            margin-top: 18px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .receipt-btn {
            display: inline-block;
            text-decoration: none;
            background: #0f6f9c;
            color: white;
            padding: 11px 17px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: bold;
        }

        .receipt-btn:hover {
            background: #0c5d82;
        }

        .appointments-btn {
            display: inline-block;
            text-decoration: none;
            background: #eef7fb;
            color: #0f5f87;
            padding: 11px 17px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: bold;
            border: 1px solid #bfdae6;
        }

        .appointments-btn:hover {
            background: #dceff7;
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
            margin-bottom: 22px;
        }

        .empty-state a {
            display: inline-block;
            text-decoration: none;
            background: #0f6f9c;
            color: white;
            padding: 11px 18px;
            border-radius: 7px;
            font-weight: bold;
        }

        @media(max-width: 950px) {

            .bill-details {
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
            .bill-details {
                grid-template-columns: 1fr;
            }

            .bill-header,
            .total-box {
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
            PATIENT
        </div>

        <nav class="menu">

            <a href="<%= request.getContextPath() %>/patient/Dashboard">
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

            <a href="<%= request.getContextPath() %>/patient/MyBills"
               class="active">
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

            <div class="page-header">

                <h1>
                    My Bills
                </h1>

                <p>
                    Review your dental bills, payment status
                    and secure digital receipts.
                </p>

            </div>

            <div class="stats">

                <div class="stat-card">

                    <h3>
                        Total Bills
                    </h3>

                    <p>
                        <%= totalBills %>
                    </p>

                    <div class="stat-note">
                        All bills generated for your treatments.
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
                        Bills still waiting for cashier payment.
                    </div>

                </div>

                <div class="stat-card">

                    <h3>
                        Paid Bills
                    </h3>

                    <p>
                        <%= paidBills %>
                    </p>

                    <div class="stat-note">
                        Successfully completed bill payments.
                    </div>

                </div>

            </div>

            <%
                if (billError != null) {
            %>

            <div class="error-message">

                <strong>
                    Unable to Load Bills
                </strong>

                <br>

                <%= billError %>

            </div>

            <%
                }
            %>

            <%
                if (bills != null
                        && !bills.isEmpty()) {
            %>

            <div class="bill-list">

                <%
                    for (PatientBill bill : bills) {

                        String paymentStatus =
                                bill.getPaymentStatus();

                        String statusClass =
                                "status-default";

                        if ("PAID".equals(paymentStatus)) {

                            statusClass =
                                    "status-paid";

                        } else if ("UNPAID".equals(paymentStatus)) {

                            statusClass =
                                    "status-unpaid";

                        } else if ("PARTIALLY_PAID".equals(paymentStatus)) {

                            statusClass =
                                    "status-partial";
                        }

                        BigDecimal subtotal =
                                bill.getSubtotal() != null
                                ? bill.getSubtotal()
                                : BigDecimal.ZERO;

                        BigDecimal discount =
                                bill.getDiscount() != null
                                ? bill.getDiscount()
                                : BigDecimal.ZERO;

                        BigDecimal totalAmount =
                                bill.getTotalAmount() != null
                                ? bill.getTotalAmount()
                                : BigDecimal.ZERO;
                %>

                <div class="bill-card">

                    <div class="bill-header">

                        <div>

                            <h2 class="bill-number">

                                <%= bill.getBillNo() != null
                                        ? bill.getBillNo()
                                        : "-" %>

                            </h2>

                            <div class="appointment-number">

                                Appointment:
                                <strong>

                                    <%= bill.getAppointmentNo() != null
                                            ? bill.getAppointmentNo()
                                            : "-" %>

                                </strong>

                            </div>

                        </div>

                        <span class="status <%= statusClass %>">

                            <%= paymentStatus != null
                                    ? paymentStatus.replace("_", " ")
                                    : "UNKNOWN" %>

                        </span>

                    </div>

                    <div class="bill-details">

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient Number
                            </span>

                            <span class="detail-value">

                                <%= bill.getPatientNo() != null
                                        ? bill.getPatientNo()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient Name
                            </span>

                            <span class="detail-value">

                                <%= bill.getPatientName() != null
                                        ? bill.getPatientName()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Number
                            </span>

                            <span class="detail-value">

                                <%= bill.getAppointmentNo() != null
                                        ? bill.getAppointmentNo()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Subtotal
                            </span>

                            <span class="detail-value amount">

                                Rs.
                                <%= moneyFormat.format(
                                        subtotal
                                ) %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Discount
                            </span>

                            <span class="detail-value">

                                Rs.
                                <%= moneyFormat.format(
                                        discount
                                ) %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Payment Status
                            </span>

                            <span class="detail-value">

                                <%= paymentStatus != null
                                        ? paymentStatus.replace("_", " ")
                                        : "-" %>

                            </span>

                        </div>

                    </div>

                    <div class="total-box">

                        <div class="total-label">
                            Total Amount
                        </div>

                        <div class="total-amount">

                            Rs.
                            <%= moneyFormat.format(
                                    totalAmount
                            ) %>

                        </div>

                    </div>

                    <%
                        if ("PAID".equals(paymentStatus)) {
                    %>

                    <div class="payment-message paid">

                        Payment completed successfully.
                        Your secure digital receipt is available below.

                    </div>

                    <div class="actions">

                        <%
                            if (bill.getQrToken() != null
                                    && !bill.getQrToken()
                                    .trim()
                                    .isEmpty()) {
                        %>

                        <a
                            href="<%= request.getContextPath() %>/DigitalReceipt?token=<%= bill.getQrToken() %>"
                            class="receipt-btn"
                            target="_blank">

                            View Digital Receipt

                        </a>

                        <%
                            }
                        %>

                        <a
                            href="<%= request.getContextPath() %>/patient/MyAppointments"
                            class="appointments-btn">

                            View Appointment

                        </a>

                        <a
                            href="<%= request.getContextPath() %>/patient/TreatmentHistory"
                            class="appointments-btn">

                            View Treatment History

                        </a>

                    </div>

                    <%
                        } else {
                    %>

                    <div class="payment-message unpaid">

                        This bill has not been fully paid yet.
                        Please complete the payment through
                        the clinic cashier to receive your
                        secure digital receipt.

                    </div>

                    <div class="actions">

                        <a
                            href="<%= request.getContextPath() %>/patient/MyAppointments"
                            class="appointments-btn">

                            View Appointment

                        </a>

                        <a
                            href="<%= request.getContextPath() %>/patient/TreatmentHistory"
                            class="appointments-btn">

                            View Treatment History

                        </a>

                    </div>

                    <%
                        }
                    %>

                </div>

                <%
                    }
                %>

            </div>

            <%
                } else {
            %>

            <div class="empty-state">

                <h2>
                    No Bills Available
                </h2>

                <p>
                    You currently have no generated dental bills.
                    Bills will appear here after your treatment
                    has been completed and billing information
                    has been generated.
                </p>

                <a href="<%= request.getContextPath() %>/patient/MyAppointments">

                    View My Appointments

                </a>

            </div>

            <%
                }
            %>

        </div>

    </main>

</div>

</body>

</html>