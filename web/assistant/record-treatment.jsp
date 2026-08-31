<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.DentalService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Appointment appointment =
            (Appointment) request.getAttribute("appointment");

    List<DentalService> services =
            (List<DentalService>) request.getAttribute("services");

    String treatmentError =
            (String) session.getAttribute("treatmentError");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Record Treatment | Sunrise Dental Clinic
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
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
            background: #0f5f87;
            color: white;
            padding: 25px 20px;
        }

        .logo {
            font-size: 21px;
            font-weight: bold;
            margin-bottom: 35px;
        }

        .menu a {
            display: block;
            text-decoration: none;
            color: white;
            padding: 12px 14px;
            margin-bottom: 8px;
            border-radius: 6px;
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
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 6px;
        }

        .page-title p {
            color: #6b7280;
            line-height: 1.5;
        }

        .back-btn {
            text-decoration: none;
            background: #e5e7eb;
            color: #374151;
            padding: 11px 16px;
            border-radius: 7px;
            font-weight: bold;
            white-space: nowrap;
        }

        .back-btn:hover {
            background: #d1d5db;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 22px;
            line-height: 1.5;
        }

        .appointment-card,
        .form-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .appointment-card h2,
        .form-card h2 {
            color: #0f5f87;
            margin-bottom: 20px;
            font-size: 19px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .detail-box {
            background: #f9fafb;
            border-radius: 8px;
            padding: 15px;
        }

        .detail-label {
            display: block;
            font-size: 11px;
            color: #6b7280;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 7px;
        }

        .detail-value {
            font-size: 14px;
            line-height: 1.5;
        }

        .requested-service {
            margin-top: 18px;
            background: #eef7fb;
            border-left: 4px solid #0f6f9c;
            padding: 15px;
            border-radius: 7px;
            line-height: 1.5;
        }

        .requested-service strong {
            color: #0f5f87;
        }

        .clinical-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        label {
            font-size: 13px;
            font-weight: bold;
            color: #374151;
            margin-bottom: 7px;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font-size: 14px;
            outline: none;
            background: white;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #0f6f9c;
        }

        input[readonly] {
            background: #f3f4f6;
            color: #4b5563;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        .items-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 18px;
        }

        .items-header h2 {
            margin-bottom: 0;
        }

        .add-item-btn {
            border: none;
            background: #0f6f9c;
            color: white;
            padding: 10px 16px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
        }

        .add-item-btn:hover {
            background: #0c5d82;
        }

        .treatment-item {
            border: 1px solid #e5e7eb;
            background: #f9fafb;
            border-radius: 10px;
            padding: 18px;
            margin-bottom: 16px;
        }

        .item-grid {
            display: grid;
            grid-template-columns: 1.2fr 1.2fr 0.6fr 0.8fr;
            gap: 14px;
        }

        .item-description {
            margin-top: 14px;
        }

        .item-footer {
            margin-top: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        .line-total {
            font-weight: bold;
            color: #0f5f87;
        }

        .remove-btn {
            border: none;
            background: #fee2e2;
            color: #991b1b;
            padding: 8px 12px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        .remove-btn:hover {
            background: #fecaca;
        }

        .total-box {
            margin-top: 20px;
            background: #eef7fb;
            border-radius: 9px;
            padding: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .total-box span {
            color: #4b5563;
            font-weight: bold;
        }

        .total-box strong {
            color: #0f5f87;
            font-size: 22px;
        }

        .notice {
            margin-top: 20px;
            background: #fff7ed;
            border-left: 4px solid #f59e0b;
            padding: 15px;
            border-radius: 7px;
            color: #92400e;
            font-size: 13px;
            line-height: 1.6;
        }

        .submit-area {
            margin-top: 25px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .cancel-link {
            text-decoration: none;
            background: #e5e7eb;
            color: #374151;
            padding: 12px 20px;
            border-radius: 7px;
            font-weight: bold;
        }

        .cancel-link:hover {
            background: #d1d5db;
        }

        .submit-btn {
            border: none;
            background: #15803d;
            color: white;
            padding: 12px 22px;
            border-radius: 7px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-btn:hover {
            background: #166534;
        }

        .invalid-box {
            background: white;
            padding: 50px 25px;
            text-align: center;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .invalid-box h2 {
            color: #991b1b;
            margin-bottom: 10px;
        }

        .invalid-box p {
            color: #6b7280;
            line-height: 1.5;
        }

        @media(max-width: 1050px) {

            .details-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .item-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media(max-width: 700px) {

            .sidebar {
                display: none;
            }

            .content {
                padding: 20px;
            }

            .page-header {
                flex-direction: column;
            }

            .details-grid,
            .clinical-grid,
            .item-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }

            .items-header,
            .item-footer,
            .total-box,
            .submit-area {
                flex-direction: column;
                align-items: stretch;
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

            <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments"
               class="active">
                Confirmed Appointments
            </a>

            <a href="treatment-records.jsp">
                Treatment Records
            </a>

            <a href="create-bill.jsp">
                Create Bill
            </a>

            <a href="patient-history.jsp">
                Patient History
            </a>

            <a href="notifications.jsp">
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

                <div class="page-title">

                    <h1>
                        Record Treatment
                    </h1>

                    <p>
                        Record the actual dental treatment completed
                        for this appointment.
                    </p>

                </div>

                <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments"
                   class="back-btn">

                    Back to Appointments

                </a>

            </div>

            <%
                if (treatmentError != null) {
            %>

            <div class="error-message">

                <strong>
                    Unable to Save Treatment
                </strong>

                <br>

                <%= treatmentError %>

            </div>

            <%
                    session.removeAttribute(
                            "treatmentError"
                    );
                }
            %>

            <%
                if (appointment != null) {
            %>

            <div class="appointment-card">

                <h2>
                    Appointment Information
                </h2>

                <div class="details-grid">

                    <div class="detail-box">

                        <span class="detail-label">
                            Appointment Number
                        </span>

                        <span class="detail-value">

                            <%= appointment.getAppointmentNo() %>

                        </span>

                    </div>

                    <div class="detail-box">

                        <span class="detail-label">
                            Patient Number
                        </span>

                        <span class="detail-value">

                            <%= appointment.getPatientNo() %>

                        </span>

                    </div>

                    <div class="detail-box">

                        <span class="detail-label">
                            Patient Name
                        </span>

                        <span class="detail-value">

                            <%= appointment.getPatientName() %>

                        </span>

                    </div>

                    <div class="detail-box">

                        <span class="detail-label">
                            Dentist
                        </span>

                        <span class="detail-value">

                            Dr.
                            <%= appointment.getDentistName() %>

                        </span>

                    </div>

                    <div class="detail-box">

                        <span class="detail-label">
                            Appointment Date
                        </span>

                        <span class="detail-value">

                            <%= appointment.getAppointmentDate() %>

                        </span>

                    </div>

                    <div class="detail-box">

                        <span class="detail-label">
                            Appointment Time
                        </span>

                        <span class="detail-value">

                            <%= appointment.getAppointmentTime() %>

                        </span>

                    </div>

                </div>

                <div class="requested-service">

                    <strong>
                        Patient Requested Service:
                    </strong>

                    <%= appointment.getServiceName() %>

                </div>

            </div>

            <form
                action="<%= request.getContextPath() %>/assistant/SaveTreatmentServlet"
                method="post"
                id="treatmentForm">

                <input
                    type="hidden"
                    name="appointmentId"
                    value="<%= appointment.getAppointmentId() %>">

                <div class="form-card">

                    <h2>
                        Clinical Details
                    </h2>

                    <div class="clinical-grid">

                        <div class="form-group full">

                            <label>
                                Diagnosis *
                            </label>

                            <textarea
                                name="diagnosis"
                                maxlength="1000"
                                placeholder="Enter the patient's diagnosis"
                                required></textarea>

                        </div>

                        <div class="form-group">

                            <label>
                                Treatment Notes *
                            </label>

                            <textarea
                                name="treatmentNotes"
                                maxlength="1500"
                                placeholder="Describe the treatment performed"
                                required></textarea>

                        </div>

                        <div class="form-group">

                            <label>
                                Dentist Notes
                            </label>

                            <textarea
                                name="dentistNotes"
                                maxlength="1500"
                                placeholder="Additional instructions or dentist notes"></textarea>

                        </div>

                    </div>

                </div>

                <div class="form-card">

                    <div class="items-header">

                        <h2>
                            Actual Treatment Items
                        </h2>

                        <button
                            type="button"
                            class="add-item-btn"
                            id="addTreatmentItem">

                            + Add Treatment

                        </button>

                    </div>

                    <div id="treatmentItems">

                        <div class="treatment-item">

                            <div class="item-grid">

                                <div class="form-group">

                                    <label>
                                        Treatment / Service *
                                    </label>

                                    <select
                                        name="serviceId"
                                        class="service-select"
                                        required>

                                        <option value="">
                                            Select Treatment
                                        </option>

                                        <%
                                            if (services != null) {

                                                for (DentalService service
                                                        : services) {
                                        %>

                                        <option
                                            value="<%= service.getServiceId() %>"
                                            data-name="<%= service.getServiceName() %>"
                                            data-price="<%= service.getBasePrice() %>">

                                            <%= service.getServiceName() %>

                                            -

                                            Rs.
                                            <%= String.format(
                                                    "%.2f",
                                                    service.getBasePrice()
                                            ) %>

                                        </option>

                                        <%
                                                }
                                            }
                                        %>

                                        <option value="CUSTOM">

                                            Custom / Extra Treatment

                                        </option>

                                    </select>

                                </div>

                                <div class="form-group">

                                    <label>
                                        Treatment Name *
                                    </label>

                                    <input
                                        type="text"
                                        name="itemName"
                                        class="item-name"
                                        maxlength="150"
                                        required>

                                </div>

                                <div class="form-group">

                                    <label>
                                        Quantity *
                                    </label>

                                    <input
                                        type="number"
                                        name="quantity"
                                        class="quantity"
                                        value="1"
                                        min="1"
                                        max="100"
                                        required>

                                </div>

                                <div class="form-group">

                                    <label>
                                        Unit Price (Rs.) *
                                    </label>

                                    <input
                                        type="number"
                                        name="unitPrice"
                                        class="unit-price"
                                        min="0"
                                        step="0.01"
                                        required>

                                </div>

                            </div>

                            <div class="form-group item-description">

                                <label>
                                    Description
                                </label>

                                <input
                                    type="text"
                                    name="description"
                                    maxlength="255"
                                    placeholder="Optional treatment description">

                            </div>

                            <div class="item-footer">

                                <div class="line-total">

                                    Line Total:
                                    Rs.

                                    <span class="line-total-value">
                                        0.00
                                    </span>

                                </div>

                                <button
                                    type="button"
                                    class="remove-btn">

                                    Remove

                                </button>

                            </div>

                        </div>

                    </div>

                    <div class="total-box">

                        <span>
                            Estimated Treatment Total
                        </span>

                        <strong>

                            Rs.
                            <span id="grandTotal">
                                0.00
                            </span>

                        </strong>

                    </div>

                    <div class="notice">

                        The requested service may be different from
                        the actual treatment performed. Add every
                        treatment and extra procedure completed
                        during the visit.

                    </div>

                    <div class="submit-area">

                        <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments"
                           class="cancel-link">

                            Cancel

                        </a>

                        <button
                            type="submit"
                            class="submit-btn">

                            Save & Complete Treatment

                        </button>

                    </div>

                </div>

            </form>

            <%
                } else {
            %>

            <div class="invalid-box">

                <h2>
                    Appointment Not Available
                </h2>

                <p>
                    The selected confirmed appointment could not be loaded.
                </p>

            </div>

            <%
                }
            %>

        </div>

    </main>

</div>

<template id="treatmentItemTemplate">

    <div class="treatment-item">

        <div class="item-grid">

            <div class="form-group">

                <label>
                    Treatment / Service *
                </label>

                <select
                    name="serviceId"
                    class="service-select"
                    required>

                    <option value="">
                        Select Treatment
                    </option>

                    <%
                        if (services != null) {

                            for (DentalService service
                                    : services) {
                    %>

                    <option
                        value="<%= service.getServiceId() %>"
                        data-name="<%= service.getServiceName() %>"
                        data-price="<%= service.getBasePrice() %>">

                        <%= service.getServiceName() %>

                        -

                        Rs.
                        <%= String.format(
                                "%.2f",
                                service.getBasePrice()
                        ) %>

                    </option>

                    <%
                            }
                        }
                    %>

                    <option value="CUSTOM">

                        Custom / Extra Treatment

                    </option>

                </select>

            </div>

            <div class="form-group">

                <label>
                    Treatment Name *
                </label>

                <input
                    type="text"
                    name="itemName"
                    class="item-name"
                    maxlength="150"
                    required>

            </div>

            <div class="form-group">

                <label>
                    Quantity *
                </label>

                <input
                    type="number"
                    name="quantity"
                    class="quantity"
                    value="1"
                    min="1"
                    max="100"
                    required>

            </div>

            <div class="form-group">

                <label>
                    Unit Price (Rs.) *
                </label>

                <input
                    type="number"
                    name="unitPrice"
                    class="unit-price"
                    min="0"
                    step="0.01"
                    required>

            </div>

        </div>

        <div class="form-group item-description">

            <label>
                Description
            </label>

            <input
                type="text"
                name="description"
                maxlength="255"
                placeholder="Optional treatment description">

        </div>

        <div class="item-footer">

            <div class="line-total">

                Line Total:
                Rs.

                <span class="line-total-value">
                    0.00
                </span>

            </div>

            <button
                type="button"
                class="remove-btn">

                Remove

            </button>

        </div>

    </div>

</template>

<script>

    const treatmentItems =
            document.getElementById("treatmentItems");

    const addTreatmentItem =
            document.getElementById("addTreatmentItem");

    const treatmentItemTemplate =
            document.getElementById("treatmentItemTemplate");

    const grandTotal =
            document.getElementById("grandTotal");


    function updateGrandTotal() {

        let total = 0;

        document
                .querySelectorAll(".treatment-item")
                .forEach(function(row) {

                    const quantityInput =
                            row.querySelector(".quantity");

                    const unitPriceInput =
                            row.querySelector(".unit-price");

                    const totalDisplay =
                            row.querySelector(".line-total-value");

                    const quantity =
                            parseFloat(quantityInput.value) || 0;

                    const price =
                            parseFloat(unitPriceInput.value) || 0;

                    const lineTotal =
                            quantity * price;

                    totalDisplay.textContent =
                            lineTotal.toFixed(2);

                    total += lineTotal;
                });

        grandTotal.textContent =
                total.toFixed(2);
    }


    function bindTreatmentRow(row) {

        const serviceSelect =
                row.querySelector(".service-select");

        const itemName =
                row.querySelector(".item-name");

        const quantity =
                row.querySelector(".quantity");

        const unitPrice =
                row.querySelector(".unit-price");

        const removeButton =
                row.querySelector(".remove-btn");


        serviceSelect.addEventListener(
                "change",
                function() {

                    const option =
                            serviceSelect.options[
                                serviceSelect.selectedIndex
                            ];


                    if (serviceSelect.value === "CUSTOM") {

                        itemName.value = "";
                        unitPrice.value = "";

                        itemName.readOnly = false;
                        unitPrice.readOnly = false;

                        itemName.focus();

                    } else if (serviceSelect.value !== "") {

                        itemName.value =
                                option.dataset.name || "";

                        unitPrice.value =
                                option.dataset.price || "0";

                        itemName.readOnly = true;
                        unitPrice.readOnly = true;

                    } else {

                        itemName.value = "";
                        unitPrice.value = "";

                        itemName.readOnly = false;
                        unitPrice.readOnly = false;
                    }


                    updateGrandTotal();
                }
        );


        quantity.addEventListener(
                "input",
                updateGrandTotal
        );


        unitPrice.addEventListener(
                "input",
                updateGrandTotal
        );


        removeButton.addEventListener(
                "click",
                function() {

                    const rows =
                            treatmentItems.querySelectorAll(
                                ".treatment-item"
                            );


                    if (rows.length === 1) {

                        alert(
                            "At least one treatment item is required."
                        );

                        return;
                    }


                    row.remove();

                    updateGrandTotal();
                }
        );
    }


    treatmentItems
            .querySelectorAll(".treatment-item")
            .forEach(function(row) {

                bindTreatmentRow(row);
            });


    addTreatmentItem.addEventListener(
            "click",
            function() {

                const fragment =
                        treatmentItemTemplate
                                .content
                                .cloneNode(true);


                const newRow =
                        fragment.querySelector(
                            ".treatment-item"
                        );


                treatmentItems.appendChild(
                        fragment
                );


                bindTreatmentRow(
                        newRow
                );


                updateGrandTotal();
            }
    );


    updateGrandTotal();

</script>

</body>

</html>