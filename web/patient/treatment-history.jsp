<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="model.TreatmentRecord"%>
<%@page import="model.TreatmentItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("treatments") == null
            && request.getAttribute("treatmentHistoryError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/patient/TreatmentHistory"
        );

        return;
    }

    List<TreatmentRecord> treatments =
            (List<TreatmentRecord>) request.getAttribute(
                    "treatments"
            );

    Integer completedTreatmentCountValue =
            (Integer) request.getAttribute(
                    "completedTreatmentCount"
            );

    String treatmentHistoryError =
            (String) request.getAttribute(
                    "treatmentHistoryError"
            );

    int completedTreatmentCount =
            completedTreatmentCountValue != null
            ? completedTreatmentCountValue
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
        Treatment History | Sunrise Dental Clinic
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
            grid-template-columns: repeat(2,1fr);
            gap: 18px;
            margin-bottom: 28px;
            max-width: 650px;
        }

        .stat-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .stat-card h3 {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .stat-card p {
            color: #0f5f87;
            font-size: 28px;
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
        }

        .treatments {
            display: grid;
            gap: 22px;
        }

        .treatment-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .treatment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            padding-bottom: 18px;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
        }

        .appointment-no {
            color: #0f5f87;
            font-size: 20px;
            margin-bottom: 5px;
        }

        .completed-text {
            color: #6b7280;
            font-size: 13px;
        }

        .completed-badge {
            display: inline-block;
            background: #dbeafe;
            color: #1e40af;
            font-size: 12px;
            font-weight: bold;
            padding: 7px 12px;
            border-radius: 20px;
        }

        .details-grid {
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

        .clinical-section {
            margin-top: 20px;
            display: grid;
            gap: 14px;
        }

        .clinical-box {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 16px;
            border-radius: 8px;
        }

        .clinical-box h3 {
            color: #0f5f87;
            font-size: 14px;
            margin-bottom: 7px;
        }

        .clinical-box p {
            color: #4b5563;
            font-size: 14px;
            line-height: 1.6;
        }

        .items-section {
            margin-top: 22px;
        }

        .items-section h3 {
            color: #0f5f87;
            margin-bottom: 14px;
            font-size: 17px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 700px;
        }

        .items-table th {
            background: #eef7fb;
            color: #0f5f87;
            text-align: left;
            padding: 12px;
            font-size: 12px;
            border-bottom: 1px solid #dbe5ea;
        }

        .items-table td {
            padding: 13px 12px;
            font-size: 13px;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: top;
        }

        .items-table tr:last-child td {
            border-bottom: none;
        }

        .item-description {
            color: #6b7280;
            font-size: 12px;
            margin-top: 4px;
            line-height: 1.5;
        }

        .amount {
            white-space: nowrap;
            font-weight: bold;
        }

        .treatment-total {
            margin-top: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 17px;
            border-radius: 8px;
        }

        .treatment-total span:first-child {
            font-weight: bold;
            color: #4b5563;
        }

        .total-value {
            color: #0f5f87;
            font-size: 21px;
            font-weight: bold;
        }

        .no-items {
            background: #f9fafb;
            color: #6b7280;
            padding: 16px;
            border-radius: 8px;
            font-size: 13px;
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

            .details-grid {
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
            .details-grid {
                grid-template-columns: 1fr;
            }

            .treatment-header,
            .treatment-total {
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

            <a href="<%= request.getContextPath() %>/patient/TreatmentHistory"
               class="active">
                Treatment History
            </a>

            <a href="<%= request.getContextPath() %>/patient/MyBills">
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
                    Treatment History
                </h1>

                <p>
                    Review your completed dental treatments,
                    diagnoses and actual treatment items.
                </p>

            </div>

            <div class="stats">

                <div class="stat-card">

                    <h3>
                        Completed Treatments
                    </h3>

                    <p>
                        <%= completedTreatmentCount %>
                    </p>

                    <div class="stat-note">
                        Total completed treatment records.
                    </div>

                </div>

                <div class="stat-card">

                    <h3>
                        Records Displayed
                    </h3>

                    <p>
                        <%= treatments != null
                                ? treatments.size()
                                : 0 %>
                    </p>

                    <div class="stat-note">
                        Treatment records currently available.
                    </div>

                </div>

            </div>

            <%
                if (treatmentHistoryError != null) {
            %>

            <div class="error-message">

                <strong>
                    Unable to Load Treatment History
                </strong>

                <br>

                <%= treatmentHistoryError %>

            </div>

            <%
                }
            %>

            <%
                if (treatments != null
                        && !treatments.isEmpty()) {
            %>

            <div class="treatments">

                <%
                    for (TreatmentRecord treatment
                            : treatments) {

                        List<TreatmentItem> items =
                                treatment.getTreatmentItems();
                %>

                <div class="treatment-card">

                    <div class="treatment-header">

                        <div>

                            <h2 class="appointment-no">

                                <%= treatment.getAppointmentNo() != null
                                        ? treatment.getAppointmentNo()
                                        : "Appointment" %>

                            </h2>

                            <div class="completed-text">

                                Completed:

                                <strong>

                                    <%= treatment.getCompletedAt() != null
                                            ? treatment.getCompletedAt()
                                            : "-" %>

                                </strong>

                            </div>

                        </div>

                        <span class="completed-badge">
                            COMPLETED
                        </span>

                    </div>

                    <div class="details-grid">

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient Number
                            </span>

                            <span class="detail-value">

                                <%= treatment.getPatientNo() != null
                                        ? treatment.getPatientNo()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Date
                            </span>

                            <span class="detail-value">

                                <%= treatment.getAppointmentDate() != null
                                        ? treatment.getAppointmentDate()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Dentist
                            </span>

                            <span class="detail-value">

                                Dr.
                                <%= treatment.getDentistName() != null
                                        ? treatment.getDentistName()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Requested Service
                            </span>

                            <span class="detail-value">

                                <%= treatment.getRequestedServiceName() != null
                                        ? treatment.getRequestedServiceName()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Treatment Record ID
                            </span>

                            <span class="detail-value">

                                <%= treatment.getTreatmentRecordId() %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Actual Treatment Items
                            </span>

                            <span class="detail-value">

                                <%= items != null
                                        ? items.size()
                                        : 0 %>

                            </span>

                        </div>

                    </div>

                    <div class="clinical-section">

                        <div class="clinical-box">

                            <h3>
                                Diagnosis
                            </h3>

                            <p>

                                <%= treatment.getDiagnosis() != null
                                        && !treatment.getDiagnosis()
                                        .trim()
                                        .isEmpty()
                                        ? treatment.getDiagnosis()
                                        : "No diagnosis information recorded." %>

                            </p>

                        </div>

                        <div class="clinical-box">

                            <h3>
                                Actual Treatment Notes
                            </h3>

                            <p>

                                <%= treatment.getTreatmentNotes() != null
                                        && !treatment.getTreatmentNotes()
                                        .trim()
                                        .isEmpty()
                                        ? treatment.getTreatmentNotes()
                                        : "No treatment notes recorded." %>

                            </p>

                        </div>

                        <%
                            if (treatment.getDentistNotes() != null
                                    && !treatment.getDentistNotes()
                                    .trim()
                                    .isEmpty()) {
                        %>

                        <div class="clinical-box">

                            <h3>
                                Dentist Notes
                            </h3>

                            <p>
                                <%= treatment.getDentistNotes() %>
                            </p>

                        </div>

                        <%
                            }
                        %>

                    </div>

                    <div class="items-section">

                        <h3>
                            Actual Treatment / Additional Work
                        </h3>

                        <%
                            if (items != null
                                    && !items.isEmpty()) {
                        %>

                        <div class="table-wrapper">

                            <table class="items-table">

                                <thead>

                                    <tr>

                                        <th>
                                            Treatment Item
                                        </th>

                                        <th>
                                            Quantity
                                        </th>

                                        <th>
                                            Unit Price
                                        </th>

                                        <th>
                                            Line Total
                                        </th>

                                    </tr>

                                </thead>

                                <tbody>

                                <%
                                    for (TreatmentItem item
                                            : items) {
                                %>

                                    <tr>

                                        <td>

                                            <strong>

                                                <%= item.getItemName() != null
                                                        ? item.getItemName()
                                                        : "-" %>

                                            </strong>

                                            <%
                                                if (item.getDescription()
                                                        != null
                                                        && !item
                                                        .getDescription()
                                                        .trim()
                                                        .isEmpty()) {
                                            %>

                                            <div class="item-description">

                                                <%= item.getDescription() %>

                                            </div>

                                            <%
                                                }
                                            %>

                                        </td>

                                        <td>

                                            <%= item.getQuantity() %>

                                        </td>

                                        <td class="amount">

                                            Rs.
                                            <%= moneyFormat.format(
                                                    item.getUnitPrice()
                                            ) %>

                                        </td>

                                        <td class="amount">

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

                        <div class="treatment-total">

                            <span>
                                Actual Treatment Total
                            </span>

                            <span class="total-value">

                                Rs.
                                <%= moneyFormat.format(
                                        treatment.getTreatmentTotal()
                                ) %>

                            </span>

                        </div>

                        <%
                            } else {
                        %>

                        <div class="no-items">

                            No individual treatment items
                            were recorded for this treatment.

                        </div>

                        <%
                            }
                        %>

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
                    No Treatment History
                </h2>

                <p>
                    You do not have any completed dental
                    treatments yet. Completed treatments
                    will appear here after the clinic records them.
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