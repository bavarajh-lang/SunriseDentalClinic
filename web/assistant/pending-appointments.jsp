<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Appointment> pendingAppointments =
            (List<Appointment>) request.getAttribute("pendingAppointments");

    String pendingAppointmentError =
            (String) request.getAttribute("pendingAppointmentError");

    String appointmentUpdateSuccess =
            (String) session.getAttribute("appointmentUpdateSuccess");

    String appointmentUpdateError =
            (String) session.getAttribute("appointmentUpdateError");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Pending Appointments | Sunrise Dental Clinic
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


        /* ====================================
           SIDEBAR
           ==================================== */

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


        /* ====================================
           MAIN
           ==================================== */

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

            box-shadow:
                0 2px 10px rgba(0,0,0,0.06);
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


        /* ====================================
           PAGE TITLE
           ==================================== */

        .page-title {
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


        /* ====================================
           MESSAGES
           ==================================== */

        .success-message {
            background: #ecfdf3;
            border: 1px solid #86efac;
            color: #166534;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 20px;
            line-height: 1.5;
        }


        /* ====================================
           APPOINTMENT CARD
           ==================================== */

        .appointments {
            display: grid;
            gap: 22px;
        }

        .appointment-card {
            background: white;
            border-radius: 12px;
            padding: 25px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 15px;

            padding-bottom: 18px;
            margin-bottom: 20px;

            border-bottom:
                1px solid #e5e7eb;
        }

        .appointment-number {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 5px;
        }

        .patient-number {
            color: #6b7280;
            font-size: 13px;
        }


        /* ====================================
           STATUS
           ==================================== */

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


        /* ====================================
           DETAILS GRID
           ==================================== */

        .details-grid {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);
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
            font-weight: bold;
            text-transform: uppercase;
            color: #6b7280;
            margin-bottom: 7px;
        }

        .detail-value {
            font-size: 14px;
            color: #1f2937;
            line-height: 1.5;
        }


        /* ====================================
           REASON
           ==================================== */

        .reason-box {
            margin-top: 18px;
            background: #f9fafb;
            padding: 16px;
            border-radius: 8px;
        }

        .reason-box h4 {
            color: #374151;
            margin-bottom: 8px;
        }

        .reason-box p {
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
        }


        /* ====================================
           ACTION AREA
           ==================================== */

        .action-section {
            margin-top: 22px;
            padding-top: 20px;

            border-top:
                1px solid #e5e7eb;
        }

        .action-section h3 {
            color: #0f5f87;
            margin-bottom: 17px;
            font-size: 17px;
        }

        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .confirm-btn {
            border: none;
            background: #15803d;
            color: white;
            padding: 11px 18px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
        }

        .confirm-btn:hover {
            background: #166534;
        }

        .reschedule-toggle {
            border: none;
            background: #4f46e5;
            color: white;
            padding: 11px 18px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
        }

        .reschedule-toggle:hover {
            background: #4338ca;
        }

        .cancel-btn {
            border: none;
            background: #dc2626;
            color: white;
            padding: 11px 18px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
        }

        .cancel-btn:hover {
            background: #b91c1c;
        }


        /* ====================================
           RESCHEDULE FORM
           ==================================== */

        .reschedule-form {
            display: none;

            margin-top: 20px;

            background: #eef2ff;

            border-left:
                4px solid #4f46e5;

            padding: 20px;

            border-radius: 8px;
        }

        .reschedule-form h4 {
            color: #3730a3;
            margin-bottom: 15px;
        }

        .form-grid {
            display: grid;
            grid-template-columns:
                repeat(2, 1fr);
            gap: 16px;
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
        textarea {
            padding: 11px;
            border: 1px solid #c7d2fe;
            border-radius: 7px;
            outline: none;
            font-size: 14px;
        }

        input:focus,
        textarea:focus {
            border-color: #4f46e5;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        .submit-reschedule-btn {
            margin-top: 16px;
            border: none;
            background: #4f46e5;
            color: white;
            padding: 11px 18px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-reschedule-btn:hover {
            background: #4338ca;
        }


        /* ====================================
           EMPTY STATE
           ==================================== */

        .empty-state {
            background: white;
            border-radius: 12px;
            padding: 55px 25px;
            text-align: center;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);
        }

        .empty-state h2 {
            color: #0f5f87;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6b7280;
            line-height: 1.6;
        }


        /* ====================================
           RESPONSIVE
           ==================================== */

        @media(max-width: 950px) {

            .details-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }

        }

        @media(max-width: 700px) {

            .sidebar {
                display: none;
            }

            .content {
                padding: 20px;
            }

            .details-grid,
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }

            .appointment-header {
                flex-direction: column;
            }

        }

    </style>

