<%@page import="java.util.List"%>
<%@page import="model.DentalService"%>
<%@page import="model.Dentist"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<DentalService> services =
            (List<DentalService>) request.getAttribute("services");

    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");

    String appointmentSuccess =
            (String) session.getAttribute("appointmentSuccess");

    String appointmentError =
            (String) session.getAttribute("appointmentError");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Book Appointment | Sunrise Dental Clinic
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
           Sidebar
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
           Main Layout
           ============================== */

        .main {
            flex: 1;
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

        .logout {
            color: #b91c1c;
            text-decoration: none;
            font-weight: bold;
        }

        .content {
            padding: 30px;
        }

        /* ==============================
           Page Heading
           ============================== */

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 5px;
        }

        .page-title p {
            color: #6b7280;
        }

        /* ==============================
           Form
           ============================== */

        .form-card {

            background: white;

            padding: 30px;

            border-radius: 12px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);

            max-width: 850px;
        }

        .form-grid {

            display: grid;

            grid-template-columns:
                1fr 1fr;

            gap: 20px;
        }

        .form-group {

            display: flex;

            flex-direction: column;
        }

        .form-group.full {

            grid-column: 1 / -1;
        }

        label {

            font-weight: bold;

            font-size: 14px;

            margin-bottom: 7px;

            color: #374151;
        }

        input,
        select,
        textarea {

            padding: 12px;

            border:
                1px solid #d1d5db;

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

        textarea {

            resize: vertical;

            min-height: 100px;
        }

        /* ==============================
           Submit Button
           ============================== */

        .submit-btn {

            margin-top: 25px;

            background: #0f6f9c;

            color: white;

            border: none;

            padding: 13px 22px;

            border-radius: 7px;

            font-size: 15px;

            font-weight: bold;

            cursor: pointer;
        }

        .submit-btn:hover {

            background: #0c5d82;
        }

        /* ==============================
           Information Box
           ============================== */

        .info-box {

            background: #eef7fb;

            border-left:
                4px solid #0f6f9c;

            padding: 15px;

            margin-bottom: 22px;

            border-radius: 6px;

            color: #4b5563;

            font-size: 14px;

            line-height: 1.5;
        }

        /* ==============================
           Success Message
           ============================== */

        .success-message {

            background: #ecfdf3;

            border:
                1px solid #86efac;

            color: #166534;

            padding: 14px 16px;

            border-radius: 7px;

            margin-bottom: 20px;

            line-height: 1.5;
        }

        /* ==============================
           Error Message
           ============================== */

        .error-message {

            background: #fef2f2;

            border:
                1px solid #fca5a5;

            color: #991b1b;

            padding: 14px 16px;

            border-radius: 7px;

            margin-bottom: 20px;

            line-height: 1.5;
        }

        /* ==============================
           Responsive
           ============================== */

        @media(max-width: 700px) {

            .sidebar {
                display: none;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
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

            <a href="dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/BookAppointment"
               class="active">

                Book Appointment

            </a>

<a href="<%= request.getContextPath() %>/patient/MyAppointments">
    My Appointments
</a>

            <a href="treatment-history.jsp">
                Treatment History
            </a>

            <a href="my-bills.jsp">
                My Bills
            </a>

            <a href="notifications.jsp">
                Notifications
            </a>

            <a href="profile.jsp">
                My Profile
            </a>

        </nav>

    </aside>


    <!-- ==============================
         MAIN CONTENT
         ============================== -->

    <main class="main">


        <!-- Top Bar -->

        <div class="topbar">

            <strong>

                Welcome,
                <%= session.getAttribute("fullName") %>

            </strong>

            <a href="<%= request.getContextPath() %>/LogoutServlet"
               class="logout">

                Logout

            </a>

        </div>


        <div class="content">


            <!-- Page Title -->

            <div class="page-title">

                <h1>
                    Book Appointment
                </h1>

                <p>

                    Choose your preferred dental service,
                    dentist, date and time.

                </p>

            </div>


            <!-- Appointment Form -->

            <div class="form-card">


                <!-- Information -->

                <div class="info-box">

                    Your appointment will initially be submitted as

                    <strong>
                        Pending
                    </strong>.

                    The dentist assistant will check availability
                    and confirm or suggest another time.

                </div>


                <!-- ==============================
                     SUCCESS MESSAGE
                     ============================== -->

                <%
                    if (appointmentSuccess != null) {
                %>

                <div class="success-message">

                    <strong>
                        Appointment Submitted Successfully!
                    </strong>

                    <br><br>

                    <%= appointmentSuccess %>

                </div>

                <%
                        session.removeAttribute(
                                "appointmentSuccess"
                        );
                    }
                %>


                <!-- ==============================
                     ERROR MESSAGE
                     ============================== -->

                <%
                    if (appointmentError != null) {
                %>

                <div class="error-message">

                    <strong>
                        Unable to Book Appointment
                    </strong>

                    <br><br>

                    <%= appointmentError %>

                </div>

                <%
                        session.removeAttribute(
                                "appointmentError"
                        );
                    }
                %>


                <!-- ==============================
                     FORM
                     ============================== -->

                <form
                    action="<%= request.getContextPath() %>/BookAppointmentServlet"
                    method="post">


                    <div class="form-grid">


                        <!-- ==============================
                             Dental Service
                             ============================== -->

                        <div class="form-group">

                            <label>
                                Dental Service *
                            </label>

                            <select
                                name="serviceId"
                                required>

                                <option value="">

                                    Select Service

                                </option>


                                <%
                                    if (services != null) {

                                        for (DentalService service : services) {
                                %>

                                <option
                                    value="<%= service.getServiceId() %>">

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

                            </select>

                        </div>


                        <!-- ==============================
                             Dentist
                             ============================== -->

                        <div class="form-group">

                            <label>
                                Dentist *
                            </label>

                            <select
                                name="dentistId"
                                required>

                                <option value="">

                                    Select Dentist

                                </option>


                                <%
                                    if (dentists != null) {

                                        for (Dentist dentist : dentists) {
                                %>

                                <option
                                    value="<%= dentist.getDentistId() %>">

                                    Dr.
                                    <%= dentist.getFullName() %>


                                    <%
                                        if (
                                            dentist.getSpecialization()
                                                    != null
                                            &&
                                            !dentist
                                                .getSpecialization()
                                                .trim()
                                                .isEmpty()
                                        ) {
                                    %>

                                    -

                                    <%= dentist.getSpecialization() %>

                                    <%
                                        }
                                    %>

                                </option>

                                <%
                                        }
                                    }
                                %>

                            </select>

                        </div>


                        <!-- ==============================
                             Appointment Date
                             ============================== -->

                        <div class="form-group">

                            <label>
                                Preferred Date *
                            </label>

                            <input
                                type="date"
                                name="appointmentDate"
                                required>

                        </div>


                        <!-- ==============================
                             Appointment Time
                             ============================== -->

                        <div class="form-group">

                            <label>
                                Preferred Time *
                            </label>

                            <input
                                type="time"
                                name="appointmentTime"
                                required>

                        </div>


                        <!-- ==============================
                             Reason
                             ============================== -->

                        <div class="form-group full">

                            <label>
                                Reason / Notes
                            </label>

                            <textarea
                                name="reason"
                                maxlength="255"
                                placeholder="Describe your dental problem or reason for appointment"></textarea>

                        </div>

                    </div>


                    <!-- Submit -->

                    <button
                        type="submit"
                        class="submit-btn">

                        Submit Appointment Request

                    </button>

                </form>

            </div>

        </div>

    </main>

</div>

</body>
</html>