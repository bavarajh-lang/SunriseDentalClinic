<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.AdminAuditLog"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (request.getAttribute("logs") == null
            && request.getAttribute("auditError") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/AuditLogs"
        );

        return;
    }

    List<AdminAuditLog> logs =
            (List<AdminAuditLog>) request.getAttribute(
                    "logs"
            );

    Integer totalLogsValue =
            (Integer) request.getAttribute(
                    "totalLogs"
            );

    Integer todayLogsValue =
            (Integer) request.getAttribute(
                    "todayLogs"
            );

    Integer activeUsersValue =
            (Integer) request.getAttribute(
                    "activeUsers"
            );

    String search =
            (String) request.getAttribute(
                    "search"
            );

    String selectedEntityType =
            (String) request.getAttribute(
                    "selectedEntityType"
            );

    String selectedDate =
            (String) request.getAttribute(
                    "selectedDate"
            );

    String auditError =
            (String) request.getAttribute(
                    "auditError"
            );

    int totalLogs =
            totalLogsValue != null
            ? totalLogsValue
            : 0;

    int todayLogs =
            todayLogsValue != null
            ? todayLogsValue
            : 0;

    int activeUsers =
            activeUsersValue != null
            ? activeUsersValue
            : 0;

    if (search == null) {
        search = "";
    }

    if (selectedEntityType == null) {
        selectedEntityType = "";
    }

    if (selectedDate == null) {
        selectedDate = "";
    }

    int displayedLogs =
            logs != null
            ? logs.size()
            : 0;

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
        Audit Logs | Sunrise Dental Clinic
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
            letter-spacing: .8px;
            margin-bottom: 35px;
        }

        .menu a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 12px 14px;
            margin-bottom: 7px;
            border-radius: 6px;
        }

        .menu a:hover,
        .menu .active {
            background: rgba(255,255,255,.18);
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
            box-shadow: 0 2px 10px rgba(0,0,0,.06);
        }

        .logout {
            color: #b91c1c;
            text-decoration: none;
            font-weight: bold;
        }

        .content {
            padding: 30px;
        }

        h1 {
            color: #0f5f87;
            margin-bottom: 6px;
        }

        .subtitle {
            color: #6b7280;
            margin-bottom: 25px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,.06);
        }

        .card h3 {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .card strong {
            color: #0f5f87;
            font-size: 28px;
        }

        .filter-card,
        .logs-card {
            background: white;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,.06);
            margin-bottom: 25px;
        }

        .filter-card h2,
        .logs-card h2 {
            color: #0f5f87;
            margin-bottom: 18px;
        }

        .filters {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto auto;
            gap: 12px;
            align-items: end;
        }

        label {
            display: block;
            font-size: 11px;
            font-weight: bold;
            color: #4b5563;
            margin-bottom: 6px;
        }

        input {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
        }

        .button {
            padding: 11px 16px;
            border-radius: 7px;
            border: none;
            background: #0f5f87;
            color: white;
            cursor: pointer;
            font-weight: bold;
        }

        .clear {
            padding: 11px 16px;
            border-radius: 7px;
            background: #e5e7eb;
            color: #374151;
            text-decoration: none;
            font-weight: bold;
            text-align: center;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1150px;
            border-collapse: collapse;
        }

        th {
            background: #eef7fb;
            padding: 13px 12px;
            text-align: left;
            font-size: 11px;
        }

        td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 12px;
        }

        .action {
            font-weight: bold;
            color: #0f5f87;
        }

        .sub {
            color: #6b7280;
            font-size: 10px;
            margin-top: 3px;
        }

        .badge {
            display: inline-block;
            background: #eef7fb;
            color: #0f5f87;
            padding: 6px 9px;
            border-radius: 15px;
            font-size: 9px;
            font-weight: bold;
        }

        .error {
            background: #fef2f2;
            color: #991b1b;
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .empty {
            text-align: center;
            color: #6b7280;
            padding: 45px 20px;
        }

        @media(max-width:1100px) {

            .stats {
                grid-template-columns: repeat(2,1fr);
            }

            .filters {
                grid-template-columns: repeat(2,1fr);
            }
        }

        @media(max-width:750px) {

            .sidebar {
                display: none;
            }

            .stats,
            .filters {
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

            <a href="<%= request.getContextPath() %>/admin/Patients">
                Patients
            </a>

            <a href="<%= request.getContextPath() %>/admin/Appointments">
                Appointments
            </a>

            <a href="<%= request.getContextPath() %>/admin/Payments">
                Payments
            </a>

            <a href="<%= request.getContextPath() %>/admin/Reports">
                Reports
            </a>

            <a class="active"
               href="<%= request.getContextPath() %>/admin/AuditLogs">
                Audit Logs
            </a>

        </nav>

    </aside>

    <main class="main">

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

            <h1>
                Audit Logs
            </h1>

            <p class="subtitle">
                Review important user and system activities.
            </p>

            <%
                if (auditError != null) {
            %>

            <div class="error">
                <%= auditError %>
            </div>

            <%
                }
            %>

            <div class="stats">

                <div class="card">

                    <h3>
                        Total Audit Logs
                    </h3>

                    <strong>
                        <%= totalLogs %>
                    </strong>

                </div>

                <div class="card">

                    <h3>
                        Today's Activity
                    </h3>

                    <strong>
                        <%= todayLogs %>
                    </strong>

                </div>

                <div class="card">

                    <h3>
                        Users With Activity
                    </h3>

                    <strong>
                        <%= activeUsers %>
                    </strong>

                </div>

                <div class="card">

                    <h3>
                        Displayed Records
                    </h3>

                    <strong>
                        <%= displayedLogs %>
                    </strong>

                </div>

            </div>

            <div class="filter-card">

                <h2>
                    Search & Filter
                </h2>

                <form
                    action="<%= request.getContextPath() %>/admin/AuditLogs"
                    method="get"
                    class="filters">

                    <div>

                        <label>
                            Search
                        </label>

                        <input
                            type="text"
                            name="search"
                            value="<%= search %>"
                            placeholder="Action, description, user or entity">

                    </div>

                    <div>

                        <label>
                            Entity Type
                        </label>

                        <input
                            type="text"
                            name="entityType"
                            value="<%= selectedEntityType %>"
                            placeholder="Appointment, Bill...">

                    </div>

                    <div>

                        <label>
                            Date
                        </label>

                        <input
                            type="date"
                            name="logDate"
                            value="<%= selectedDate %>">

                    </div>

                    <button
                        type="submit"
                        class="button">
                        Apply Filter
                    </button>

                    <a href="<%= request.getContextPath() %>/admin/AuditLogs"
                       class="clear">
                        Clear
                    </a>

                </form>

            </div>

            <div class="logs-card">

                <h2>
                    System Activity
                </h2>

                <%
                    if (logs != null
                            && !logs.isEmpty()) {
                %>

                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>
                                <th>Log ID</th>
                                <th>User</th>
                                <th>Role</th>
                                <th>Action</th>
                                <th>Description</th>
                                <th>Entity</th>
                                <th>Entity ID</th>
                                <th>Date & Time</th>
                            </tr>

                        </thead>

                        <tbody>

                            <%
                                for (AdminAuditLog log : logs) {

                                    String createdAt =
                                            log.getCreatedAt() != null
                                            ? dateTimeFormat.format(
                                                    log.getCreatedAt()
                                            )
                                            : "-";
                            %>

                            <tr>

                                <td>
                                    LOG-<%= String.format(
                                            "%06d",
                                            log.getLogId()
                                    ) %>
                                </td>

                                <td>

                                    <%
                                        if (log.getUserName() != null) {
                                    %>

                                    <strong>
                                        <%= log.getUserName() %>
                                    </strong>

                                    <div class="sub">
                                        <%= log.getUsername() %>
                                    </div>

                                    <%
                                        } else {
                                    %>

                                    System

                                    <%
                                        }
                                    %>

                                </td>

                                <td>

                                    <span class="badge">
                                        <%= log.getUserRole() != null
                                                ? log.getUserRole()
                                                : "SYSTEM" %>
                                    </span>

                                </td>

                                <td class="action">
                                    <%= log.getActionType() %>
                                </td>

                                <td>
                                    <%= log.getDescription() %>
                                </td>

                                <td>
                                    <%= log.getEntityType() != null
                                            ? log.getEntityType()
                                            : "-" %>
                                </td>

                                <td>
                                    <%= log.getEntityId() != null
                                            ? log.getEntityId()
                                            : "-" %>
                                </td>

                                <td>
                                    <%= createdAt %>
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

                <div class="empty">

                    <h3>
                        No Audit Logs Found
                    </h3>

                    <br>

                    <p>
                        No audit activity is available for
                        the selected filters.
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