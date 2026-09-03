<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("appointments") == null
            && request.getAttribute("appointmentListError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/patient/MyAppointments"
        );

        return;
    }

    List<Appointment> appointments =
            (List<Appointment>) request.getAttribute(
                    "appointments"
            );

    String appointmentListError =
            (String) request.getAttribute(
                    "appointmentListError"
            );
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        My Appointments | Sunrise Dental Clinic
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 6px;
            font-size: 32px;
        }

        .page-title p {
            color: #6b7280;
            line-height: 1.6;
        }

        .book-btn {
            text-decoration: none;
            background: #0f6f9c;
            color: white;
            padding: 12px 18px;
            border-radius: 7px;
            font-weight: bold;
            white-space: nowrap;
        }

        .book-btn:hover {
            background: #0c5d82;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 20px;
        }

        .appointments {
            display: grid;
            gap: 20px;
        }

        .appointment-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 15px;
            padding-bottom: 18px;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
        }

        .appointment-number {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 5px;
        }

        .appointment-subtitle {
            color: #6b7280;
            font-size: 13px;
        }

        .status {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background: #dcfce7;
            color: #166534;
        }

        .status-reschedule {
            background: #e0e7ff;
            color: #3730a3;
        }

        .status-completed {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-default {
            background: #e5e7eb;
            color: #374151;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(3,1fr);
            gap: 20px;
        }

        .detail-box {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
        }

        .detail-label {
            display: block;
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 6px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .detail-value {
            color: #1f2937;
            font-size: 14px;
            line-height: 1.5;
        }

        .reason-box {
            margin-top: 18px;
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
        }

        .reason-box h4 {
            color: #374151;
            margin-bottom: 7px;
            font-size: 14px;
        }

        .reason-box p {
            color: #6b7280;
            line-height: 1.5;
            font-size: 14px;
        }

        .reschedule-box {
            margin-top: 18px;
            background: #eef2ff;
            border-left: 4px solid #6366f1;
            padding: 16px;
            border-radius: 7px;
        }

        .reschedule-box h4 {
            color: #3730a3;
            margin-bottom: 10px;
        }

        .reschedule-box p {
            font-size: 14px;
            color: #4b5563;
            margin-bottom: 7px;
            line-height: 1.5;
        }

        .empty-state {
            background: white;
            border-radius: 12px;
            text-align: center;
            padding: 55px 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .empty-state h2 {
            color: #0f5f87;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6b7280;
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

            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .appointment-header {
                flex-direction: column;
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

            <a href="<%= request.getContextPath() %>/patient/MyAppointments"
               class="active">
                My Appointments
            </a>

            <a href="<%= request.getContextPath() %>/patient/TreatmentHistory">
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

                <div class="page-title">

                    <h1>
                        My Appointments
                    </h1>

                    <p>
                        View your appointment requests,
                        confirmations and previous appointments.
                    </p>

                </div>

                <a href="<%= request.getContextPath() %>/BookAppointment"
                   class="book-btn">

                    + Book New Appointment

                </a>

            </div>

            <%
                if (appointmentListError != null) {
            %>

            <div class="error-message">

                <strong>
                    Error:
                </strong>

                <%= appointmentListError %>

            </div>

            <%
                }
            %>

            <%
                if (appointments != null
                        && !appointments.isEmpty()) {
            %>

            <div class="appointments">

                <%
                    for (Appointment appointment : appointments) {

                        String status =
                                appointment.getStatus();

                        String statusClass =
                                "status-default";

                        if ("PENDING".equals(status)) {

                            statusClass =
                                    "status-pending";

                        } else if ("CONFIRMED".equals(status)) {

                            statusClass =
                                    "status-confirmed";

                        } else if ("RESCHEDULE_REQUESTED".equals(status)) {

                            statusClass =
                                    "status-reschedule";

                        } else if ("COMPLETED".equals(status)) {

                            statusClass =
                                    "status-completed";

                        } else if ("CANCELLED".equals(status)) {

                            statusClass =
                                    "status-cancelled";
                        }
                %>

                <div class="appointment-card">

                    <div class="appointment-header">

                        <div>

                            <h2 class="appointment-number">

                                <%= appointment.getAppointmentNo() %>

                            </h2>

                            <div class="appointment-subtitle">
                                Sunrise Dental Clinic Appointment
                            </div>

                        </div>

                        <span class="status <%= statusClass %>">

                            <%= status != null
                                    ? status.replace("_", " ")
                                    : "UNKNOWN" %>

                        </span>

                    </div>

                    <div class="details-grid">

                        <div class="detail-box">

                            <span class="detail-label">
                                Requested Service
                            </span>

                            <span class="detail-value">

                                <%= appointment.getServiceName() != null
                                        ? appointment.getServiceName()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Dentist
                            </span>

                            <span class="detail-value">

                                Dr.
                                <%= appointment.getDentistName() != null
                                        ? appointment.getDentistName()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Specialization
                            </span>

                            <span class="detail-value">

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

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Date
                            </span>

                            <span class="detail-value">

                                <%= appointment.getAppointmentDate()
                                        != null
                                        ? appointment.getAppointmentDate()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Time
                            </span>

                            <span class="detail-value">

                                <%= appointment.getAppointmentTime()
                                        != null
                                        ? appointment.getAppointmentTime()
                                        : "-" %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Current Status
                            </span>

                            <span class="detail-value">

                                <%= status != null
                                        ? status.replace("_", " ")
                                        : "-" %>

                            </span>

                        </div>

                    </div>

                    <%
                        if (appointment.getReason() != null
                                && !appointment.getReason()
                                .trim()
                                .isEmpty()) {
                    %>

                    <div class="reason-box">

                        <h4>
                            Your Reason / Notes
                        </h4>

                        <p>
                            <%= appointment.getReason() %>
                        </p>

                    </div>

                    <%
                        }
                    %>

                    <%
                        if (appointment.getSuggestedDate() != null
                                || appointment.getSuggestedTime() != null
                                || (appointment.getAssistantNote() != null
                                && !appointment.getAssistantNote()
                                .trim()
                                .isEmpty())) {
                    %>

                    <div class="reschedule-box">

                        <h4>
                            Assistant Update
                        </h4>

                        <%
                            if (appointment.getSuggestedDate() != null) {
                        %>

                        <p>

                            <strong>
                                Suggested Date:
                            </strong>

                            <%= appointment.getSuggestedDate() %>

                        </p>

                        <%
                            }
                        %>

                        <%
                            if (appointment.getSuggestedTime() != null) {
                        %>

                        <p>

                            <strong>
                                Suggested Time:
                            </strong>

                            <%= appointment.getSuggestedTime() %>

                        </p>

                        <%
                            }
                        %>

                        <%
                            if (appointment.getAssistantNote() != null
                                    && !appointment.getAssistantNote()
                                    .trim()
                                    .isEmpty()) {
                        %>

                        <p>

                            <strong>
                                Note:
                            </strong>

                            <%= appointment.getAssistantNote() %>

                        </p>

                        <%
                            }
                        %>

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
                    No Appointments Yet
                </h2>

                <p>
                    You haven't booked any dental appointments yet.
                </p>

                <a href="<%= request.getContextPath() %>/BookAppointment">

                    Book Your First Appointment

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