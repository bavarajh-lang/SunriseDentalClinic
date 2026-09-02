<%@page import="model.AppointmentSearchResult"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String role =
            session != null
            ? (String) session.getAttribute("role")
            : null;

    String fullName =
            session != null
            ? (String) session.getAttribute("fullName")
            : null;

    if (role == null
            || (!"ADMIN".equals(role)
            && !"ASSISTANT".equals(role)
            && !"CASHIER".equals(role))) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
        );

        return;
    }

    AppointmentSearchResult appointment =
            (AppointmentSearchResult) request.getAttribute(
                    "appointment"
            );

    String searchError =
            (String) request.getAttribute(
                    "searchError"
            );

    String searchedAppointmentNo =
            (String) request.getAttribute(
                    "searchedAppointmentNo"
            );

    if (searchedAppointmentNo == null) {
        searchedAppointmentNo = "";
    }

    String dashboardLink;
    String dashboardTitle;

    if ("ADMIN".equals(role)) {

        dashboardLink =
                request.getContextPath()
                + "/admin/Dashboard";

        dashboardTitle =
                "Admin Dashboard";

    } else if ("ASSISTANT".equals(role)) {

        dashboardLink =
                request.getContextPath()
                + "/assistant/dashboard.jsp";

        dashboardTitle =
                "Assistant Dashboard";

    } else {

        dashboardLink =
                request.getContextPath()
                + "/cashier/Dashboard";

        dashboardTitle =
                "Cashier Dashboard";
    }

    String statusClass =
            "status-default";

    if (appointment != null
            && appointment.getStatus() != null) {

        switch (appointment.getStatus()) {

            case "PENDING":
                statusClass = "status-pending";
                break;

            case "CONFIRMED":
                statusClass = "status-confirmed";
                break;

            case "RESCHEDULE_REQUESTED":
                statusClass = "status-reschedule";
                break;

            case "COMPLETED":
                statusClass = "status-completed";
                break;

            case "CANCELLED":
                statusClass = "status-cancelled";
                break;

            default:
                statusClass = "status-default";
                break;
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
        Appointment Search | Sunrise Dental Clinic
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
            font-size: 11px;
            color: #d6edf7;
            margin-bottom: 35px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
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

        .search-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
        }

        .search-card h2 {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 7px;
        }

        .search-card p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
            margin-bottom: 18px;
        }

        .search-form {
            display: flex;
            gap: 12px;
            align-items: stretch;
        }

        .search-input {
            flex: 1;
            min-width: 0;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 13px 15px;
            font-size: 14px;
            outline: none;
            transition: 0.2s;
        }

        .search-input:focus {
            border-color: #0f5f87;
            box-shadow: 0 0 0 3px rgba(15,95,135,0.10);
        }

        .search-button {
            border: none;
            border-radius: 8px;
            background: #0f5f87;
            color: white;
            padding: 0 23px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .search-button:hover {
            background: #0b4f71;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 25px;
            line-height: 1.5;
            font-size: 13px;
        }

        .result-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            overflow: hidden;
        }

        .result-header {
            background: #eef7fb;
            padding: 22px 25px;
            border-bottom: 1px solid #d7e8ef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .result-header h2 {
            color: #0f5f87;
            font-size: 21px;
            margin-bottom: 5px;
        }

        .appointment-number {
            color: #475569;
            font-size: 13px;
            font-weight: bold;
        }

        .status {
            display: inline-block;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 10px;
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

        .result-body {
            padding: 25px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2,1fr);
            gap: 20px;
        }

        .details-card {
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 20px;
            background: #fafcfd;
        }

        .details-card h3 {
            color: #0f5f87;
            font-size: 16px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e5e7eb;
        }

        .detail-row {
            display: grid;
            grid-template-columns: 145px 1fr;
            gap: 12px;
            padding: 7px 0;
            font-size: 13px;
            line-height: 1.5;
        }

        .detail-label {
            color: #6b7280;
            font-weight: bold;
        }

        .detail-value {
            color: #1f2937;
            word-break: break-word;
        }

        .service-box {
            margin-top: 20px;
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 18px 20px;
            border-radius: 8px;
        }

        .service-box h3 {
            color: #0f5f87;
            font-size: 15px;
            margin-bottom: 7px;
        }

        .service-box p {
            color: #475569;
            font-size: 13px;
            line-height: 1.6;
        }

        .reason-box {
            margin-top: 20px;
            border: 1px solid #e5e7eb;
            border-radius: 9px;
            padding: 18px;
        }

        .reason-box h3 {
            color: #0f5f87;
            font-size: 15px;
            margin-bottom: 8px;
        }

        .reason-box p {
            color: #475569;
            font-size: 13px;
            line-height: 1.7;
            white-space: pre-wrap;
        }

        .reschedule-box {
            margin-top: 20px;
            background: #fff7ed;
            border: 1px solid #fed7aa;
            border-left: 4px solid #f97316;
            border-radius: 8px;
            padding: 18px 20px;
        }

        .reschedule-box h3 {
            color: #c2410c;
            font-size: 15px;
            margin-bottom: 12px;
        }

        .reschedule-grid {
            display: grid;
            grid-template-columns: repeat(2,1fr);
            gap: 12px;
        }

        .reschedule-item {
            background: white;
            border: 1px solid #fed7aa;
            border-radius: 7px;
            padding: 12px;
        }

        .reschedule-item span {
            display: block;
            color: #9a3412;
            font-size: 10px;
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .reschedule-item strong {
            color: #431407;
            font-size: 13px;
        }

        .assistant-note {
            margin-top: 12px;
            background: white;
            border: 1px solid #fed7aa;
            padding: 13px;
            border-radius: 7px;
            color: #7c2d12;
            font-size: 13px;
            line-height: 1.6;
        }

        .result-footer {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
        }

        .back-button {
            display: inline-block;
            background: #e5e7eb;
            color: #374151;
            text-decoration: none;
            padding: 10px 16px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
        }

        .back-button:hover {
            background: #d1d5db;
        }

        .help-box {
            margin-top: 25px;
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            border-radius: 8px;
            padding: 17px 19px;
        }

        .help-box h3 {
            color: #0f5f87;
            font-size: 14px;
            margin-bottom: 6px;
        }

        .help-box p {
            color: #4b5563;
            font-size: 12px;
            line-height: 1.6;
        }

        @media(max-width: 900px) {

            .details-grid {
                grid-template-columns: 1fr;
            }

            .reschedule-grid {
                grid-template-columns: 1fr;
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

            .search-form {
                flex-direction: column;
            }

            .search-button {
                padding: 13px 20px;
            }

            .result-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .detail-row {
                grid-template-columns: 1fr;
                gap: 3px;
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
            <%= role %> ACCESS
        </div>

        <nav class="menu">

            <a href="<%= dashboardLink %>">
                <%= dashboardTitle %>
            </a>

            <a href="<%= request.getContextPath() %>/AppointmentSearch"
               class="active">
                Appointment Search
            </a>

            <%
                if ("CASHIER".equals(role)) {
            %>

            <a href="<%= request.getContextPath() %>/cashier/PendingBills">
                Pending Bills
            </a>

            <a href="<%= request.getContextPath() %>/cashier/PaymentHistory">
                Payment History
            </a>

            <a href="<%= request.getContextPath() %>/cashier/DailySummary">
                Daily Summary
            </a>

            <%
                }
            %>

        </nav>

    </aside>

    <main class="main">

        <div class="topbar">

            <div class="welcome">

                Welcome,
                <%= fullName != null ? fullName : "User" %>

            </div>

            <a href="<%= request.getContextPath() %>/LogoutServlet"
               class="logout">

                Logout

            </a>

        </div>

        <div class="content">

            <div class="page-header">

                <h1>
                    Appointment Search
                </h1>

                <p>
                    Search an appointment using its unique
                    appointment number and view the complete
                    patient and appointment information.
                </p>

            </div>

            <div class="search-card">

                <h2>
                    Search by Appointment Number
                </h2>

                <p>
                    Enter the complete appointment number
                    issued by Sunrise Dental Clinic.
                </p>

                <form
                    action="<%= request.getContextPath() %>/AppointmentSearch"
                    method="post"
                    class="search-form">

                    <input
                        type="text"
                        name="appointmentNo"
                        class="search-input"
                        placeholder="Example: APT-63E10569"
                        value="<%= searchedAppointmentNo %>"
                        maxlength="50"
                        autocomplete="off"
                        required>

                    <button
                        type="submit"
                        class="search-button">

                        Search Appointment

                    </button>

                </form>

            </div>

            <%
                if (searchError != null) {
            %>

            <div class="error-message">

                <strong>
                    Search Result:
                </strong>

                <br>

                <%= searchError %>

            </div>

            <%
                }
            %>

            <%
                if (appointment != null) {
            %>

            <div class="result-card">

                <div class="result-header">

                    <div>

                        <h2>
                            Appointment Details
                        </h2>

                        <div class="appointment-number">
                            <%= appointment.getAppointmentNo() %>
                        </div>

                    </div>

                    <span class="status <%= statusClass %>">
                        <%= appointment.getStatus() %>
                    </span>

                </div>

                <div class="result-body">

                    <div class="details-grid">

                        <div class="details-card">

                            <h3>
                                Patient Information
                            </h3>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Patient No
                                </span>

                                <span class="detail-value">
                                    <%= appointment.getPatientNo() %>
                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Patient Name
                                </span>

                                <span class="detail-value">
                                    <%= appointment.getPatientName() %>
                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Phone
                                </span>

                                <span class="detail-value">

                                    <%
                                        if (appointment.getPatientPhone() != null
                                                && !appointment.getPatientPhone()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <%= appointment.getPatientPhone() %>

                                    <%
                                        } else {
                                    %>

                                    Not Available

                                    <%
                                        }
                                    %>

                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Email
                                </span>

                                <span class="detail-value">

                                    <%
                                        if (appointment.getPatientEmail() != null
                                                && !appointment.getPatientEmail()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <%= appointment.getPatientEmail() %>

                                    <%
                                        } else {
                                    %>

                                    Not Available

                                    <%
                                        }
                                    %>

                                </span>

                            </div>

                        </div>

                        <div class="details-card">

                            <h3>
                                Dentist Information
                            </h3>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Dentist
                                </span>

                                <span class="detail-value">
                                    Dr. <%= appointment.getDentistName() %>
                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Specialization
                                </span>

                                <span class="detail-value">

                                    <%
                                        if (appointment.getDentistSpecialization()
                                                != null
                                                && !appointment
                                                .getDentistSpecialization()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                    <%= appointment.getDentistSpecialization() %>

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

                        <div class="details-card">

                            <h3>
                                Appointment Schedule
                            </h3>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Appointment No
                                </span>

                                <span class="detail-value">
                                    <%= appointment.getAppointmentNo() %>
                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Date
                                </span>

                                <span class="detail-value">

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

                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Time
                                </span>

                                <span class="detail-value">

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

                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Status
                                </span>

                                <span class="detail-value">
                                    <%= appointment.getStatus() %>
                                </span>

                            </div>

                        </div>

                        <div class="details-card">

                            <h3>
                                Requested Service
                            </h3>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Service Code
                                </span>

                                <span class="detail-value">
                                    <%= appointment.getServiceCode() %>
                                </span>

                            </div>

                            <div class="detail-row">

                                <span class="detail-label">
                                    Service
                                </span>

                                <span class="detail-value">
                                    <%= appointment.getServiceName() %>
                                </span>

                            </div>

                        </div>

                    </div>

                    <div class="service-box">

                        <h3>
                            Requested Dental Service
                        </h3>

                        <p>

                            <strong>
                                <%= appointment.getServiceCode() %>
                            </strong>

                            -

                            <%= appointment.getServiceName() %>

                        </p>

                    </div>

                    <div class="reason-box">

                        <h3>
                            Patient Reason / Notes
                        </h3>

                        <p>

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

                            No reason or additional note was provided.

                            <%
                                }
                            %>

                        </p>

                    </div>

                    <%
                        if (appointment.getSuggestedDate() != null
                                || appointment.getSuggestedTime() != null
                                || (appointment.getAssistantNote() != null
                                && !appointment.getAssistantNote()
                                .trim()
                                .isEmpty())) {
                    %>

                    <div class="reschedule-box">

                        <h3>
                            Reschedule / Assistant Information
                        </h3>

                        <div class="reschedule-grid">

                            <div class="reschedule-item">

                                <span>
                                    Suggested Date
                                </span>

                                <strong>

                                    <%
                                        if (appointment.getSuggestedDate()
                                                != null) {
                                    %>

                                    <%= appointment.getSuggestedDate() %>

                                    <%
                                        } else {
                                    %>

                                    Not Suggested

                                    <%
                                        }
                                    %>

                                </strong>

                            </div>

                            <div class="reschedule-item">

                                <span>
                                    Suggested Time
                                </span>

                                <strong>

                                    <%
                                        if (appointment.getSuggestedTime()
                                                != null) {
                                    %>

                                    <%= appointment.getSuggestedTime() %>

                                    <%
                                        } else {
                                    %>

                                    Not Suggested

                                    <%
                                        }
                                    %>

                                </strong>

                            </div>

                        </div>

                        <%
                            if (appointment.getAssistantNote() != null
                                    && !appointment.getAssistantNote()
                                    .trim()
                                    .isEmpty()) {
                        %>

                        <div class="assistant-note">

                            <strong>
                                Assistant Note:
                            </strong>

                            <br>

                            <%= appointment.getAssistantNote() %>

                        </div>

                        <%
                            }
                        %>

                    </div>

                    <%
                        }
                    %>

                    <div class="result-footer">

                        <a href="<%= dashboardLink %>"
                           class="back-button">

                            Back to <%= dashboardTitle %>

                        </a>

                    </div>

                </div>

            </div>

            <%
                }
            %>

            <div class="help-box">

                <h3>
                    Appointment Search Help
                </h3>

                <p>
                    Use the complete appointment number exactly as
                    issued by the system. Search results include patient,
                    dentist, requested service, schedule, current status
                    and rescheduling information where available.
                </p>

            </div>

        </div>

    </main>

</div>

</body>

</html>