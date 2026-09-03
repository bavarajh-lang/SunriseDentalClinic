package controller;

import dao.AdminAuditLogDAO;
import model.AdminAuditLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/AuditLogs")
public class AdminAuditLogsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can access audit logs."
            );

            return;
        }

        String search =
                request.getParameter(
                        "search"
                );

        String entityType =
                request.getParameter(
                        "entityType"
                );

        String logDate =
                request.getParameter(
                        "logDate"
                );

        if (search != null) {
            search = search.trim();
        }

        if (entityType != null) {
            entityType = entityType.trim();
        }

        if (logDate != null) {
            logDate = logDate.trim();
        }

        try {

            AdminAuditLogDAO auditLogDAO =
                    new AdminAuditLogDAO();

            List<AdminAuditLog> logs =
                    auditLogDAO.getLogs(
                            search,
                            entityType,
                            logDate
                    );

            int totalLogs =
                    auditLogDAO.getTotalLogs();

            int todayLogs =
                    auditLogDAO.getTodayLogs();

            int activeUsers =
                    auditLogDAO.getUsersWithActivity();

            request.setAttribute(
                    "logs",
                    logs
            );

            request.setAttribute(
                    "totalLogs",
                    totalLogs
            );

            request.setAttribute(
                    "todayLogs",
                    todayLogs
            );

            request.setAttribute(
                    "activeUsers",
                    activeUsers
            );

            request.setAttribute(
                    "search",
                    search != null
                    ? search
                    : ""
            );

            request.setAttribute(
                    "selectedEntityType",
                    entityType != null
                    ? entityType
                    : ""
            );

            request.setAttribute(
                    "selectedDate",
                    logDate != null
                    ? logDate
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/audit-logs.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "auditError",
                    "Unable to load system audit logs."
            );

            request.setAttribute(
                    "logs",
                    new ArrayList<AdminAuditLog>()
            );

            request.setAttribute(
                    "totalLogs",
                    0
            );

            request.setAttribute(
                    "todayLogs",
                    0
            );

            request.setAttribute(
                    "activeUsers",
                    0
            );

            request.setAttribute(
                    "search",
                    search != null
                    ? search
                    : ""
            );

            request.setAttribute(
                    "selectedEntityType",
                    entityType != null
                    ? entityType
                    : ""
            );

            request.setAttribute(
                    "selectedDate",
                    logDate != null
                    ? logDate
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/audit-logs.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}