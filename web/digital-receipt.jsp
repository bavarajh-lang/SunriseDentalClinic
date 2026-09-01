<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="model.Bill"%>
<%@page import="model.BillItem"%>
<%@page import="model.Payment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Bill bill =
            (Bill) request.getAttribute("bill");

    Payment payment =
            (Payment) request.getAttribute("payment");

    String paymentSuccess =
            (String) session.getAttribute("paymentSuccess");

    DecimalFormat moneyFormat =
            new DecimalFormat("#,##0.00");

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat("dd MMM yyyy - hh:mm a");

    String encodedQrToken = "";

    if (bill != null
            && bill.getQrToken() != null) {

        encodedQrToken =
                URLEncoder.encode(
                        bill.getQrToken(),
                        "UTF-8"
                );
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Payment Receipt | Sunrise Dental Clinic
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
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 24px;
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

        .success-message {
            background: #ecfdf3;
            border: 1px solid #86efac;
            color: #166534;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .receipt {
            max-width: 1050px;
            margin: auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .receipt-top {
            background: #eef7fb;
            padding: 26px 28px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            border-bottom: 1px solid #d8e8ef;
        }

        .clinic-info h2 {
            color: #0f5f87;
            font-size: 24px;
            margin-bottom: 6px;
        }

        .clinic-info p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        .receipt-info {
            text-align: right;
        }

        .receipt-info h3 {
            color: #0f5f87;
            font-size: 21px;
            margin-bottom: 7px;
        }

        .receipt-number {
            color: #1f2937;
            font-weight: bold;
            margin-bottom: 9px;
            font-size: 14px;
        }

        .paid-status {
            display: inline-block;
            background: #dcfce7;
            color: #166534;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .receipt-body {
            padding: 28px;
        }

        .payment-success-box {
            background: #ecfdf3;
            border-left: 4px solid #16a34a;
            padding: 16px 18px;
            border-radius: 8px;
            margin-bottom: 24px;
        }

        .payment-success-box h3 {
            color: #166534;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .payment-success-box p {
            color: #166534;
            font-size: 13px;
            line-height: 1.5;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .info-card {
            border: 1px solid #e5e7eb;
            border-radius: 9px;
            padding: 18px;
            background: #fafcfd;
        }

        .info-card h3 {
            color: #0f5f87;
            font-size: 15px;
            margin-bottom: 12px;
        }

        .info-row {
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 10px;
            padding: 5px 0;
            font-size: 13px;
            line-height: 1.5;
        }

        .info-label {
            color: #6b7280;
            font-weight: bold;
        }

        .info-value {
            color: #1f2937;
            word-break: break-word;
        }

        .requested-service {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 15px 17px;
            border-radius: 7px;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.5;
        }

        .requested-service strong {
            color: #0f5f87;
        }

        .section-title {
            color: #0f5f87;
            font-size: 18px;
            margin-bottom: 14px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 700px;
            border-collapse: collapse;
        }

        th {
            background: #eef7fb;
            color: #374151;
            padding: 13px 12px;
            font-size: 12px;
            text-align: left;
            border-bottom: 1px solid #d8e8ef;
        }

        td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
            vertical-align: top;
        }

        .item-name {
            font-weight: bold;
        }

        .item-description {
            color: #6b7280;
            font-size: 12px;
            margin-top: 4px;
            line-height: 1.5;
        }

        .money {
            font-weight: bold;
            white-space: nowrap;
        }

        .summary-area {
            display: flex;
            justify-content: flex-end;
            margin-top: 24px;
        }

        .bill-summary {
            width: 380px;
            max-width: 100%;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 10px 5px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
        }

        .summary-row span:first-child {
            color: #6b7280;
        }

        .summary-row span:last-child {
            font-weight: bold;
        }

        .summary-total {
            background: #eef7fb;
            padding: 15px;
            border-radius: 8px;
            margin-top: 8px;
            border-bottom: none;
        }

        .summary-total span {
            color: #0f5f87 !important;
            font-size: 19px;
            font-weight: bold;
        }

        .payment-details {
            margin-top: 28px;
            border: 1px solid #bbf7d0;
            background: #f0fdf4;
            border-radius: 10px;
            padding: 20px;
        }

        .payment-details h3 {
            color: #166534;
            margin-bottom: 15px;
            font-size: 17px;
        }

        .payment-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
        }

        .payment-box {
            background: white;
            border: 1px solid #dcfce7;
            border-radius: 8px;
            padding: 14px;
        }

        .payment-box span {
            display: block;
            color: #6b7280;
            font-size: 10px;
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 6px;
        }

        .payment-box strong {
            color: #1f2937;
            font-size: 13px;
            line-height: 1.5;
            word-break: break-word;
        }

        .qr-section {
            margin-top: 28px;
            display: flex;
            justify-content: center;
        }

        .qr-card {
            width: 100%;
            max-width: 520px;
            text-align: center;
            background: #f8fafc;
            border: 1px dashed #94a3b8;
            border-radius: 10px;
            padding: 22px;
        }

        .qr-image-wrapper {
            width: 220px;
            height: 220px;
            margin: 0 auto 16px;
            padding: 10px;
            background: white;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .qr-image {
            display: block;
            width: 200px;
            height: 200px;
            max-width: 100%;
            object-fit: contain;
        }

        .qr-card h3 {
            color: #0f5f87;
            margin-bottom: 7px;
        }

        .qr-card p {
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        .secure-label {
            display: inline-block;
            margin-top: 12px;
            background: #dcfce7;
            color: #166534;
            border-radius: 20px;
            padding: 6px 10px;
            font-size: 10px;
            font-weight: bold;
        }

        .open-digital-receipt {
            display: inline-block;
            margin-top: 14px;
            background: #0f5f87;
            color: white;
            text-decoration: none;
            padding: 9px 14px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
        }

        .open-digital-receipt:hover {
            background: #0b4f71;
        }

        .receipt-footer {
            margin-top: 30px;
            border-top: 1px solid #e5e7eb;
            padding-top: 20px;
            text-align: center;
            color: #94a3b8;
            font-size: 12px;
            line-height: 1.7;
        }

        .invalid-receipt {
            background: white;
            max-width: 700px;
            margin: 40px auto;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .invalid-receipt h2 {
            color: #b91c1c;
            margin-bottom: 10px;
        }

        .invalid-receipt p {
            color: #6b7280;
            margin-bottom: 20px;
        }

        @media(max-width: 950px) {

            .payment-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 800px) {

            .info-grid {
                grid-template-columns: 1fr;
            }

            .page-header,
            .receipt-top {
                flex-direction: column;
            }

            .receipt-info {
                text-align: left;
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

            .receipt-body {
                padding: 20px;
            }

            .payment-grid {
                grid-template-columns: 1fr;
            }
        }

        @media(max-width: 400px) {

            .qr-image-wrapper {
                width: 190px;
                height: 190px;
            }

            .qr-image {
                width: 170px;
                height: 170px;
            }
        }

        @media print {

            body {
                background: white;
            }

            .sidebar,
            .topbar,
            .page-header,
            .success-message,
            .open-digital-receipt {
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

            .receipt {
                max-width: 100%;
                box-shadow: none;
                border-radius: 0;
            }

            .receipt-top,
            .requested-service,
            .summary-total,
            .payment-success-box,
            .payment-details,
            .qr-card {
                background: white;
            }

            .receipt-top {
                border-bottom: 2px solid #0f5f87;
            }

            .qr-image-wrapper {
                border: none;
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

            <a href="<%= request.getContextPath() %>/cashier/dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PendingBills">
                Pending Bills
            </a>

            <a href="<%= request.getContextPath() %>/cashier/payment-history.jsp">
                Payment History
            </a>

            <a href="<%= request.getContextPath() %>/cashier/receipts.jsp"
               class="active">
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

                <div>

                    <h1>
                        Payment Receipt
                    </h1>

                    <p>
                        Review, print and provide the digital
                        QR receipt to the patient.
                    </p>

                </div>

                <div class="header-actions">

                    <a href="<%= request.getContextPath() %>/cashier/PendingBills"
                       class="btn btn-secondary">

                        Pending Bills

                    </a>

                    <button type="button"
                            class="btn btn-primary"
                            onclick="window.print()">

                        Print Receipt

                    </button>

                </div>

            </div>

            <%
                if (paymentSuccess != null) {
            %>

            <div class="success-message">

                <strong>
                    Payment Successful!
                </strong>

                <br>

                <%= paymentSuccess %>

            </div>

            <%
                    session.removeAttribute("paymentSuccess");
                    session.removeAttribute("completedPaymentId");
                }
            %>

            <%
                if (bill != null
                        && payment != null) {
            %>

            <div class="receipt">

                <div class="receipt-top">

                    <div class="clinic-info">

                        <h2>
                            Sunrise Dental Clinic
                        </h2>

                        <p>
                            Dental Care & Treatment Services
                            <br>
                            Colombo, Sri Lanka
                        </p>

                    </div>

                    <div class="receipt-info">

                        <h3>
                            PAYMENT RECEIPT
                        </h3>

                        <div class="receipt-number">

                            <%= bill.getBillNo() %>

                        </div>

                        <span class="paid-status">
                            PAID
                        </span>

                    </div>

                </div>

                <div class="receipt-body">

                    <div class="payment-success-box">

                        <h3>
                            Payment Completed Successfully
                        </h3>

                        <p>
                            The patient bill has been fully paid
                            and the payment transaction has been recorded.
                        </p>

                    </div>

                    <div class="info-grid">

                        <div class="info-card">

                            <h3>
                                Patient Information
                            </h3>

                            <div class="info-row">

                                <span class="info-label">
                                    Patient No
                                </span>

                                <span class="info-value">
                                    <%= bill.getPatientNo() %>
                                </span>

                            </div>

                            <div class="info-row">

                                <span class="info-label">
                                    Patient Name
                                </span>

                                <span class="info-value">
                                    <%= bill.getPatientName() %>
                                </span>

                            </div>

                        </div>

                        <div class="info-card">

                            <h3>
                                Appointment
                            </h3>

                            <div class="info-row">

                                <span class="info-label">
                                    Appointment No
                                </span>

                                <span class="info-value">
                                    <%= bill.getAppointmentNo() %>
                                </span>

                            </div>

                            <div class="info-row">

                                <span class="info-label">
                                    Date
                                </span>

                                <span class="info-value">
                                    <%= bill.getAppointmentDate() %>
                                </span>

                            </div>

                            <div class="info-row">

                                <span class="info-label">
                                    Time
                                </span>

                                <span class="info-value">
                                    <%= bill.getAppointmentTime() %>
                                </span>

                            </div>

                        </div>

                        <div class="info-card">

                            <h3>
                                Dentist Information
                            </h3>

                            <div class="info-row">

                                <span class="info-label">
                                    Dentist
                                </span>

                                <span class="info-value">

                                    Dr.
                                    <%= bill.getDentistName() %>

                                </span>

                            </div>

                            <div class="info-row">

                                <span class="info-label">
                                    Specialization
                                </span>

                                <span class="info-value">

                                    <%
                                        if (bill.getDentistSpecialization()
                                                != null
                                                && !bill.getDentistSpecialization()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <%= bill.getDentistSpecialization() %>

                                    <%
                                        } else {
                                    %>

                                    General Dentistry

                                    <%
                                        }
                                    %>

                                </span>

                            </div>

                        </div>

                        <div class="info-card">

                            <h3>
                                Receipt Information
                            </h3>

                            <div class="info-row">

                                <span class="info-label">
                                    Bill No
                                </span>

                                <span class="info-value">
                                    <%= bill.getBillNo() %>
                                </span>

                            </div>

                            <div class="info-row">

                                <span class="info-label">
                                    Payment ID
                                </span>

                                <span class="info-value">

                                    PAY-
                                    <%= String.format(
                                            "%06d",
                                            payment.getPaymentId()
                                    ) %>

                                </span>

                            </div>

                            <div class="info-row">

                                <span class="info-label">
                                    Paid At
                                </span>

                                <span class="info-value">

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

                                </span>

                            </div>

                        </div>

                    </div>

                    <div class="requested-service">

                        <strong>
                            Patient Requested Service:
                        </strong>

                        <%= bill.getRequestedServiceName() %>

                    </div>

                    <h2 class="section-title">
                        Treatment & Billing Details
                    </h2>

                    <%
                        List<BillItem> billItems =
                                bill.getBillItems();

                        if (billItems != null
                                && !billItems.isEmpty()) {
                    %>

                    <div class="table-wrapper">

                        <table>

                            <thead>

                                <tr>

                                    <th>
                                        Item
                                    </th>

                                    <th>
                                        Description
                                    </th>

                                    <th>
                                        Qty
                                    </th>

                                    <th>
                                        Unit Price
                                    </th>

                                    <th>
                                        Amount
                                    </th>

                                </tr>

                            </thead>

                            <tbody>

                                <%
                                    for (BillItem item : billItems) {
                                %>

                                <tr>

                                    <td>

                                        <div class="item-name">

                                            <%= item.getItemName() %>

                                        </div>

                                    </td>

                                    <td>

                                        <%
                                            if (item.getDescription() != null
                                                    && !item.getDescription()
                                                    .trim()
                                                    .isEmpty()) {
                                        %>

                                        <div class="item-description">

                                            <%= item.getDescription() %>

                                        </div>

                                        <%
                                            } else {
                                        %>

                                        -

                                        <%
                                            }
                                        %>

                                    </td>

                                    <td>
                                        <%= item.getQuantity() %>
                                    </td>

                                    <td class="money">

                                        Rs.
                                        <%= moneyFormat.format(
                                                item.getUnitPrice()
                                        ) %>

                                    </td>

                                    <td class="money">

                                        Rs.
                                        <%= moneyFormat.format(
                                                item.getLineTotal()
                                        ) %>

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                    <%
                        }
                    %>

                    <div class="summary-area">

                        <div class="bill-summary">

                            <div class="summary-row">

                                <span>
                                    Subtotal
                                </span>

                                <span>

                                    Rs.
                                    <%= moneyFormat.format(
                                            bill.getSubtotal()
                                    ) %>

                                </span>

                            </div>

                            <div class="summary-row">

                                <span>
                                    Discount
                                </span>

                                <span>

                                    Rs.
                                    <%= moneyFormat.format(
                                            bill.getDiscount()
                                    ) %>

                                </span>

                            </div>

                            <div class="summary-row summary-total">

                                <span>
                                    Amount Paid
                                </span>

                                <span>

                                    Rs.
                                    <%= moneyFormat.format(
                                            payment.getAmount()
                                    ) %>

                                </span>

                            </div>

                        </div>

                    </div>

                    <div class="payment-details">

                        <h3>
                            Payment Information
                        </h3>

                        <div class="payment-grid">

                            <div class="payment-box">

                                <span>
                                    Payment ID
                                </span>

                                <strong>

                                    PAY-
                                    <%= String.format(
                                            "%06d",
                                            payment.getPaymentId()
                                    ) %>

                                </strong>

                            </div>

                            <div class="payment-box">

                                <span>
                                    Method
                                </span>

                                <strong>

                                    <%
                                        if ("BANK_TRANSFER".equals(
                                                payment.getMethod())) {
                                    %>

                                    Bank Transfer

                                    <%
                                        } else if ("CARD".equals(
                                                payment.getMethod())) {
                                    %>

                                    Card

                                    <%
                                        } else {
                                    %>

                                    Cash

                                    <%
                                        }
                                    %>

                                </strong>

                            </div>

                            <div class="payment-box">

                                <span>
                                    Reference
                                </span>

                                <strong>

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

                                </strong>

                            </div>

                            <div class="payment-box">

                                <span>
                                    Status
                                </span>

                                <strong>
                                    SUCCESS
                                </strong>

                            </div>

                        </div>

                    </div>

                    <div class="qr-section">

                        <div class="qr-card">

                            <div class="qr-image-wrapper">

                                <img
                                    src="<%= request.getContextPath() %>/ReceiptQR?token=<%= encodedQrToken %>"
                                    alt="Digital Receipt QR Code"
                                    class="qr-image"
                                >

                            </div>

                            <h3>
                                Digital QR Receipt
                            </h3>

                            <p>
                                Ask the patient to scan this QR code
                                to open and verify the secure digital
                                payment receipt.
                            </p>

                            <span class="secure-label">
                                VERIFIED SECURE RECEIPT
                            </span>

                            <br>

                            <a
                                href="<%= request.getContextPath() %>/DigitalReceipt?token=<%= encodedQrToken %>"
                                target="_blank"
                                rel="noopener noreferrer"
                                class="open-digital-receipt">

                                Open Digital Receipt

                            </a>

                        </div>

                    </div>

                    <div class="receipt-footer">

                        Thank you for choosing Sunrise Dental Clinic.
                        <br>
                        This is a computer-generated payment receipt.

                    </div>

                </div>

            </div>

            <%
                } else {
            %>

            <div class="invalid-receipt">

                <h2>
                    Receipt Not Available
                </h2>

                <p>
                    The payment receipt could not be loaded.
                </p>

                <a href="<%= request.getContextPath() %>/cashier/PendingBills"
                   class="btn btn-primary">

                    Return to Pending Bills

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