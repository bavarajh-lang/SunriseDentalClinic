<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Appointment> confirmedAppointments =
            (List<Appointment>) request.getAttribute("confirmedAppointments");

    String confirmedAppointmentError =
            (String) request.getAttribute("confirmedAppointmentError");

    String treatmentSuccess =
            (String) session.getAttribute("treatmentSuccess");

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
        Confirmed Appointments | Sunrise Dental Clinic
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


        /* ==============================
           SIDEBAR
           ============================== */

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


        /* ==============================
           MAIN
           ============================== */

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


        /* ==============================
           PAGE TITLE
           ============================== */

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


        /* ==============================
           MESSAGES
           ============================== */

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


        /* ==============================
           APPOINTMENT LIST
           ============================== */

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


        /* ==============================
           STATUS
           ============================== */

        .status-confirmed {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;

            background: #dcfce7;
            color: #166534;

            font-size: 12px;
            font-weight: bold;
        }


        /* ==============================
           DETAILS
           ============================== */

        .details-grid {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);
            gap: 16px;
        }

        .detail-box {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
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


        /* ==============================
           REASON
           ============================== */

        .reason-box {
            margin-top: 18px;
            padding: 16px;

            background: #f9fafb;

            border-radius: 8px;
        }

        .reason-box h4 {
            color: #374151;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .reason-box p {
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
        }


        /* ==============================
           TREATMENT SECTION
           ============================== */

        .treatment-section {
            margin-top: 22px;
            padding-top: 20px;

            border-top:
                1px solid #e5e7eb;

            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .treatment-info h3 {
            color: #0f5f87;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .treatment-info p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        .treatment-btn {
            display: inline-block;

            text-decoration: none;

            background: #0f6f9c;
            color: white;

            padding: 11px 18px;

            border-radius: 7px;

            font-size: 14px;
            font-weight: bold;

            white-space: nowrap;
        }

        .treatment-btn:hover {
            background: #0c5d82;
        }


        /* ==============================
           EMPTY STATE
           ============================== */

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


        /* ==============================
           RESPONSIVE
           ============================== */

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

            .details-grid {
                grid-template-columns: 1fr;
            }

            .appointment-header,
            .treatment-section {
                flex-direction: column;
                align-items: flex-start;
            }
        }

    </style>

</head>


<body>

<div class="layout">


    <!-- ==============================
         SIDEBAR
         ============================== -->

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


    <!-- ==============================
         MAIN
         ============================== -->

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


            <!-- ==============================
                 PAGE TITLE
                 ============================== -->

            <div class="page-title">

                <h1>
                    Confirmed Appointments
                </h1>

                <p>
                    View confirmed appointments for your assigned
                    dentist and record treatment details after
                    the patient's consultation.
                </p>

            </div>


            <!-- ==============================
                 SUCCESS MESSAGE
                 ============================== -->

            <%
                if (treatmentSuccess != null) {
            %>

            <div class="success-message">

                <strong>Success!</strong>

                <br>

                <%= treatmentSuccess %>

            </div>

            <%
                    session.removeAttribute(
                            "treatmentSuccess"
                    );
                }
            %>


            <!-- ==============================
                 SESSION ERROR
                 ============================== -->

            <%
                if (treatmentError != null) {
            %>

            <div class="error-message">

                <strong>Error!</strong>

                <br>

                <%= treatmentError %>

            </div>

            <%
                    session.removeAttribute(
                            "treatmentError"
                    );
                }
            %>


            <!-- ==============================
                 LOAD ERROR
                 ============================== -->

            <%
                if (confirmedAppointmentError != null) {
            %>

            <div class="error-message">

                <strong>Error!</strong>

                <br>

                <%= confirmedAppointmentError %>

            </div>

            <%
                }
            %>


            <!-- ==============================
                 CONFIRMED APPOINTMENTS
                 ============================== -->

            <%
                if (confirmedAppointments != null
                        && !confirmedAppointments.isEmpty()) {
            %>


            <div class="appointments">


                <%
                    for (Appointment appointment
                            : confirmedAppointments) {
                %>


                <div class="appointment-card">


                    <!-- ==============================
                         HEADER
                         ============================== -->

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


                        <span class="status-confirmed">

                            CONFIRMED

                        </span>

                    </div>


                    <!-- ==============================
                         DETAILS
                         ============================== -->

                    <div class="details-grid">


                        <!-- PATIENT -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient Name
                            </span>

                            <span class="detail-value">

                                <%= appointment.getPatientName() %>

                            </span>

                        </div>


                        <!-- REQUESTED SERVICE -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Requested Service
                            </span>

                            <span class="detail-value">

                                <%= appointment.getServiceName() %>

                            </span>

                        </div>


                        <!-- DENTIST -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Dentist
                            </span>

                            <span class="detail-value">

                                Dr.
                                <%= appointment.getDentistName() %>

                            </span>

                        </div>


                        <!-- SPECIALIZATION -->

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


                        <!-- DATE -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Date
                            </span>

                            <span class="detail-value">

                                <%= appointment
                                        .getAppointmentDate() %>

                            </span>

                        </div>


                        <!-- TIME -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Time
                            </span>

                            <span class="detail-value">

                                <%= appointment
                                        .getAppointmentTime() %>

                            </span>

                        </div>

                    </div>


                    <!-- ==============================
                         PATIENT REASON
                         ============================== -->

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


                    <!-- ==============================
                         RECORD TREATMENT
                         ============================== -->

                    <div class="treatment-section">


                        <div class="treatment-info">

                            <h3>
                                Treatment Details
                            </h3>

                            <p>
                                After the dentist completes the consultation,
                                record the actual treatment, diagnosis and
                                any additional treatment performed.
                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath() %>/assistant/RecordTreatment?appointmentId=<%= appointment.getAppointmentId() %>"
                            class="treatment-btn">

                            Record Treatment

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


            <!-- ==============================
                 EMPTY STATE
                 ============================== -->

            <div class="empty-state">

                <h2>
                    No Confirmed Appointments
                </h2>

                <p>
                    There are currently no confirmed appointments
                    for your assigned dentist.
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