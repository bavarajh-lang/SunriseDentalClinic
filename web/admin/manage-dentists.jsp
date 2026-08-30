<%@page import="java.util.List"%>
<%@page import="model.Dentist"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");

    String dentistSuccess =
            (String) session.getAttribute("dentistSuccess");

    String dentistError =
            (String) session.getAttribute("dentistError");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Manage Dentists | Sunrise Dental Clinic
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

        /* =============================
           SIDEBAR
           ============================= */

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
            color: white;
            text-decoration: none;
            padding: 12px 14px;
            margin-bottom: 8px;
            border-radius: 6px;
        }

        .menu a:hover,
        .menu .active {
            background: rgba(255,255,255,0.18);
        }

        /* =============================
           MAIN
           ============================= */

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

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 6px;
        }

        .page-title p {
            color: #6b7280;
        }

        /* =============================
           MESSAGE BOXES
           ============================= */

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

        /* =============================
           ADD DENTIST FORM
           ============================= */

        .form-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);
        }

        .form-card h2 {
            color: #0f5f87;
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
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
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 7px;
            color: #374151;
        }

        input {
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font-size: 14px;
            outline: none;
        }

        input:focus {
            border-color: #0f6f9c;
        }

        .add-btn {
            margin-top: 20px;
            background: #0f6f9c;
            color: white;
            border: none;
            padding: 12px 22px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
        }

        .add-btn:hover {
            background: #0c5d82;
        }

        /* =============================
           TABLE
           ============================= */

        .table-card {
            background: white;
            border-radius: 12px;
            padding: 25px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .table-header h2 {
            color: #0f5f87;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }

        th {
            background: #eef7fb;
            color: #374151;
            text-align: left;
            padding: 13px;
            font-size: 13px;
            border-bottom: 1px solid #dbe4ea;
        }

        td {
            padding: 14px 13px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
            vertical-align: middle;
        }

        tr:hover {
            background: #f9fafb;
        }

        .dentist-number {
            font-weight: bold;
            color: #0f5f87;
        }

        /* =============================
           STATUS BADGES
           ============================= */

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
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

        /* =============================
           ACTION BUTTONS
           ============================= */

        .status-form {
            display: inline;
        }

        .deactivate-btn,
        .activate-btn {
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .deactivate-btn {
            background: #fee2e2;
            color: #991b1b;
        }

        .deactivate-btn:hover {
            background: #fecaca;
        }

        .activate-btn {
            background: #dcfce7;
            color: #166534;
        }

        .activate-btn:hover {
            background: #bbf7d0;
        }

        /* =============================
           EMPTY STATE
           ============================= */

        .empty-state {
            background: #f9fafb;
            color: #6b7280;
            text-align: center;
            padding: 35px;
            border-radius: 8px;
        }

        /* =============================
           RESPONSIVE
           ============================= */

        @media(max-width: 850px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }
        }

        @media(max-width: 700px) {

            .sidebar {
                display: none;
            }

            .content {
                padding: 20px;
            }
        }

    </style>

</head>

<body>

<div class="layout">

    <!-- =============================
         SIDEBAR
         ============================= -->

    <aside class="sidebar">

        <div class="logo">
            Sunrise Dental
        </div>

        <nav class="menu">

            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageDentists"
               class="active">
                Manage Dentists
            </a>

            <a href="manage-assistants.jsp">
                Manage Assistants
            </a>

            <a href="manage-cashiers.jsp">
                Manage Cashiers
            </a>

            <a href="patients.jsp">
                Patients
            </a>

            <a href="appointments.jsp">
                Appointments
            </a>

            <a href="payments.jsp">
                Payments
            </a>

            <a href="reports.jsp">
                Reports
            </a>

            <a href="audit-logs.jsp">
                Audit Logs
            </a>

        </nav>

    </aside>


    <!-- =============================
         MAIN
         ============================= -->

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
                    Manage Dentists
                </h1>

                <p>
                    Add dentists and manage their availability
                    in Sunrise Dental Clinic.
                </p>

            </div>


            <!-- =============================
                 SUCCESS MESSAGE
                 ============================= -->

            <%
                if (dentistSuccess != null) {
            %>

            <div class="success-message">

                <strong>Success!</strong>

                <br>

                <%= dentistSuccess %>

            </div>

            <%
                    session.removeAttribute("dentistSuccess");
                }
            %>


            <!-- =============================
                 ERROR MESSAGE
                 ============================= -->

            <%
                if (dentistError != null) {
            %>

            <div class="error-message">

                <strong>Error!</strong>

                <br>

                <%= dentistError %>

            </div>

            <%
                    session.removeAttribute("dentistError");
                }
            %>


            <!-- =============================
                 ADD DENTIST
                 ============================= -->

            <section class="form-card">

                <h2>
                    Add New Dentist
                </h2>

                <form
                    action="<%= request.getContextPath() %>/admin/AddDentistServlet"
                    method="post">

                    <div class="form-grid">


                        <!-- Full Name -->

                        <div class="form-group">

                            <label>
                                Dentist Full Name *
                            </label>

                            <input
                                type="text"
                                name="fullName"
                                maxlength="100"
                                placeholder="Example: Nimal Perera"
                                required>

                        </div>


                        <!-- Specialization -->

                        <div class="form-group">

                            <label>
                                Specialization
                            </label>

                            <input
                                type="text"
                                name="specialization"
                                maxlength="100"
                                placeholder="Example: Orthodontics">

                        </div>


                        <!-- Phone -->

                        <div class="form-group">

                            <label>
                                Phone Number
                            </label>

                            <input
                                type="tel"
                                name="phone"
                                maxlength="20"
                                placeholder="Example: 0771234567">

                        </div>


                        <!-- Email -->

                        <div class="form-group">

                            <label>
                                Email
                            </label>

                            <input
                                type="email"
                                name="email"
                                maxlength="100"
                                placeholder="dentist@example.com">

                        </div>


                        <!-- Consultation Fee -->

                        <div class="form-group">

                            <label>
                                Consultation Fee (Rs.)
                            </label>

                            <input
                                type="number"
                                name="consultationFee"
                                min="0"
                                step="0.01"
                                placeholder="Example: 2500.00">

                        </div>

                    </div>


                    <button
                        type="submit"
                        class="add-btn">

                        Add Dentist

                    </button>

                </form>

            </section>


            <!-- =============================
                 DENTIST LIST
                 ============================= -->

            <section class="table-card">

                <div class="table-header">

                    <h2>
                        Dentist List
                    </h2>

                </div>


                <%
                    if (dentists != null
                            && !dentists.isEmpty()) {
                %>


                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Dentist No
                                </th>

                                <th>
                                    Name
                                </th>

                                <th>
                                    Specialization
                                </th>

                                <th>
                                    Phone
                                </th>

                                <th>
                                    Email
                                </th>

                                <th>
                                    Consultation Fee
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Action
                                </th>

                            </tr>

                        </thead>


                        <tbody>

                        <%
                            for (Dentist dentist : dentists) {
                        %>

                            <tr>

                                <!-- Dentist Number -->

                                <td class="dentist-number">

                                    <%= dentist.getDentistNo() %>

                                </td>


                                <!-- Name -->

                                <td>

                                    Dr.
                                    <%= dentist.getFullName() %>

                                </td>


                                <!-- Specialization -->

                                <td>

                                    <%
                                        if (dentist.getSpecialization()
                                                != null
                                                &&
                                            !dentist
                                                .getSpecialization()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                        <%= dentist.getSpecialization() %>

                                    <%
                                        } else {
                                    %>

                                        -

                                    <%
                                        }
                                    %>

                                </td>


                                <!-- Phone -->

                                <td>

                                    <%
                                        if (dentist.getPhone()
                                                != null
                                                &&
                                            !dentist
                                                .getPhone()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                        <%= dentist.getPhone() %>

                                    <%
                                        } else {
                                    %>

                                        -

                                    <%
                                        }
                                    %>

                                </td>


                                <!-- Email -->

                                <td>

                                    <%
                                        if (dentist.getEmail()
                                                != null
                                                &&
                                            !dentist
                                                .getEmail()
                                                .trim()
                                                .isEmpty()) {
                                    %>

                                        <%= dentist.getEmail() %>

                                    <%
                                        } else {
                                    %>

                                        -

                                    <%
                                        }
                                    %>

                                </td>


                                <!-- Consultation Fee -->

                                <td>

                                    Rs.
                                    <%= String.format(
                                            "%.2f",
                                            dentist.getConsultationFee()
                                    ) %>

                                </td>


                                <!-- Status -->

                                <td>

                                    <%
                                        if ("ACTIVE".equals(
                                                dentist.getStatus())) {
                                    %>

                                    <span class="status status-active">
                                        ACTIVE
                                    </span>

                                    <%
                                        } else {
                                    %>

                                    <span class="status status-inactive">
                                        INACTIVE
                                    </span>

                                    <%
                                        }
                                    %>

                                </td>


                                <!-- Action -->

                                <td>

                                    <form
                                        class="status-form"
                                        action="<%= request.getContextPath() %>/admin/UpdateDentistStatusServlet"
                                        method="post">

                                        <input
                                            type="hidden"
                                            name="dentistId"
                                            value="<%= dentist.getDentistId() %>">


                                        <%
                                            if ("ACTIVE".equals(
                                                    dentist.getStatus())) {
                                        %>

                                        <input
                                            type="hidden"
                                            name="status"
                                            value="INACTIVE">

                                        <button
                                            type="submit"
                                            class="deactivate-btn">

                                            Deactivate

                                        </button>

                                        <%
                                            } else {
                                        %>

                                        <input
                                            type="hidden"
                                            name="status"
                                            value="ACTIVE">

                                        <button
                                            type="submit"
                                            class="activate-btn">

                                            Activate

                                        </button>

                                        <%
                                            }
                                        %>

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

                    No dentists have been added yet.

                    <br><br>

                    Use the form above to add the first dentist.

                </div>


                <%
                    }
                %>


            </section>

        </div>

    </main>

</div>

</body>

</html>