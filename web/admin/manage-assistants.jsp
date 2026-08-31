<%@page import="java.util.List"%>
<%@page import="model.Assistant"%>
<%@page import="model.Dentist"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Assistant> assistants =
            (List<Assistant>) request.getAttribute("assistants");

    List<Dentist> unassignedDentists =
            (List<Dentist>) request.getAttribute("unassignedDentists");

    String assistantPageError =
            (String) request.getAttribute("assistantPageError");

    String assistantSuccess =
            (String) session.getAttribute("assistantSuccess");

    String assistantError =
            (String) session.getAttribute("assistantError");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Manage Assistants | Sunrise Dental Clinic
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
            width: 100%;
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
            margin-bottom: 7px;
            font-size: 32px;
        }

        .page-header p {
            color: #6b7280;
            line-height: 1.6;
        }

        .success-message {
            background: #ecfdf3;
            border: 1px solid #86efac;
            color: #166534;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .grid {
            display: grid;
            grid-template-columns: 370px minmax(0, 1fr);
            gap: 25px;
            align-items: start;
            width: 100%;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            min-width: 0;
        }

        .card-title {
            margin-bottom: 20px;
        }

        .card-title h2 {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 6px;
        }

        .card-title p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            margin-bottom: 7px;
            color: #374151;
        }

        .required {
            color: #dc2626;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            outline: none;
            font-size: 14px;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #0f5f87;
            box-shadow: 0 0 0 3px rgba(15,95,135,0.10);
        }

        .form-group select:disabled,
        .form-group input:disabled {
            background: #f3f4f6;
            cursor: not-allowed;
        }

        .form-help {
            font-size: 11px;
            color: #6b7280;
            margin-top: 5px;
            line-height: 1.4;
        }

        .btn-primary {
            width: 100%;
            border: none;
            background: #0f5f87;
            color: white;
            padding: 12px 18px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
        }

        .btn-primary:hover {
            background: #0b4f71;
        }

        .btn-primary:disabled {
            background: #9ca3af;
            cursor: not-allowed;
        }

        .no-dentist {
            background: #fff7ed;
            border: 1px solid #fdba74;
            color: #9a3412;
            padding: 13px;
            border-radius: 7px;
            margin-bottom: 18px;
            font-size: 13px;
            line-height: 1.5;
        }

        .summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 20px;
        }

        .summary-box {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }

        .summary-label {
            color: #6b7280;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 7px;
        }

        .summary-value {
            color: #0f5f87;
            font-size: 22px;
            font-weight: bold;
        }

        .table-wrapper {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 800px;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            background: #eef7fb;
            color: #374151;
            padding: 12px;
            font-size: 12px;
            border-bottom: 1px solid #dce5ea;
        }

        td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
            vertical-align: middle;
        }

        .assistant-name {
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 4px;
        }

        .assistant-no {
            color: #6b7280;
            font-size: 11px;
        }

        .dentist-name {
            color: #0f5f87;
            font-weight: bold;
            margin-bottom: 4px;
        }

        .small-text {
            color: #6b7280;
            font-size: 11px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: bold;
        }

        .active-badge {
            background: #dcfce7;
            color: #166534;
        }

        .inactive-badge {
            background: #fee2e2;
            color: #991b1b;
        }

        .unassigned-badge {
            background: #fef3c7;
            color: #92400e;
        }

        .btn {
            border: none;
            padding: 7px 11px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 11px;
        }

        .btn-disable {
            background: #fee2e2;
            color: #991b1b;
        }

        .btn-disable:hover {
            background: #fecaca;
        }

        .btn-enable {
            background: #dcfce7;
            color: #166534;
        }

        .btn-enable:hover {
            background: #bbf7d0;
        }

        .empty-state {
            text-align: center;
            padding: 45px 20px;
            color: #6b7280;
        }

        .empty-state h3 {
            color: #0f5f87;
            margin-bottom: 8px;
        }

        @media(max-width: 1150px) {

            .grid {
                grid-template-columns: 1fr;
            }
        }

        @media(max-width: 750px) {

            .sidebar {
                display: none;
            }

            .content {
                padding: 20px;
            }

            .summary {
                grid-template-columns: 1fr;
            }

            .topbar {
                padding: 16px 20px;
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

            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageDentists">
                Manage Dentists
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageAssistants"
               class="active">
                Manage Assistants
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageCashiers">
                Manage Cashiers
            </a>

            <a href="<%= request.getContextPath() %>/admin/patients.jsp">
                Patients
            </a>

            <a href="<%= request.getContextPath() %>/admin/appointments.jsp">
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

                <h1>
                    Manage Dentist Assistants
                </h1>

                <p>
                    Create assistant accounts, assign each assistant
                    to one dentist and manage assistant account status.
                </p>

            </div>

            <%
                if (assistantSuccess != null) {
            %>

            <div class="success-message">

                <strong>
                    Success!
                </strong>

                <br>

                <%= assistantSuccess %>

            </div>

            <%
                    session.removeAttribute("assistantSuccess");
                }
            %>

            <%
                if (assistantError != null) {
            %>

            <div class="error-message">

                <strong>
                    Unable to Complete Request
                </strong>

                <br>

                <%= assistantError %>

            </div>

            <%
                    session.removeAttribute("assistantError");
                }
            %>

            <%
                if (assistantPageError != null) {
            %>

            <div class="error-message">
                <%= assistantPageError %>
            </div>

            <%
                }
            %>

            <div class="grid">

                <div class="card">

                    <div class="card-title">

                        <h2>
                            Add New Assistant
                        </h2>

                        <p>
                            Create an assistant login account and assign
                            the assistant to an available dentist.
                        </p>

                    </div>

                    <%
                        boolean dentistAvailable =
                                unassignedDentists != null
                                && !unassignedDentists.isEmpty();

                        if (!dentistAvailable) {
                    %>

                    <div class="no-dentist">

                        <strong>
                            No unassigned dentists available.
                        </strong>

                        <br>

                        Every active dentist currently has an assistant.
                        Add a new dentist first if another assistant
                        assignment is required.

                    </div>

                    <%
                        }
                    %>

                    <form action="<%= request.getContextPath() %>/admin/AddAssistantServlet"
                          method="post">

                        <div class="form-group">

                            <label>
                                Full Name
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   name="fullName"
                                   maxlength="100"
                                   required
                                   <%= !dentistAvailable ? "disabled" : "" %>>

                        </div>

                        <div class="form-group">

                            <label>
                                Username
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   name="username"
                                   maxlength="50"
                                   autocomplete="off"
                                   required
                                   <%= !dentistAvailable ? "disabled" : "" %>>

                            <div class="form-help">
                                This username will be used for assistant login.
                            </div>

                        </div>

                        <div class="form-group">

                            <label>
                                Email
                                <span class="required">*</span>
                            </label>

                            <input type="email"
                                   name="email"
                                   maxlength="100"
                                   required
                                   <%= !dentistAvailable ? "disabled" : "" %>>

                        </div>

                        <div class="form-group">

                            <label>
                                Phone
                            </label>

                            <input type="text"
                                   name="phone"
                                   maxlength="20"
                                   <%= !dentistAvailable ? "disabled" : "" %>>

                        </div>

                        <div class="form-group">

                            <label>
                                Login Password
                                <span class="required">*</span>
                            </label>

                            <input type="password"
                                   name="password"
                                   minlength="3"
                                   maxlength="100"
                                   required
                                   <%= !dentistAvailable ? "disabled" : "" %>>

                        </div>

                        <div class="form-group">

                            <label>
                                Assign Dentist
                                <span class="required">*</span>
                            </label>

                            <select name="dentistId"
                                    required
                                    <%= !dentistAvailable ? "disabled" : "" %>>

                                <option value="">
                                    Select Dentist
                                </option>

                                <%
                                    if (unassignedDentists != null) {

                                        for (Dentist dentist
                                                : unassignedDentists) {
                                %>

                                <option value="<%= dentist.getDentistId() %>">

                                    <%= dentist.getDentistNo() %>
                                    -
                                    Dr. <%= dentist.getFullName() %>

                                    <%
                                        if (dentist.getSpecialization() != null
                                                && !dentist.getSpecialization()
                                                .trim()
                                                .isEmpty()) {
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

                            <div class="form-help">
                                Only active dentists without an assigned
                                assistant are displayed.
                            </div>

                        </div>

                        <button type="submit"
                                class="btn-primary"
                                <%= !dentistAvailable ? "disabled" : "" %>>

                            Create & Assign Assistant

                        </button>

                    </form>

                </div>

                <div class="card">

                    <div class="card-title">

                        <h2>
                            Existing Assistants
                        </h2>

                        <p>
                            View assistant accounts and their current
                            dentist assignments.
                        </p>

                    </div>

                    <%
                        int totalAssistants = 0;
                        int activeAssistants = 0;
                        int inactiveAssistants = 0;

                        if (assistants != null) {

                            totalAssistants = assistants.size();

                            for (Assistant assistant : assistants) {

                                if ("ACTIVE".equals(
                                        assistant.getStatus())) {

                                    activeAssistants++;

                                } else if ("INACTIVE".equals(
                                        assistant.getStatus())) {

                                    inactiveAssistants++;
                                }
                            }
                        }
                    %>

                    <div class="summary">

                        <div class="summary-box">

                            <div class="summary-label">
                                Total Assistants
                            </div>

                            <div class="summary-value">
                                <%= totalAssistants %>
                            </div>

                        </div>

                        <div class="summary-box">

                            <div class="summary-label">
                                Active
                            </div>

                            <div class="summary-value">
                                <%= activeAssistants %>
                            </div>

                        </div>

                        <div class="summary-box">

                            <div class="summary-label">
                                Inactive
                            </div>

                            <div class="summary-value">
                                <%= inactiveAssistants %>
                            </div>

                        </div>

                    </div>

                    <%
                        if (assistants != null
                                && !assistants.isEmpty()) {
                    %>

                    <div class="table-wrapper">

                        <table>

                            <thead>

                                <tr>

                                    <th>
                                        Assistant
                                    </th>

                                    <th>
                                        Login Details
                                    </th>

                                    <th>
                                        Assigned Dentist
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
                                    for (Assistant assistant : assistants) {
                                %>

                                <tr>

                                    <td>

                                        <div class="assistant-name">
                                            <%= assistant.getFullName() %>
                                        </div>

                                        <div class="assistant-no">

                                            <%
                                                if (assistant.getAssistantNo()
                                                        != null) {
                                            %>

                                            <%= assistant.getAssistantNo() %>

                                            <%
                                                } else {
                                            %>

                                            No Assistant Number

                                            <%
                                                }
                                            %>

                                        </div>

                                    </td>

                                    <td>

                                        <strong>
                                            <%= assistant.getUsername() %>
                                        </strong>

                                        <div class="small-text">

                                            <%= assistant.getEmail() %>

                                            <%
                                                if (assistant.getPhone()
                                                        != null
                                                        && !assistant.getPhone()
                                                        .trim()
                                                        .isEmpty()) {
                                            %>

                                            <br>

                                            <%= assistant.getPhone() %>

                                            <%
                                                }
                                            %>

                                        </div>

                                    </td>

                                    <td>

                                        <%
                                            if (assistant.getDentistName()
                                                    != null) {
                                        %>

                                        <div class="dentist-name">

                                            Dr.
                                            <%= assistant.getDentistName() %>

                                        </div>

                                        <div class="small-text">

                                            <%= assistant.getDentistNo() %>

                                            <%
                                                if (assistant
                                                        .getDentistSpecialization()
                                                        != null
                                                        && !assistant
                                                        .getDentistSpecialization()
                                                        .trim()
                                                        .isEmpty()) {
                                            %>

                                            <br>

                                            <%= assistant
                                                    .getDentistSpecialization() %>

                                            <%
                                                }
                                            %>

                                        </div>

                                        <%
                                            } else {
                                        %>

                                        <span class="badge unassigned-badge">
                                            UNASSIGNED
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>

                                    <td>

                                        <%
                                            if ("ACTIVE".equals(
                                                    assistant.getStatus())) {
                                        %>

                                        <span class="badge active-badge">
                                            ACTIVE
                                        </span>

                                        <%
                                            } else {
                                        %>

                                        <span class="badge inactive-badge">
                                            INACTIVE
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>

                                    <td>

                                        <%
                                            if ("ACTIVE".equals(
                                                    assistant.getStatus())) {
                                        %>

                                        <form action="<%= request.getContextPath() %>/admin/UpdateAssistantStatusServlet"
                                              method="post">

                                            <input type="hidden"
                                                   name="userId"
                                                   value="<%= assistant.getUserId() %>">

                                            <input type="hidden"
                                                   name="status"
                                                   value="INACTIVE">

                                            <button type="submit"
                                                    class="btn btn-disable">

                                                Deactivate

                                            </button>

                                        </form>

                                        <%
                                            } else {
                                        %>

                                        <form action="<%= request.getContextPath() %>/admin/UpdateAssistantStatusServlet"
                                              method="post">

                                            <input type="hidden"
                                                   name="userId"
                                                   value="<%= assistant.getUserId() %>">

                                            <input type="hidden"
                                                   name="status"
                                                   value="ACTIVE">

                                            <button type="submit"
                                                    class="btn btn-enable">

                                                Activate

                                            </button>

                                        </form>

                                        <%
                                            }
                                        %>

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
                            No Assistants Found
                        </h3>

                        <p>
                            No dentist assistant accounts are currently
                            available in the system.
                        </p>

                    </div>

                    <%
                        }
                    %>

                </div>

            </div>

        </div>

    </main>

</div>

</body>

</html>