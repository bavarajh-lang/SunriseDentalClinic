<%@page import="java.util.List"%>
<%@page import="model.AppointmentSearchResult"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("appointments") == null
            && request.getAttribute("appointmentError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/Appointments"
        );

        return;
    }

    List<AppointmentSearchResult> appointments =
            (List<AppointmentSearchResult>) request.getAttribute(
                    "appointments"
            );

    Integer totalAppointmentsValue =
            (Integer) request.getAttribute(
                    "totalAppointments"
            );

    Integer pendingAppointmentsValue =
            (Integer) request.getAttribute(
                    "pendingAppointments"
            );

    Integer confirmedAppointmentsValue =
            (Integer) request.getAttribute(
                    "confirmedAppointments"
            );

    Integer completedAppointmentsValue =
            (Integer) request.getAttribute(
                    "completedAppointments"
            );

    String search =
            (String) request.getAttribute(
                    "search"
            );

    String selectedStatus =
            (String) request.getAttribute(
                    "selectedStatus"
            );

    String selectedDate =
            (String) request.getAttribute(
                    "selectedDate"
            );

    String appointmentError =
            (String) request.getAttribute(
                    "appointmentError"
            );

    int totalAppointments =
            totalAppointmentsValue != null
            ? totalAppointmentsValue
            : 0;

    int pendingAppointments =
            pendingAppointmentsValue != null
            ? pendingAppointmentsValue
            : 0;

    int confirmedAppointments =
            confirmedAppointmentsValue != null
            ? confirmedAppointmentsValue
            : 0;

    int completedAppointments =
            completedAppointmentsValue != null
            ? completedAppointmentsValue
            : 0;

    if (search == null) {
        search = "";
    }

    if (selectedStatus == null) {
        selectedStatus = "";
    }

    if (selectedDate == null) {
        selectedDate = "";
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Appointments | Sunrise Dental Clinic
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
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
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

        .search-link {
            display: inline-block;
            background: #0f5f87;
            color: white;
            text-decoration: none;
            padding: 11px 16px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }

        .search-link:hover {
            background: #0b4f71;
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
            display: block;
            color: #0f5f87;
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
            font-size: 19px;
            margin-bottom: 16px;
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
            border: none;
            border-radius: 7px;
            padding: 11px 16px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            white-space: nowrap;
        }

        .filter-button {
            background: #0f5f87;
            color: white;
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

        .appointments-card {
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
            white-space: nowrap;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1450px;
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

        .appointment-no {
            color: #0f5f87;
            font-weight: bold;
            white-space: nowrap;
        }

        .patient-name {
            font-weight: bold;
            margin-bottom: 3px;
        }

        .sub-text {
            color: #6b7280;
            font-size: 10px;
            line-height: 1.5;
        }

        .dentist-name {
            font-weight: bold;
            margin-bottom: 3px;
        }

        .service-name {
            font-weight: bold;
            margin-bottom: 3px;
        }

        .date-time {
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

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-reschedule {
            background: #ffedd5;
            color: #c2410c;
        }

        .status-completed {
            background: #dcfce7;
            color: #166534;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-default {
            background: #e5e7eb;
            color: #374151;
        }

        .view-form {
            margin: 0;
        }

        .view-button {
            border: none;
            background: #0f5f87;
            color: white;
            border-radius: 6px;
            padding: 8px 11px;
            font-size: 10px;
            font-weight: bold;
            cursor: pointer;
            white-space: nowrap;
        }

        .view-button:hover {
            background: #0b4f71;
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

            .page-header {
                flex-direction: column;
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

            <a href="<%= request.getContextPath() %>/admin/patients.jsp">
                Patients
            </a>

            <a href="<%= request.getContextPath() %>/admin/Appointments"
               class="active">
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
                        Clinic Appointments
                    </h1>

                    <p>
                        View, search and filter all appointment
                        activity across Sunrise Dental Clinic.
                    </p>

                </div>

                <a href="<%= request.getContextPath() %>/AppointmentSearch"
                   class="search-link">

                    Appointment Number Search

                </a>

            </div>

            <%
                if (appointmentError != null) {
            %>

            <div class="error-message">

                <strong>
                    Appointment Error
                </strong>

                <br>

                <%= appointmentError %>

            </div>

            <%
                }
            %>

            <div class="stats">

                <div class="stat-card">

                    <h3>
                        Total Appointments
                    </h3>

                    <strong>
                        <%= totalAppointments %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Pending
                    </h3>

                    <strong>
                        <%= pendingAppointments %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Confirmed
                    </h3>

                    <strong>
                        <%= confirmedAppointments %>
                    </strong>

                </div>

                <div class="stat-card">

                    <h3>
                        Completed
                    </h3>

                    <strong>
                        <%= completedAppointments %>
                    </strong>

                </div>

            </div>

            <div class="filter-card">

                <h2>
                    Search & Filter
                </h2>

                <form
                    action="<%= request.getContextPath() %>/admin/Appointments"
                    method="get"
                    class="filters">

                    <div class="field-group">

                        <label>
                            Search
                        </label>

                        <input
                            type="text"
                            name="search"
                            value="<%= search %>"
                            placeholder="Appointment, patient, dentist or service">

                    </div>

                    <div class="field-group">

                        <label>
                            Status
                        </label>

                        <select name="status">

                            <option value="">
                                All Statuses
                            </option>

                            <option value="PENDING"
                                    <%= "PENDING".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Pending
                            </option>

                            <option value="CONFIRMED"
                                    <%= "CONFIRMED".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Confirmed
                            </option>

                            <option value="RESCHEDULE_REQUESTED"
                                    <%= "RESCHEDULE_REQUESTED".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Reschedule Requested
                            </option>

                            <option value="COMPLETED"
                                    <%= "COMPLETED".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Completed
                            </option>

                            <option value="CANCELLED"
                                    <%= "CANCELLED".equals(selectedStatus)
                                    ? "selected"
                                    : "" %>>
                                Cancelled
                            </option>

                        </select>

                    </div>

                    <div class="field-group">

                        <label>
                            Appointment Date
                        </label>

                        <input
                            type="date"
                            name="appointmentDate"
                            value="<%= selectedDate %>">

                    </div>

                    <button
                        type="submit"
                        class="filter-button">

                        Apply Filter

                    </button>

                    <a href="<%= request.getContextPath() %>/admin/Appointments"
                       class="clear-button">

                        Clear

                    </a>

                </form>

            </div>

            <div class="appointments-card">

                <div class="table-header">

                    <h2>
                        Appointment Records
                    </h2>

                    <span class="record-count">

                        <%
                            int visibleRecords =
                                    appointments != null
                                    ? appointments.size()
                                    : 0;
                        %>

                        <%= visibleRecords %>
                        RECORDS

                    </span>

                </div>

                <%
                    if (appointments != null
                            && !appointments.isEmpty()) {
                %>

                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>Appointment</th>
                                <th>Patient</th>
                                <th>Dentist</th>
                                <th>Requested Service</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Reason</th>
                                <th>Action</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                for (AppointmentSearchResult appointment
                                        : appointments) {

                                    String statusClass =
                                            "status-default";

                                    if ("PENDING".equals(
                                            appointment.getStatus())) {

                                        statusClass =
                                                "status-pending";

                                    } else if ("CONFIRMED".equals(
                                            appointment.getStatus())) {

                                        statusClass =
                                                "status-confirmed";

                                    } else if ("RESCHEDULE_REQUESTED".equals(
                                            appointment.getStatus())) {

                                        statusClass =
                                                "status-reschedule";

                                    } else if ("COMPLETED".equals(
                                            appointment.getStatus())) {

                                        statusClass =
                                                "status-completed";

                                    } else if ("CANCELLED".equals(
                                            appointment.getStatus())) {

                                        statusClass =
                                                "status-cancelled";
                                    }
                            %>

                            <tr>

                                <td>

                                    <div class="appointment-no">
                                        <%= appointment.getAppointmentNo() %>
                                    </div>

                                </td>

                                <td>

                                    <div class="patient-name">
                                        <%= appointment.getPatientName() %>
                                    </div>

                                    <div class="sub-text">
                                        <%= appointment.getPatientNo() %>
                                    </div>

                                    <%
                                        if (appointment.getPatientPhone()
                                                != null
                                                && !appointment
                                                .getPatientPhone()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <div class="sub-text">
                                        <%= appointment.getPatientPhone() %>
                                    </div>

                                    <%
                                        }
                                    %>

                                </td>

                                <td>

                                    <div class="dentist-name">

                                        Dr.
                                        <%= appointment.getDentistName() %>

                                    </div>

                                    <div class="sub-text">

                                        <%
                                            if (appointment
                                                    .getDentistSpecialization()
                                                    != null
                                                    && !appointment
                                                    .getDentistSpecialization()
                                                    .trim()
                                                    .isEmpty()) {
                                        %>

                                        <%= appointment
                                                .getDentistSpecialization() %>

                                        <%
                                            } else {
                                        %>

                                        General Dentistry

                                        <%
                                            }
                                        %>

                                    </div>

                                </td>

                                <td>

                                    <div class="service-name">
                                        <%= appointment.getServiceName() %>
                                    </div>

                                    <div class="sub-text">
                                        <%= appointment.getServiceCode() %>
                                    </div>

                                </td>

                                <td class="date-time">

                                    <%
                                        if (appointment.getAppointmentDate()
                                                != null) {
                                    %>

                                    <%= appointment.getAppointmentDate() %>

                                    <%
                                        } else {
                                    %>

                                    -

                                    <%
                                        }
                                    %>

                                </td>

                                <td class="date-time">

                                    <%
                                        if (appointment.getAppointmentTime()
                                                != null) {
                                    %>

                                    <%= appointment.getAppointmentTime() %>

                                    <%
                                        } else {
                                    %>

                                    -

                                    <%
                                        }
                                    %>

                                </td>

                                <td>

                                    <span class="status <%= statusClass %>">

                                        <%= appointment.getStatus() %>

                                    </span>

                                </td>

                                <td>

                                    <%
                                        if (appointment.getReason() != null
                                                && !appointment.getReason()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <%= appointment.getReason() %>

                                    <%
                                        } else {
                                    %>

                                    -

                                    <%
                                        }
                                    %>

                                </td>

                                <td>

                                    <form
                                        action="<%= request.getContextPath() %>/AppointmentSearch"
                                        method="post"
                                        class="view-form">

                                        <input
                                            type="hidden"
                                            name="appointmentNo"
                                            value="<%= appointment.getAppointmentNo() %>">

                                        <button
                                            type="submit"
                                            class="view-button">

                                            View Details

                                        </button>

                                    </form>

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
                        No Appointments Found
                    </h3>

                    <p>
                        No clinic appointments matched the
                        selected search or filter criteria.
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