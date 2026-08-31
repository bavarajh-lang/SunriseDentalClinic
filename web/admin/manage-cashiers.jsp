<%@page import="java.util.List"%>
<%@page import="model.Cashier"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Cashier> cashiers =
            (List<Cashier>) request.getAttribute("cashiers");

    Boolean activeCashierExistsValue =
            (Boolean) request.getAttribute("activeCashierExists");

    boolean activeCashierExists =
            activeCashierExistsValue != null
            && activeCashierExistsValue;

    String cashierPageError =
            (String) request.getAttribute("cashierPageError");

    String cashierSuccess =
            (String) session.getAttribute("cashierSuccess");

    String cashierError =
            (String) session.getAttribute("cashierError");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Manage Cashiers | Sunrise Dental Clinic
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
            font-weight: bold;
            text-decoration: none;
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

        .current-cashier {
            background: #eff8ff;
            border: 1px solid #bae6fd;
            border-left: 5px solid #0f5f87;
            padding: 18px;
            border-radius: 9px;
            margin-bottom: 25px;
        }

        .current-cashier h3 {
            color: #0f5f87;
            margin-bottom: 7px;
        }

        .current-cashier p {
            color: #475569;
            font-size: 13px;
            line-height: 1.6;
        }

        .no-active-cashier {
            background: #fff7ed;
            border: 1px solid #fdba74;
            border-left: 5px solid #f97316;
        }

        .no-active-cashier h3 {
            color: #9a3412;
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

        .active-warning {
            background: #fff7ed;
            border: 1px solid #fdba74;
            color: #9a3412;
            padding: 13px;
            border-radius: 7px;
            margin-bottom: 18px;
            font-size: 13px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            color: #374151;
            font-size: 13px;
            font-weight: bold;
            margin-bottom: 7px;
        }

        .required {
            color: #dc2626;
        }

        .form-group input {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font-size: 14px;
            outline: none;
            background: white;
        }

        .form-group input:focus {
            border-color: #0f5f87;
            box-shadow: 0 0 0 3px rgba(15,95,135,0.10);
        }

        .form-group input:disabled {
            background: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
        }

        .form-help {
            margin-top: 5px;
            color: #6b7280;
            font-size: 11px;
            line-height: 1.4;
        }

        .btn-primary {
            width: 100%;
            border: none;
            background: #0f5f87;
            color: white;
            padding: 12px 18px;
            border-radius: 7px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-primary:hover {
            background: #0b4f71;
        }

        .btn-primary:disabled {
            background: #9ca3af;
            cursor: not-allowed;
        }

        .summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 20px;
        }

        .summary-box {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            padding: 15px;
            border-radius: 8px;
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
            min-width: 700px;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 12px;
            background: #eef7fb;
            color: #374151;
            font-size: 12px;
            border-bottom: 1px solid #dce5ea;
        }

        td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
            font-size: 13px;
        }

        .cashier-name {
            font-weight: bold;
            color: #1f2937;
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

        .btn {
            border: none;
            padding: 7px 11px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: bold;
            cursor: pointer;
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

        .btn:disabled {
            background: #e5e7eb;
            color: #9ca3af;
            cursor: not-allowed;
        }

        .action-note {
            color: #9ca3af;
            font-size: 10px;
            margin-top: 5px;
            max-width: 130px;
            line-height: 1.4;
        }

        .empty-state {
            text-align: center;
            padding: 45px 20px;
        }

        .empty-state h3 {
            color: #0f5f87;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #6b7280;
            line-height: 1.5;
        }

        @media(max-width: 1100px) {

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

            .topbar {
                padding: 16px 20px;
            }

            .summary {
                grid-template-columns: 1fr;
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

            <a href="<%= request.getContextPath() %>/admin/ManageAssistants">
                Manage Assistants
            </a>

            <a href="<%= request.getContextPath() %>/admin/ManageCashiers"
               class="active">
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
                    Manage Cashiers
                </h1>

                <p>
                    Create and manage cashier accounts responsible
                    for processing patient payments and issuing receipts.
                </p>

            </div>

            <%
                if (cashierSuccess != null) {
            %>

            <div class="success-message">

                <strong>
                    Success!
                </strong>

                <br>

                <%= cashierSuccess %>

            </div>

            <%
                    session.removeAttribute("cashierSuccess");
                }
            %>

            <%
                if (cashierError != null) {
            %>

            <div class="error-message">

                <strong>
                    Unable to Complete Request
                </strong>

                <br>

                <%= cashierError %>

            </div>

            <%
                    session.removeAttribute("cashierError");
                }
            %>

            <%
                if (cashierPageError != null) {
            %>

            <div class="error-message">
                <%= cashierPageError %>
            </div>

            <%
                }
            %>

            <%
                if (activeCashierExists) {
            %>

            <div class="current-cashier">

                <h3>
                    Active Cashier Available
                </h3>

                <p>
                    The clinic currently has an active cashier.
                    Deactivate the current cashier before creating
                    or activating another cashier account.
                </p>

            </div>

            <%
                } else {
            %>

            <div class="current-cashier no-active-cashier">

                <h3>
                    No Active Cashier
                </h3>

                <p>
                    There is currently no active cashier.
                    You can create a new cashier or reactivate
                    one of the existing inactive cashier accounts.
                </p>

            </div>

            <%
                }
            %>

            <div class="grid">

                <div class="card">

                    <div class="card-title">

                        <h2>
                            Add New Cashier
                        </h2>

                        <p>
                            Create a login account for the clinic cashier.
                            Only one cashier can be active at a time.
                        </p>

                    </div>

                    <%
                        if (activeCashierExists) {
                    %>

                    <div class="active-warning">

                        <strong>
                            New cashier creation is currently disabled.
                        </strong>

                        <br>

                        Deactivate the current active cashier first.

                    </div>

                    <%
                        }
                    %>

                    <form action="<%= request.getContextPath() %>/admin/AddCashierServlet"
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
                                   <%= activeCashierExists ? "disabled" : "" %>>

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
                                   <%= activeCashierExists ? "disabled" : "" %>>

                            <div class="form-help">
                                The cashier will use this username to login.
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
                                   <%= activeCashierExists ? "disabled" : "" %>>

                        </div>

                        <div class="form-group">

                            <label>
                                Phone
                            </label>

                            <input type="text"
                                   name="phone"
                                   maxlength="20"
                                   <%= activeCashierExists ? "disabled" : "" %>>

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
                                   <%= activeCashierExists ? "disabled" : "" %>>

                        </div>

                        <button type="submit"
                                class="btn-primary"
                                <%= activeCashierExists ? "disabled" : "" %>>

                            Create Cashier Account

                        </button>

                    </form>

                </div>

                <div class="card">

                    <div class="card-title">

                        <h2>
                            Cashier Accounts
                        </h2>

                        <p>
                            View current and previous cashier accounts
                            and manage their access status.
                        </p>

                    </div>

                    <%
                        int totalCashiers = 0;
                        int activeCashiers = 0;
                        int inactiveCashiers = 0;

                        if (cashiers != null) {

                            totalCashiers = cashiers.size();

                            for (Cashier cashier : cashiers) {

                                if ("ACTIVE".equals(
                                        cashier.getStatus())) {

                                    activeCashiers++;

                                } else if ("INACTIVE".equals(
                                        cashier.getStatus())) {

                                    inactiveCashiers++;
                                }
                            }
                        }
                    %>

                    <div class="summary">

                        <div class="summary-box">

                            <div class="summary-label">
                                Total Cashiers
                            </div>

                            <div class="summary-value">
                                <%= totalCashiers %>
                            </div>

                        </div>

                        <div class="summary-box">

                            <div class="summary-label">
                                Active
                            </div>

                            <div class="summary-value">
                                <%= activeCashiers %>
                            </div>

                        </div>

                        <div class="summary-box">

                            <div class="summary-label">
                                Inactive
                            </div>

                            <div class="summary-value">
                                <%= inactiveCashiers %>
                            </div>

                        </div>

                    </div>

                    <%
                        if (cashiers != null
                                && !cashiers.isEmpty()) {
                    %>

                    <div class="table-wrapper">

                        <table>

                            <thead>

                                <tr>

                                    <th>
                                        Cashier
                                    </th>

                                    <th>
                                        Username
                                    </th>

                                    <th>
                                        Contact
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
                                    for (Cashier cashier : cashiers) {
                                %>

                                <tr>

                                    <td>

                                        <div class="cashier-name">
                                            <%= cashier.getFullName() %>
                                        </div>

                                        <div class="small-text">

                                            User ID:
                                            <%= cashier.getUserId() %>

                                        </div>

                                    </td>

                                    <td>

                                        <strong>
                                            <%= cashier.getUsername() %>
                                        </strong>

                                    </td>

                                    <td>

                                        <div class="small-text">

                                            <%= cashier.getEmail() %>

                                            <%
                                                if (cashier.getPhone() != null
                                                        && !cashier.getPhone()
                                                        .trim()
                                                        .isEmpty()) {
                                            %>

                                            <br>

                                            <%= cashier.getPhone() %>

                                            <%
                                                }
                                            %>

                                        </div>

                                    </td>

                                    <td>

                                        <%
                                            if ("ACTIVE".equals(
                                                    cashier.getStatus())) {
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
                                                    cashier.getStatus())) {
                                        %>

                                        <form action="<%= request.getContextPath() %>/admin/UpdateCashierStatusServlet"
                                              method="post">

                                            <input type="hidden"
                                                   name="userId"
                                                   value="<%= cashier.getUserId() %>">

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

                                                if (!activeCashierExists) {
                                        %>

                                        <form action="<%= request.getContextPath() %>/admin/UpdateCashierStatusServlet"
                                              method="post">

                                            <input type="hidden"
                                                   name="userId"
                                                   value="<%= cashier.getUserId() %>">

                                            <input type="hidden"
                                                   name="status"
                                                   value="ACTIVE">

                                            <button type="submit"
                                                    class="btn btn-enable">

                                                Activate

                                            </button>

                                        </form>

                                        <%
                                                } else {
                                        %>

                                        <button type="button"
                                                class="btn"
                                                disabled>

                                            Activate

                                        </button>

                                        <div class="action-note">
                                            Deactivate current cashier first.
                                        </div>

                                        <%
                                                }
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
                            No Cashier Accounts
                        </h3>

                        <p>
                            Create the first cashier account using
                            the form on this page.
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