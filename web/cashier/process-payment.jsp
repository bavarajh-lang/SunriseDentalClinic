<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="model.Bill"%>
<%@page import="model.BillItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Bill bill =
            (Bill) request.getAttribute("bill");

    String paymentError =
            (String) session.getAttribute("paymentError");

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
        Process Payment | Sunrise Dental Clinic
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

        .back-btn {
            display: inline-block;
            padding: 10px 16px;
            background: #e5e7eb;
            color: #374151;
            text-decoration: none;
            border-radius: 7px;
            font-size: 13px;
            font-weight: bold;
        }

        .back-btn:hover {
            background: #d1d5db;
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

        .payment-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.5fr) minmax(330px, 0.7fr);
            gap: 24px;
            align-items: start;
        }

        .bill-card,
        .payment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .bill-card {
            padding: 24px;
            min-width: 0;
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
            margin-bottom: 6px;
        }

        .appointment-number {
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
            grid-template-columns: repeat(2, 1fr);
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
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 7px;
        }

        .detail-value {
            color: #1f2937;
            font-size: 13px;
            line-height: 1.6;
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
            font-size: 17px;
            margin-bottom: 14px;
        }

        .table-wrapper {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 600px;
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
        }

        .item-description {
            color: #6b7280;
            font-size: 11px;
            line-height: 1.5;
        }

        .money {
            white-space: nowrap;
            font-weight: bold;
        }

        .bill-summary {
            width: 350px;
            max-width: 100%;
            margin-left: auto;
            margin-top: 22px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 9px 5px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }

        .summary-row span:first-child {
            color: #6b7280;
        }

        .summary-row span:last-child {
            font-weight: bold;
        }

        .total-row {
            background: #eef7fb;
            border-radius: 8px;
            border-bottom: none;
            padding: 14px;
            margin-top: 7px;
        }

        .total-row span {
            color: #0f5f87 !important;
            font-size: 18px;
            font-weight: bold;
        }

        .payment-card {
            overflow: hidden;
            position: sticky;
            top: 25px;
        }

        .payment-card-header {
            background: #eef7fb;
            padding: 20px;
            border-bottom: 1px solid #dbe4ea;
        }

        .payment-card-header h2 {
            color: #0f5f87;
            font-size: 20px;
            margin-bottom: 6px;
        }

        .payment-card-header p {
            color: #6b7280;
            font-size: 12px;
            line-height: 1.5;
        }

        .payment-card-body {
            padding: 22px;
        }

        .amount-due {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 9px;
            padding: 18px;
            margin-bottom: 22px;
            text-align: center;
        }

        .amount-due span {
            display: block;
            color: #6b7280;
            text-transform: uppercase;
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .amount-due strong {
            color: #0f5f87;
            font-size: 28px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            color: #374151;
            font-size: 13px;
            font-weight: bold;
            margin-bottom: 9px;
        }

        .required {
            color: #dc2626;
        }

        .method-options {
            display: grid;
            gap: 10px;
        }

        .method-option {
            position: relative;
        }

        .method-option input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .method-option label {
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 13px 14px;
            cursor: pointer;
            transition: 0.2s;
            background: white;
        }

        .method-option label:hover {
            border-color: #0f5f87;
            background: #f8fbfd;
        }

        .method-option input:checked + label {
            border-color: #0f5f87;
            background: #eef7fb;
            box-shadow: 0 0 0 1px #0f5f87;
        }

        .radio-circle {
            width: 17px;
            height: 17px;
            min-width: 17px;
            border: 2px solid #9ca3af;
            border-radius: 50%;
            position: relative;
        }

        .method-option input:checked + label .radio-circle {
            border-color: #0f5f87;
        }

        .method-option input:checked + label .radio-circle::after {
            content: "";
            width: 7px;
            height: 7px;
            background: #0f5f87;
            border-radius: 50%;
            position: absolute;
            top: 3px;
            left: 3px;
        }

        .method-name {
            font-size: 13px;
            font-weight: bold;
            color: #1f2937;
        }

        .method-description {
            color: #6b7280;
            font-size: 11px;
            margin-top: 2px;
        }

        .form-control {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            padding: 11px 12px;
            font-size: 13px;
            outline: none;
            transition: 0.2s;
        }

        .form-control:focus {
            border-color: #0f5f87;
            box-shadow: 0 0 0 3px rgba(15,95,135,0.1);
        }

        .field-help {
            color: #6b7280;
            font-size: 11px;
            line-height: 1.5;
            margin-top: 6px;
        }

        .payment-warning {
            background: #fff7ed;
            border: 1px solid #fdba74;
            color: #78350f;
            border-radius: 8px;
            padding: 13px;
            font-size: 11px;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .btn-complete {
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 13px 18px;
            background: #0f5f87;
            color: white;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-complete:hover {
            background: #0b4f71;
        }

        .btn-complete:disabled {
            background: #94a3b8;
            cursor: not-allowed;
        }

        .invalid-bill {
            background: white;
            max-width: 700px;
            margin: 40px auto;
            border-radius: 12px;
            padding: 45px 30px;
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

        @media(max-width: 1050px) {

            .payment-layout {
                grid-template-columns: 1fr;
            }

            .payment-card {
                position: static;
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

            .page-header {
                flex-direction: column;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .bill-summary {
                width: 100%;
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

                <div>

                    <h1>
                        Process Payment
                    </h1>

                    <p>
                        Review the patient bill and complete the payment.
                    </p>

                </div>

                <a href="<%= request.getContextPath() %>/cashier/PendingBills"
                   class="back-btn">

                    Back to Pending Bills

                </a>

            </div>

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
                if (bill != null) {
            %>

            <div class="payment-layout">

                <div class="bill-card">

                    <div class="bill-header">

                        <div>

                            <h2 class="bill-number">
                                <%= bill.getBillNo() %>
                            </h2>

                            <div class="appointment-number">

                                Appointment:
                                <strong>
                                    <%= bill.getAppointmentNo() %>
                                </strong>

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
                                Dentist
                            </span>

                            <div class="detail-value">

                                <strong>
                                    Dr. <%= bill.getDentistName() %>
                                </strong>

                                <%
                                    if (bill.getDentistSpecialization()
                                            != null
                                            && !bill.getDentistSpecialization()
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
                                Appointment Date
                            </span>

                            <div class="detail-value">

                                <%= bill.getAppointmentDate() %>

                            </div>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Time
                            </span>

                            <div class="detail-value">

                                <%= bill.getAppointmentTime() %>

                            </div>

                        </div>

                    </div>

                    <div class="requested-service">

                        <strong>
                            Patient Requested Service:
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
                        } else {
                    %>

                    <div class="error-message">
                        No bill items are available.
                    </div>

                    <%
                        }
                    %>

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

                <div class="payment-card">

                    <div class="payment-card-header">

                        <h2>
                            Payment Details
                        </h2>

                        <p>
                            Select how the patient is paying this bill.
                        </p>

                    </div>

                    <div class="payment-card-body">

                        <div class="amount-due">

                            <span>
                                Amount Due
                            </span>

                            <strong>

                                Rs.
                                <%= moneyFormat.format(
                                        bill.getTotalAmount()
                                ) %>

                            </strong>

                        </div>

                        <form action="<%= request.getContextPath() %>/cashier/CompletePayment"
                              method="post"
                              id="paymentForm"
                              onsubmit="return preparePaymentSubmission();">

                            <input type="hidden"
                                   name="billId"
                                   value="<%= bill.getBillId() %>">

                            <div class="form-group">

                                <label class="form-label">

                                    Payment Method

                                    <span class="required">
                                        *
                                    </span>

                                </label>

                                <div class="method-options">

                                    <div class="method-option">

                                        <input type="radio"
                                               id="cash"
                                               name="method"
                                               value="CASH"
                                               required
                                               onchange="updateReferenceField();">

                                        <label for="cash">

                                            <span class="radio-circle"></span>

                                            <span>

                                                <span class="method-name">
                                                    Cash
                                                </span>

                                                <div class="method-description">
                                                    Patient pays the full amount in cash.
                                                </div>

                                            </span>

                                        </label>

                                    </div>

                                    <div class="method-option">

                                        <input type="radio"
                                               id="card"
                                               name="method"
                                               value="CARD"
                                               onchange="updateReferenceField();">

                                        <label for="card">

                                            <span class="radio-circle"></span>

                                            <span>

                                                <span class="method-name">
                                                    Card
                                                </span>

                                                <div class="method-description">
                                                    Payment made using a debit or credit card.
                                                </div>

                                            </span>

                                        </label>

                                    </div>

                                    <div class="method-option">

                                        <input type="radio"
                                               id="bankTransfer"
                                               name="method"
                                               value="BANK_TRANSFER"
                                               onchange="updateReferenceField();">

                                        <label for="bankTransfer">

                                            <span class="radio-circle"></span>

                                            <span>

                                                <span class="method-name">
                                                    Bank Transfer
                                                </span>

                                                <div class="method-description">
                                                    Payment received through bank transfer.
                                                </div>

                                            </span>

                                        </label>

                                    </div>

                                </div>

                            </div>

                            <div class="form-group"
                                 id="referenceGroup">

                                <label for="reference"
                                       class="form-label">

                                    Payment Reference

                                    <span id="referenceRequired"
                                          class="required"
                                          style="display:none;">

                                        *

                                    </span>

                                </label>

                                <input type="text"
                                       id="reference"
                                       name="reference"
                                       class="form-control"
                                       maxlength="100"
                                       placeholder="Enter transaction or card reference">

                                <div class="field-help"
                                     id="referenceHelp">

                                    Cash payments do not require a reference number.

                                </div>

                            </div>

                            <div class="payment-warning">

                                Confirm the payment has actually been
                                received before completing this transaction.
                                After successful payment, this bill will
                                change from UNPAID to PAID.

                            </div>

                            <button type="submit"
                                    id="completePaymentButton"
                                    class="btn-complete">

                                Complete Payment

                            </button>

                        </form>

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
                    The selected bill could not be loaded for payment.
                </p>

                <a href="<%= request.getContextPath() %>/cashier/PendingBills"
                   class="back-btn">

                    Return to Pending Bills

                </a>

            </div>

            <%
                }
            %>

        </div>

    </main>

</div>

<script>

    function updateReferenceField() {

        const selectedMethod =
                document.querySelector(
                        'input[name="method"]:checked'
                );

        const reference =
                document.getElementById("reference");

        const requiredMark =
                document.getElementById("referenceRequired");

        const help =
                document.getElementById("referenceHelp");

        if (!selectedMethod) {

            reference.required = false;

            requiredMark.style.display =
                    "none";

            return;
        }

        if (selectedMethod.value === "CASH") {

            reference.required = false;

            reference.value = "";

            reference.placeholder =
                    "Not required for cash payment";

            requiredMark.style.display =
                    "none";

            help.textContent =
                    "Cash payments do not require a reference number.";

        } else if (selectedMethod.value === "CARD") {

            reference.required = true;

            reference.placeholder =
                    "Enter card transaction reference";

            requiredMark.style.display =
                    "inline";

            help.textContent =
                    "Enter the card transaction or payment reference.";

        } else {

            reference.required = true;

            reference.placeholder =
                    "Enter bank transfer reference";

            requiredMark.style.display =
                    "inline";

            help.textContent =
                    "Enter the bank transfer transaction reference.";
        }
    }


    function preparePaymentSubmission() {

        const selectedMethod =
                document.querySelector(
                        'input[name="method"]:checked'
                );

        if (!selectedMethod) {

            alert(
                    "Please select a payment method."
            );

            return false;
        }

        const reference =
                document.getElementById("reference");

        if (selectedMethod.value !== "CASH"
                && reference.value.trim() === "") {

            alert(
                    "Please enter the payment reference."
            );

            reference.focus();

            return false;
        }

        const button =
                document.getElementById(
                        "completePaymentButton"
                );

        button.disabled =
                true;

        button.textContent =
                "Processing Payment...";

        return true;
    }

</script>

</body>

</html>