</head>


<body>

<div class="layout">


    <!-- ====================================
         SIDEBAR
         ==================================== -->

    <aside class="sidebar">

        <div class="logo">
            Sunrise Dental
        </div>

        <nav class="menu">

            <a href="<%= request.getContextPath() %>/assistant/dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/assistant/PendingAppointments"
               class="active">
                Pending Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments">
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


    <!-- ====================================
         MAIN
         ==================================== -->

    <main class="main">


        <!-- TOP BAR -->

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


            <!-- PAGE TITLE -->

            <div class="page-title">

                <h1>
                    Pending Appointments
                </h1>

                <p>
                    Review appointment requests for your assigned
                    dentist and confirm, reschedule or cancel them.
                </p>

            </div>


            <!-- ====================================
                 SUCCESS MESSAGE
                 ==================================== -->

            <%
                if (appointmentUpdateSuccess != null) {
            %>

            <div class="success-message">

                <strong>Success!</strong>

                <br>

                <%= appointmentUpdateSuccess %>

            </div>

            <%
                    session.removeAttribute(
                            "appointmentUpdateSuccess"
                    );
                }
            %>


            <!-- ====================================
                 SESSION ERROR MESSAGE
                 ==================================== -->

            <%
                if (appointmentUpdateError != null) {
            %>

            <div class="error-message">

                <strong>Error!</strong>

                <br>

                <%= appointmentUpdateError %>

            </div>

            <%
                    session.removeAttribute(
                            "appointmentUpdateError"
                    );
                }
            %>


            <!-- ====================================
                 LOAD ERROR
                 ==================================== -->

            <%
                if (pendingAppointmentError != null) {
            %>

            <div class="error-message">

                <strong>Error!</strong>

                <br>

                <%= pendingAppointmentError %>

            </div>

            <%
                }
            %>


            <!-- ====================================
                 APPOINTMENTS
                 ==================================== -->

            <%
                if (pendingAppointments != null
                        && !pendingAppointments.isEmpty()) {
            %>


            <div class="appointments">


                <%
                    for (Appointment appointment
                            : pendingAppointments) {
                %>


                <div class="appointment-card">


                    <!-- HEADER -->

                    <div class="appointment-header">


                        <div>

                            <h2 class="appointment-number">

                                <%= appointment.getAppointmentNo() %>

                            </h2>

                            <div class="patient-number">

                                Patient No:
                                <strong>
                                    <%= appointment.getPatientNo() %>
                                </strong>

                            </div>

                        </div>


                        <span class="status status-pending">

                            PENDING

                        </span>

                    </div>


                    <!-- ====================================
                         APPOINTMENT DETAILS
                         ==================================== -->

                    <div class="details-grid">


                        <!-- Patient -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient Name
                            </span>

                            <span class="detail-value">

                                <%= appointment.getPatientName() %>

                            </span>

                        </div>


                        <!-- Service -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Requested Service
                            </span>

                            <span class="detail-value">

                                <%= appointment.getServiceName() %>

                            </span>

                        </div>


                        <!-- Dentist -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Dentist
                            </span>

                            <span class="detail-value">

                                Dr.
                                <%= appointment.getDentistName() %>

                            </span>

                        </div>


                        <!-- Specialization -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Specialization
                            </span>

                            <span class="detail-value">

                                <%
                                    if (appointment
                                            .getDentistSpecialization()
                                            != null
                                            &&
                                        !appointment
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


                        <!-- Date -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Requested Date
                            </span>

                            <span class="detail-value">

                                <%= appointment
                                        .getAppointmentDate() %>

                            </span>

                        </div>


                        <!-- Time -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Requested Time
                            </span>

                            <span class="detail-value">

                                <%= appointment
                                        .getAppointmentTime() %>

                            </span>

                        </div>

                    </div>


                    <!-- ====================================
                         PATIENT REASON
                         ==================================== -->

                    <div class="reason-box">

                        <h4>
                            Patient Reason / Notes
                        </h4>

                        <p>

                            <%
                                if (appointment.getReason() != null
                                        &&
                                    !appointment
                                        .getReason()
                                        .trim()
                                        .isEmpty()) {
                            %>

                            <%= appointment.getReason() %>

                            <%
                                } else {
                            %>

                            No additional notes provided.

                            <%
                                }
                            %>

                        </p>

                    </div>


                    <!-- ====================================
                         ASSISTANT ACTIONS
                         ==================================== -->

                    <div class="action-section">

                        <h3>
                            Appointment Action
                        </h3>

                        <div class="action-buttons">


                            <!-- CONFIRM -->

                            <form
                                action="<%= request.getContextPath() %>/assistant/UpdateAppointmentStatusServlet"
                                method="post">

                                <input
                                    type="hidden"
                                    name="appointmentId"
                                    value="<%= appointment.getAppointmentId() %>">

                                <input
                                    type="hidden"
                                    name="action"
                                    value="CONFIRM">

                                <button
                                    type="submit"
                                    class="confirm-btn">

                                    Confirm Appointment

                                </button>

                            </form>


                            <!-- RESCHEDULE BUTTON -->

                            <button
                                type="button"
                                class="reschedule-toggle"
                                onclick="toggleReschedule(
                                    'reschedule-<%= appointment.getAppointmentId() %>'
                                )">

                                Suggest New Date / Time

                            </button>


                            <!-- CANCEL -->

                            <form
                                action="<%= request.getContextPath() %>/assistant/UpdateAppointmentStatusServlet"
                                method="post"
                                onsubmit="return confirm(
                                    'Are you sure you want to cancel this appointment?'
                                );">

                                <input
                                    type="hidden"
                                    name="appointmentId"
                                    value="<%= appointment.getAppointmentId() %>">

                                <input
                                    type="hidden"
                                    name="action"
                                    value="CANCEL">

                                <button
                                    type="submit"
                                    class="cancel-btn">

                                    Cancel Appointment

                                </button>

                            </form>

                        </div>


                        <!-- ====================================
                             RESCHEDULE FORM
                             ==================================== -->

                        <div
                            class="reschedule-form"
                            id="reschedule-<%= appointment.getAppointmentId() %>">


                            <h4>
                                Suggest Alternative Appointment
                            </h4>


                            <form
                                action="<%= request.getContextPath() %>/assistant/UpdateAppointmentStatusServlet"
                                method="post">


                                <input
                                    type="hidden"
                                    name="appointmentId"
                                    value="<%= appointment.getAppointmentId() %>">


                                <input
                                    type="hidden"
                                    name="action"
                                    value="RESCHEDULE">


                                <div class="form-grid">


                                    <!-- New Date -->

                                    <div class="form-group">

                                        <label>
                                            Suggested Date *
                                        </label>

                                        <input
                                            type="date"
                                            name="suggestedDate"
                                            required>

                                    </div>


                                    <!-- New Time -->

                                    <div class="form-group">

                                        <label>
                                            Suggested Time *
                                        </label>

                                        <input
                                            type="time"
                                            name="suggestedTime"
                                            required>

                                    </div>


                                    <!-- Note -->

                                    <div class="form-group full">

                                        <label>
                                            Assistant Note
                                        </label>

                                        <textarea
                                            name="assistantNote"
                                            maxlength="255"
                                            placeholder="Example: Dentist is unavailable at the requested time. Please attend at the suggested date and time."></textarea>

                                    </div>

                                </div>


                                <button
                                    type="submit"
                                    class="submit-reschedule-btn">

                                    Send Reschedule Suggestion

                                </button>

                            </form>

                        </div>


                    </div>

                </div>


                <%
                    }
                %>


            </div>


            <%
                } else {
            %>


            <!-- ====================================
                 EMPTY STATE
                 ==================================== -->

            <div class="empty-state">

                <h2>
                    No Pending Appointments
                </h2>

                <p>
                    There are currently no pending appointment
                    requests for your assigned dentist.
                </p>

            </div>


            <%
                }
            %>


        </div>

    </main>

</div>


<script>

    function toggleReschedule(id) {

        const form =
                document.getElementById(id);

        if (form.style.display === "block") {

            form.style.display = "none";

        } else {

            form.style.display = "block";

        }
    }

</script>


</body>

</html>