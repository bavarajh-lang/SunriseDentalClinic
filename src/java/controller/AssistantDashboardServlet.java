package controller;

import dao.AssistantDashboardDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/assistant/Dashboard")
public class AssistantDashboardServlet extends HttpServlet {

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

        if (!"ASSISTANT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only dentist assistants can access this dashboard."
            );

            return;
        }

        int assistantUserId;

        try {

            assistantUserId =
                    Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

        } catch (Exception e) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        try {

            AssistantDashboardDAO dashboardDAO =
                    new AssistantDashboardDAO();

            int pendingRequests =
                    dashboardDAO.getPendingRequestsCount(
                            assistantUserId
                    );

            int todayConfirmed =
                    dashboardDAO.getTodayConfirmedCount(
                            assistantUserId
                    );

            int completedTreatments =
                    dashboardDAO.getCompletedTreatmentsCount(
                            assistantUserId
                    );

            int billsToGenerate =
                    dashboardDAO.getBillsToGenerateCount(
                            assistantUserId
                    );

            request.setAttribute(
                    "pendingRequests",
                    pendingRequests
            );

            request.setAttribute(
                    "todayConfirmed",
                    todayConfirmed
            );

            request.setAttribute(
                    "completedTreatments",
                    completedTreatments
            );

            request.setAttribute(
                    "billsToGenerate",
                    billsToGenerate
            );

            request.getRequestDispatcher(
                    "/assistant/dashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "dashboardError",
                    "Unable to load assistant dashboard information."
            );

            request.setAttribute(
                    "pendingRequests",
                    0
            );

            request.setAttribute(
                    "todayConfirmed",
                    0
            );

            request.setAttribute(
                    "completedTreatments",
                    0
            );

            request.setAttribute(
                    "billsToGenerate",
                    0
            );

            request.getRequestDispatcher(
                    "/assistant/dashboard.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}