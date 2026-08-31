<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Bill"%>
<%@page import="model.BillItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Bill> unpaidBills =
            (List<Bill>) request.getAttribute("unpaidBills");

    String pendingBillsError =
            (String) request.getAttribute("pendingBillsError");

    String paymentSuccess =
            (String) session.getAttribute("paymentSuccess");

    String paymentError =
            (String) session.getAttribute("paymentError");

    DecimalFormat moneyFormat =
            new DecimalFormat("#,##0.00");

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd MMM yyyy - hh:mm a");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Pending Bills | Sunrise Dental Clinic
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
            text-decoration: none;
            color: white;
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

        .summary-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .summary-card h3 {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .summary-card strong {
            color: #0f5f87;
            font-size: 28px;
        }

        .summary-info {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
            text-align: right;
        }

        .bills {
            display: grid;
            gap: 24px;
        }

        .bill-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            min-width: 0;
        }

        .bill-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            padding-bottom: 18px;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 20px;
        }

        .bill-number {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 6px;
        }

        .created-date {
            color: #6b7280;
            font-size: 12px;
        }

        .status {
            display: inline-block;
            background: #fef3c7;
            color: #92400e;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .detail-box {
            background: #f9fafb;
            border-radius: 8px;
            padding: 15px;
        }

        .detail-label {
            display: block;
            color: #6b7280;
            font-size: 10px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 7px;
        }

        .detail-value {
            color: #1f2937;
            font-size: 13px;
            line-height: 1.5;
        }

        .requested-service {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 20px;
            font-size: 13px;
            line-height: 1.5;
        }

        .requested-service strong {
            color: #0f5f87;
        }

        .section-title {
            color: #0f5f87;
            font-size: 16px;
            margin-bottom: 13px;
        }

        .table-wrapper {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 650px;
            border-collapse: collapse;
        }

        th {
            background: #eef7fb;
            color: #374151;
            text-align: left;
            padding: 12px;
            font-size: 11px;
            border-bottom: 1px solid #dbe4ea;
        }

        td {
            padding: 13px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
            vertical-align: top;
        }

        .item-name {
            font-weight: bold;
            color: #1f2937;
        }

        .item-description {
            color: #6b7280;
            font-size: 11px;
            line-height: 1.5;
        }

        .money {
            font-weight: bold;
            white-space: nowrap;
        }

        .bill-bottom {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 25px;
            margin-top: 22px;
        }

        .payment-info {
            max-width: 520px;
            background: #fff7ed;
            border-left: 4px solid #f59e0b;
            padding: 14px 16px;
            border-radius: 7px;
        }

        .payment-info h4 {
            color: #92400e;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .payment-info p {
            color: #78350f;
            font-size: 12px;
            line-height: 1.5;
        }

        .bill-summary {
            width: 320px;
            max-width: 100%;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 8px 4px;
            font-size: 13px;
            border-bottom: 1px solid #e5e7eb;
        }

        .summary-row span:first-child {
            color: #6b7280;
        }

        .summary-row span:last-child {
            font-weight: bold;
        }

        .total-row {
            background: #eef7fb;
            padding: 13px;
            border-radius: 7px;
            margin-top: 7px;
            border-bottom: none;
        }

        .total-row span {
            color: #0f5f87 !important;
            font-size: 17px;
            font-weight: bold;
        }

        .payment-action {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
        }

        .btn-payment {
            display: inline-block;
            background: #0f5f87;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 7px;
            padding: 11px 18px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-payment:hover {
            background: #0b4f71;
            transform: translateY(-1px);
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

        @media(max-width: 1100px) {

            .details-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 800px) {

            .summary-card,
            .bill-header,
            .bill-bottom {
                flex-direction: column;
                align-items: stretch;
            }

            .summary-info {
                text-align: left;
            }

            .bill-summary {
                width: 100%;
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

            .details-grid {
                grid-template-columns: 1fr;
            }

            .payment-action {
                justify-content: stretch;
            }

            .btn-payment {
                width: 100%;
                text-align: center;
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

            <a href="<%= request.getContextPath() %>/cashier/PendingBills"
               class="active">
                Pending Bills
            </a>

            <a href="<%= request.getContextPath() %>/cashier/payment-history.jsp">
                Payment History
            </a>

            <a href="<%= request.getContextPath() %>/cashier/receipts.jsp">
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
                    Pending Bills
                </h1>

                <p>
                    Review unpaid patient bills and process payments.
                </p>

            </div>

            <%
                if (paymentSuccess != null) {
            %>

            <div class="success-message">

                <strong>
                    Success!
                </strong>

                <br>

                <%= paymentSuccess %>

            </div>

            <%
                    session.removeAttribute("paymentSuccess");
                }
            %>

            <%
                if (paymentError != null) {
            %>

            <div class="error-message">

                <strong>
                    Payment Error
                </strong>

                <br>

                <%= paymentError %>

            </div>

            <%
                    session.removeAttribute("paymentError");
                }
            %>

            <%
                if (pendingBillsError != null) {
            %>

            <div class="error-message">

                <strong>
                    Unable to Load Bills
                </strong>

                <br>

                <%= pendingBillsError %>

            </div>

            <%
                }
            %>

            <%
                int pendingBillCount =
                        unpaidBills != null
                        ? unpaidBills.size()
                        : 0;
            %>

            <div class="summary-card">

                <div>

                    <h3>
                        Pending Payments
                    </h3>

                    <strong>
                        <%= pendingBillCount %>
                    </strong>

                </div>

                <div class="summary-info">

                    These bills are waiting for payment processing.
                    <br>
                    Paid bills are automatically removed from this list.

                </div>

            </div>

            <%
                if (unpaidBills != null
                        && !unpaidBills.isEmpty()) {
            %>

            <div class="bills">

                <%
                    for (Bill bill : unpaidBills) {
                %>

                <div class="bill-card">

                    <div class="bill-header">

                        <div>

                            <h2 class="bill-number">

                                <%= bill.getBillNo() %>

                            </h2>

                            <div class="created-date">

                                <%
                                    if (bill.getCreatedAt() != null) {
                                %>

                                Generated:
                                <%= dateFormat.format(
                                        bill.getCreatedAt()
                                ) %>

                                <%
                                    }
                                %>

                            </div>

                        </div>

                        <span class="status">
                            UNPAID
                        </span>

                    </div>

                    <div class="details-grid">

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient
                            </span>

                            <div class="detail-value">

                                <strong>
                                    <%= bill.getPatientName() %>
                                </strong>

                                <br>

                                <%= bill.getPatientNo() %>

                            </div>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment
                            </span>

                            <div class="detail-value">

                                <strong>
                                    <%= bill.getAppointmentNo() %>
                                </strong>

                                <br>

                                <%= bill.getAppointmentDate() %>

                                <br>

                                <%= bill.getAppointmentTime() %>

                            </div>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Dentist
                            </span>

                            <div class="detail-value">

                                <strong>

                                    Dr.
                                    <%= bill.getDentistName() %>

                                </strong>

                                <%
                                    if (bill.getDentistSpecialization()
                                            != null
                                            && !bill
                                            .getDentistSpecialization()
                                            .trim()
                                            .isEmpty()) {
                                %>

                                <br>

                                <%= bill.getDentistSpecialization() %>

                                <%
                                    }
                                %>

                            </div>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Payment Status
                            </span>

                            <div class="detail-value">

                                <strong>
                                    UNPAID
                                </strong>

                            </div>

                        </div>

                    </div>

                    <div class="requested-service">

                        <strong>
                            Requested Service:
                        </strong>

                        <%= bill.getRequestedServiceName() %>

                    </div>

                    <h3 class="section-title">
                        Bill Items
                    </h3>

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

                    <div class="bill-bottom">

                        <div class="payment-info">

                            <h4>
                                Payment Required
                            </h4>

                            <p>
                                Confirm the amount with the patient
                                and select the correct payment method
                                before completing this transaction.
                            </p>

                        </div>

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

                            <div class="summary-row total-row">

                                <span>
                                    Total
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

                    <div class="payment-action">

                        <a href="<%= request.getContextPath() %>/cashier/ProcessPayment?billId=<%= bill.getBillId() %>"
                           class="btn-payment">

                            Process Payment

                        </a>

                    </div>

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
                    No Pending Bills
                </h2>

                <p>
                    There are currently no unpaid patient bills
                    waiting for cashier payment.
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