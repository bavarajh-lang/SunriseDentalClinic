<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.AdminPatient"%>
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
    if (request.getAttribute("patients") == null
            && request.getAttribute("patientError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/Patients"
        );

        return;
    }

    List<AdminPatient> patients =
            (List<AdminPatient>) request.getAttribute(
                    "patients"
            );

    Integer totalPatientsValue =
            (Integer) request.getAttribute(
                    "totalPatients"
            );

    Integer activePatientsValue =
            (Integer) request.getAttribute(
                    "activePatients"
            );

    Integer inactivePatientsValue =
            (Integer) request.getAttribute(
                    "inactivePatients"
            );

    String search =
            (String) request.getAttribute(
                    "search"
            );

    String selectedStatus =
            (String) request.getAttribute(
                    "selectedStatus"
            );

    String patientError =
            (String) request.getAttribute(
                    "patientError"
            );

    int totalPatients =
            totalPatientsValue != null
            ? totalPatientsValue
            : 0;

    int activePatients =
            activePatientsValue != null
            ? activePatientsValue
            : 0;

    int inactivePatients =
            inactivePatientsValue != null
            ? inactivePatientsValue
            : 0;

    if (search == null) {
        search = "";
    }

    if (selectedStatus == null) {
        selectedStatus = "";
    }

    int visiblePatients =
            patients != null
            ? patients.size()
            : 0;

    SimpleDateFormat dateFormat =
            new SimpleDateFormat(
                    "dd MMM yyyy"
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
        Patients | Sunrise Dental Clinic
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
            grid-template-columns: 2fr 1fr auto auto;
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
            padding: 11px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
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
            padding: 11px 18px;
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

        .patients-card {
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
            min-width: 1150px;
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

        .patient-row:hover {
            background: #fafcfd;
        }

        .patient-number {
            color: #0f5f87;
            font-weight: bold;
            white-space: nowrap;
        }

        .name {
            font-weight: bold;
            margin-bottom: 3px;
        }

        .sub-text {
            color: #6b7280;
            font-size: 10px;
            line-height: 1.5;
        }

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 15px;
            font-size: 9px;
            font-weight: bold;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .view-button {
            border: none;
            background: #0f5f87;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: bold;
            cursor: pointer;
            white-space: nowrap;
        }

        .view-button:hover {
            background: #0b4f71;
        }

        .details-row {
            display: none;
            background: #f8fbfd;
        }

        .details-row.show {
            display: table-row;
        }

        .details-cell {
            padding: 0 !important;
        }

        .details-panel {
            padding: 25px;
            border-left: 4px solid #0f5f87;
            margin: 12px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        .details-header {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 20px;
        }

        .details-header h3 {
            color: #0f5f87;
            margin-bottom: 5px;
        }

        .details-header p {
            color: #6b7280;
            font-size: 12px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 18px;
        }

        .detail-box {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            padding: 15px;
            border-radius: 8px;
        }

        .detail-box label {
            display: block;
            font-size: 9px;
            color: #6b7280;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-bottom: 6px;
        }

        .detail-box strong {
            font-size: 12px;
            color: #1f2937;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .details-section-title {
            color: #0f5f87;
            font-size: 14px;
            margin-top: 22px;
            margin-bottom: 12px;
        }

        .appointment-summary {
            display: grid;
            grid-template-columns: repeat(2,1fr);
            gap: 15px;
        }

        .summary-box {
            padding: 18px;
            background: #eef7fb;
            border-radius: 8px;
        }

        .summary-box span {
            display: block;
            color: #6b7280;
            font-size: 10px;
            margin-bottom: 6px;
        }

        .summary-box strong {
            color: #0f5f87;
            font-size: 22px;
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
        }

        @media(max-width: 1150px) {

            .stats {
                grid-template-columns: repeat(2,1fr);
            }

            .details-grid {
                grid-template-columns: repeat(2,1fr);
            }
        }

        @media(max-width: 850px) {

            .filters {
                grid-template-columns: 1fr 1fr;
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
            .filters,
            .details-grid,
            .appointment-summary {
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

            <a class="active"
               href="<%= request.getContextPath() %>/admin/Patients">
                Patients
            </a>

            <a href="<%= request.getContextPath() %>/admin/Appointments">
                Appointments
            </a>

            <a href="<%= request.getContextPath() %>/admin/payments.jsp">
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
                    Patient Management
                </h1>

                <p>
                    View registered patients, contact information,
                    account status and appointment activity.
                </p>

            </div>

            <%
                if (patientError != null) {
            %>

            <div class="error-message">

                <strong>
                    Patient Error
                </strong>

                <br>

                <%= h(patientError) %>

            </div>

            <%
                }
            %>

            <div class="stats">

                <div class="stat-card">

                    <h3>
                        Total Patients
                    </h3>

                    <strong>
                        <%= totalPatients %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Active Patients
                    </h3>

                    <strong>
                        <%= activePatients %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Inactive Patients
                    </h3>

                    <strong>
                        <%= inactivePatients %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Displayed Records
                    </h3>

                    <strong>
                        <%= visiblePatients %>
                    </strong>

                </div>

            </div>

            <div class="filter-card">

                <h2>
                    Search & Filter
                </h2>

                <form
                    action="<%= request.getContextPath() %>/admin/Patients"
                    method="get"
                    class="filters">

                    <div class="field-group">

                        <label>
                            Search Patient
                        </label>

                        <input
                            type="text"
                            name="search"
                            value="<%= h(search) %>"
                            placeholder="Patient no, name, username, email or phone">

                    </div>

                    <div class="field-group">

                        <label>
                            Account Status
                        </label>

                        <select name="status">

                            <option value="">
                                All Statuses
                            </option>

                            <option value="ACTIVE"
                                    <%= "ACTIVE".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Active
                            </option>

                            <option value="INACTIVE"
                                    <%= "INACTIVE".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Inactive
                            </option>

                        </select>

                    </div>

                    <button
                        type="submit"
                        class="filter-button">

                        Apply Filter

                    </button>

                    <a href="<%= request.getContextPath() %>/admin/Patients"
                       class="clear-button">

                        Clear

                    </a>

                </form>

            </div>

            <div class="patients-card">

                <div class="table-header">

                    <h2>
                        Registered Patients
                    </h2>

                    <span class="record-count">

                        <%= visiblePatients %>
                        RECORDS

                    </span>

                </div>

                <%
                    if (patients != null
                            && !patients.isEmpty()) {
                %>

                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>Patient No</th>
                                <th>Patient</th>
                                <th>Contact</th>
                                <th>Gender</th>
                                <th>Appointments</th>
                                <th>Completed</th>
                                <th>Status</th>
                                <th>Registered</th>
                                <th>Action</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                for (AdminPatient patient
                                        : patients) {

                                    String statusClass =
                                            "ACTIVE".equals(
                                                    patient.getAccountStatus()
                                            )
                                            ? "status-active"
                                            : "status-inactive";

                                    String registeredDate =
                                            patient.getCreatedAt() != null
                                            ? dateFormat.format(
                                                    patient.getCreatedAt()
                                            )
                                            : "-";

                                    String dateOfBirth =
                                            patient.getDob() != null
                                            ? dateFormat.format(
                                                    patient.getDob()
                                            )
                                            : "-";

                                    String registeredDateTime =
                                            patient.getCreatedAt() != null
                                            ? dateTimeFormat.format(
                                                    patient.getCreatedAt()
                                            )
                                            : "-";

                                    String detailId =
                                            "patient-details-"
                                            + patient.getPatientId();
                            %>

                            <tr class="patient-row">

                                <td>

                                    <span class="patient-number">
                                        <%= displayValue(patient.getPatientNo()) %>
                                    </span>

                                </td>

                                <td>

                                    <div class="name">
                                        <%= displayValue(patient.getFullName()) %>
                                    </div>

                                    <div class="sub-text">

                                        Username:
                                        <%= displayValue(patient.getUsername()) %>

                                    </div>

                                </td>

                                <td>

                                    <div>
                                        <%= displayValue(patient.getPhone()) %>
                                    </div>

                                    <div class="sub-text">
                                        <%= displayValue(patient.getEmail()) %>
                                    </div>

                                </td>

                                <td>
                                    <%= displayValue(patient.getGender()) %>
                                </td>

                                <td>
                                    <strong>
                                        <%= patient.getTotalAppointments() %>
                                    </strong>
                                </td>

                                <td>
                                    <strong>
                                        <%= patient.getCompletedAppointments() %>
                                    </strong>
                                </td>

                                <td>

                                    <span class="status <%= statusClass %>">

                                        <%= displayValue(patient.getAccountStatus()) %>

                                    </span>

                                </td>

                                <td>
                                    <%= registeredDate %>
                                </td>

                                <td>

                                    <button
                                        type="button"
                                        class="view-button"
                                        onclick="toggleDetails('<%= detailId %>', this)">

                                        View Details

                                    </button>

                                </td>

                            </tr>

                            <tr
                                id="<%= detailId %>"
                                class="details-row">

                                <td
                                    colspan="9"
                                    class="details-cell">

                                    <div class="details-panel">

                                        <div class="details-header">

                                            <div>

                                                <h3>
                                                    <%= displayValue(patient.getFullName()) %>
                                                </h3>

                                                <p>
                                                    Patient Record:
                                                    <%= displayValue(patient.getPatientNo()) %>
                                                </p>

                                            </div>

                                            <span class="status <%= statusClass %>">

                                                <%= displayValue(patient.getAccountStatus()) %>

                                            </span>

                                        </div>

                                        <h4 class="details-section-title">
                                            Account Information
                                        </h4>

                                        <div class="details-grid">

                                            <div class="detail-box">

                                                <label>
                                                    Patient Number
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getPatientNo()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Username
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getUsername()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Account Status
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getAccountStatus()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Registered
                                                </label>

                                                <strong>
                                                    <%= registeredDateTime %>
                                                </strong>

                                            </div>

                                        </div>

                                        <h4 class="details-section-title">
                                            Personal Information
                                        </h4>

                                        <div class="details-grid">

                                            <div class="detail-box">

                                                <label>
                                                    Full Name
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getFullName()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Date of Birth
                                                </label>

                                                <strong>
                                                    <%= dateOfBirth %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Gender
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getGender()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Address
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getAddress()) %>
                                                </strong>

                                            </div>

                                        </div>

                                        <h4 class="details-section-title">
                                            Contact Information
                                        </h4>

                                        <div class="details-grid">

                                            <div class="detail-box">

                                                <label>
                                                    Phone Number
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getPhone()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Email Address
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getEmail()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Emergency Contact
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getEmergencyContactName()) %>
                                                </strong>

                                            </div>

                                            <div class="detail-box">

                                                <label>
                                                    Emergency Phone
                                                </label>

                                                <strong>
                                                    <%= displayValue(patient.getEmergencyContactPhone()) %>
                                                </strong>

                                            </div>

                                        </div>

                                        <h4 class="details-section-title">
                                            Appointment Activity
                                        </h4>

                                        <div class="appointment-summary">

                                            <div class="summary-box">

                                                <span>
                                                    TOTAL APPOINTMENTS
                                                </span>

                                                <strong>
                                                    <%= patient.getTotalAppointments() %>
                                                </strong>

                                            </div>

                                            <div class="summary-box">

                                                <span>
                                                    COMPLETED APPOINTMENTS
                                                </span>

                                                <strong>
                                                    <%= patient.getCompletedAppointments() %>
                                                </strong>

                                            </div>

                                        </div>

                                    </div>

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
                        No Patients Found
                    </h3>

                    <p>
                        No registered patients matched the selected
                        search or account status filter.
                    </p>

                </div>

                <%
                    }
                %>

            </div>

        </div>

    </main>

</div>

<script>

    function toggleDetails(rowId, button) {

        const row =
                document.getElementById(rowId);

        if (!row) {
            return;
        }

        const isOpen =
                row.classList.contains("show");

        document
                .querySelectorAll(".details-row")
                .forEach(function(item) {

                    item.classList.remove("show");
                });

        document
                .querySelectorAll(".view-button")
                .forEach(function(item) {

                    item.textContent =
                            "View Details";
                });

        if (!isOpen) {

            row.classList.add("show");

            button.textContent =
                    "Hide Details";
        }
    }

</script>

</body>

</html>