<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Bill"%>
<%@page import="model.BillItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Bill bill =
            (Bill) request.getAttribute("bill");

    String billSuccess =
            (String) session.getAttribute("billSuccess");

    String billError =
            (String) session.getAttribute("billError");

    DecimalFormat moneyFormat =
            new DecimalFormat("#,##0.00");

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat("dd MMM yyyy - hh:mm a");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        View Bill | Sunrise Dental Clinic
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
            padding: 11px 16px;
            border-radius: 7px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
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

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .bill-container {
            max-width: 1050px;
            margin: auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .bill-top {
            background: #eef7fb;
            padding: 25px 28px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            border-bottom: 1px solid #d8e8ef;
        }

        .clinic-info h2 {
            color: #0f5f87;
            margin-bottom: 6px;
            font-size: 24px;
        }

        .clinic-info p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        .bill-info {
            text-align: right;
        }

        .bill-info h3 {
            color: #0f5f87;
            margin-bottom: 8px;
            font-size: 21px;
        }

        .bill-number {
            font-weight: bold;
            font-size: 15px;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .status-unpaid {
            background: #fef3c7;
            color: #92400e;
        }

        .status-paid {
            background: #dcfce7;
            color: #166534;
        }

        .status-partial {
            background: #dbeafe;
            color: #1e40af;
        }

        .bill-body {
            padding: 28px;
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
            grid-template-columns: 135px 1fr;
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

        .description {
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
            margin-top: 25px;
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
            font-size: 14px;
            border-bottom: 1px solid #e5e7eb;
        }

        .summary-row span:first-child {
            color: #6b7280;
        }

        .summary-row span:last-child {
            font-weight: bold;
        }

        .summary-total {
            margin-top: 8px;
            padding: 15px;
            background: #eef7fb;
            border-radius: 8px;
            border-bottom: none;
        }

        .summary-total span {
            color: #0f5f87 !important;
            font-size: 19px;
            font-weight: bold;
        }

        .payment-box {
            margin-top: 28px;
            border-radius: 9px;
            padding: 18px;
        }

        .payment-unpaid {
            background: #fff7ed;
            border: 1px solid #fdba74;
        }

        .payment-unpaid h3 {
            color: #9a3412;
            margin-bottom: 7px;
        }

        .payment-unpaid p {
            color: #7c2d12;
            font-size: 13px;
            line-height: 1.6;
        }

        .payment-paid {
            background: #ecfdf3;
            border: 1px solid #86efac;
        }

        .payment-paid h3 {
            color: #166534;
            margin-bottom: 7px;
        }

        .payment-paid p {
            color: #166534;
            font-size: 13px;
            line-height: 1.6;
        }

        .qr-section {
            margin-top: 20px;
            padding: 18px;
            border: 1px dashed #94a3b8;
            border-radius: 9px;
            text-align: center;
            background: #f8fafc;
        }

        .qr-section h3 {
            color: #0f5f87;
            margin-bottom: 8px;
        }

        .qr-section p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
            max-width: 600px;
            margin: auto;
        }

        .bill-footer {
            text-align: center;
            color: #94a3b8;
            font-size: 12px;
            padding-top: 30px;
            line-height: 1.6;
        }

        .invalid-bill {
            background: white;
            max-width: 700px;
            margin: 40px auto;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .invalid-bill h2 {
            color: #b91c1c;
            margin-bottom: 10px;
        }

        .invalid-bill p {
            color: #6b7280;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        @media(max-width: 850px) {

            .info-grid {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
            }

            .bill-top {
                flex-direction: column;
            }

            .bill-info {
                text-align: left;
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

            .bill-body {
                padding: 20px;
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
            .error-message {
                display: none !important;
            }

            .content {
                padding: 0;
            }

            .bill-container {
                max-width: 100%;
                box-shadow: none;
                border-radius: 0;
            }

            .layout {
                display: block;
            }

            .main {
                width: 100%;
            }

            .bill-top {
                background: white;
                border-bottom: 2px solid #0f5f87;
            }

            .requested-service,
            .summary-total {
                background: white;
            }

            .qr-section {
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

            <a href="<%= request.getContextPath() %>/assistant/dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/assistant/PendingAppointments">
                Pending Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments">
                Confirmed Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/TreatmentRecords"
               class="active">
                Treatment Records
            </a>

            <a href="<%= request.getContextPath() %>/assistant/create-bill.jsp">
                Create Bill
            </a>

            <a href="<%= request.getContextPath() %>/assistant/patient-history.jsp">
                Patient History
            </a>

            <a href="<%= request.getContextPath() %>/assistant/notifications.jsp">
                Notifications
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
                        Patient Bill
                    </h1>

                    <p>
                        Review the generated bill before payment
                        is processed by the cashier.
                    </p>

                </div>

                <div class="header-actions">

                    <a href="<%= request.getContextPath() %>/assistant/TreatmentRecords"
                       class="btn btn-secondary">

                        Back to Treatment Records

                    </a>

                    <button type="button"
                            class="btn btn-primary"
                            onclick="window.print()">

                        Print Bill

                    </button>

                </div>

            </div>

            <%
                if (billSuccess != null) {
            %>

            <div class="success-message">

                <strong>
                    Success!
                </strong>

                <br>

                <%= billSuccess %>

            </div>

            <%
                    session.removeAttribute("billSuccess");
                }
            %>

            <%
                if (billError != null) {
            %>

            <div class="error-message">

                <strong>
                    Bill Error
                </strong>

                <br>

                <%= billError %>

            </div>

            <%
                    session.removeAttribute("billError");
                }
            %>

            <%
                if (bill != null) {
            %>

            <div class="bill-container">

                <div class="bill-top">

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

                    <div class="bill-info">

                        <h3>
                            BILL
                        </h3>

                        <div class="bill-number">

                            <%= bill.getBillNo() %>

                        </div>

                        <%
                            if ("PAID".equals(
                                    bill.getPaymentStatus())) {
                        %>

                        <span class="status status-paid">
                            PAID
                        </span>

                        <%
                            } else if ("PARTIALLY_PAID".equals(
                                    bill.getPaymentStatus())) {
                        %>

                        <span class="status status-partial">
                            PARTIALLY PAID
                        </span>

                        <%
                            } else {
                        %>

                        <span class="status status-unpaid">
                            UNPAID
                        </span>

                        <%
                            }
                        %>

                    </div>

                </div>

                <div class="bill-body">

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
                                Appointment Information
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
                                                && !bill
                                                .getDentistSpecialization()
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
                                Bill Information
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
                                    Created
                                </span>

                                <span class="info-value">

                                    <%
                                        if (bill.getCreatedAt() != null) {
                                    %>

                                    <%= dateTimeFormat.format(
                                            bill.getCreatedAt()
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
                        Bill Items
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
                                        Quantity
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

                                        <strong>
                                            <%= item.getItemName() %>
                                        </strong>

                                    </td>

                                    <td>

                                        <%
                                            if (item.getDescription() != null
                                                    && !item.getDescription()
                                                    .trim()
                                                    .isEmpty()) {
                                        %>

                                        <div class="description">
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
                        } else {
                    %>

                    <div class="error-message">
                        No bill items are available.
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
                                    Total Amount
                                </span>

                                <span>

                                    Rs.
                                    <%= moneyFormat.format(
                                            bill.getTotalAmount()
                                    ) %>

                                </span>

                            </div>

                        </div>

                    </div>

                    <%
                        if ("PAID".equals(
                                bill.getPaymentStatus())) {
                    %>

                    <div class="payment-box payment-paid">

                        <h3>
                            Payment Completed
                        </h3>

                        <p>
                            This bill has been fully paid.
                            The digital receipt can be provided
                            to the patient.
                        </p>

                    </div>

                    <div class="qr-section">

                        <h3>
                            Digital QR Receipt
                        </h3>

                        <p>
                            The secure QR receipt is available for
                            this paid bill. The QR image will be
                            generated using the secure receipt token.
                        </p>

                    </div>

                    <%
                        } else {
                    %>

                    <div class="payment-box payment-unpaid">

                        <h3>
                            Payment Pending
                        </h3>

                        <p>
                            This bill has not been paid yet.
                            The cashier must process the payment
                            before the final digital receipt is issued.
                        </p>

                    </div>

                    <div class="qr-section">

                        <h3>
                            QR Receipt Pending
                        </h3>

                        <p>
                            The bill already contains a secure receipt
                            token. The patient QR receipt will become
                            available after payment is successfully
                            completed by the cashier.
                        </p>

                    </div>

                    <%
                        }
                    %>

                    <div class="bill-footer">

                        Sunrise Dental Clinic
                        <br>
                        Computer Generated Patient Bill

                    </div>

                </div>

            </div>

            <%
                } else {
            %>

            <div class="invalid-bill">

                <h2>
                    Bill Not Available
                </h2>

                <p>
                    The requested bill could not be loaded.
                </p>

                <a href="<%= request.getContextPath() %>/assistant/TreatmentRecords"
                   class="btn btn-primary">

                    Return to Treatment Records

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