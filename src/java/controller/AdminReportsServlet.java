package controller;

import dao.AdminReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet("/admin/Reports")
public class AdminReportsServlet extends HttpServlet {

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
                    "Only administrators can access reports."
            );

            return;
        }

        String fromDateText =
                request.getParameter(
                        "fromDate"
                );

        String toDateText =
                request.getParameter(
                        "toDate"
                );

        Date fromDate = null;
        Date toDate = null;

        String reportError = null;

        try {

            if (fromDateText != null
                    && !fromDateText.trim().isEmpty()) {

                fromDate =
                        Date.valueOf(
                                fromDateText.trim()
                        );
            }

            if (toDateText != null
                    && !toDateText.trim().isEmpty()) {

                toDate =
                        Date.valueOf(
                                toDateText.trim()
                        );
            }

            if (fromDate != null
                    && toDate != null
                    && fromDate.after(toDate)) {

                reportError =
                        "From Date cannot be later than To Date.";

                fromDate = null;
                toDate = null;

                fromDateText = "";
                toDateText = "";
            }

        } catch (IllegalArgumentException e) {

            reportError =
                    "Invalid report date selected.";

            fromDate = null;
            toDate = null;

            fromDateText = "";
            toDateText = "";
        }

        try {

            AdminReportDAO reportDAO =
                    new AdminReportDAO();

            int totalPatients =
                    reportDAO.getTotalPatients();

            int activeDentists =
                    reportDAO.getActiveDentists();

            int totalAppointments =
                    reportDAO.getAppointmentCount(
                            fromDate,
                            toDate
                    );

            int pendingAppointments =
                    reportDAO.getAppointmentCountByStatus(
                            "PENDING",
                            fromDate,
                            toDate
                    );

            int confirmedAppointments =
                    reportDAO.getAppointmentCountByStatus(
                            "CONFIRMED",
                            fromDate,
                            toDate
                    );

            int rescheduleAppointments =
                    reportDAO.getAppointmentCountByStatus(
                            "RESCHEDULE_REQUESTED",
                            fromDate,
                            toDate
                    );

            int completedAppointments =
                    reportDAO.getAppointmentCountByStatus(
                            "COMPLETED",
                            fromDate,
                            toDate
                    );

            int cancelledAppointments =
                    reportDAO.getAppointmentCountByStatus(
                            "CANCELLED",
                            fromDate,
                            toDate
                    );

            int successfulPayments =
                    reportDAO.getSuccessfulPaymentCount(
                            fromDate,
                            toDate
                    );

            BigDecimal totalRevenue =
                    reportDAO.getRevenue(
                            fromDate,
                            toDate
                    );

            BigDecimal cashRevenue =
                    reportDAO.getRevenueByMethod(
                            "CASH",
                            fromDate,
                            toDate
                    );

            BigDecimal cardRevenue =
                    reportDAO.getRevenueByMethod(
                            "CARD",
                            fromDate,
                            toDate
                    );

            BigDecimal bankTransferRevenue =
                    reportDAO.getRevenueByMethod(
                            "BANK_TRANSFER",
                            fromDate,
                            toDate
                    );

            request.setAttribute(
                    "totalPatients",
                    totalPatients
            );

            request.setAttribute(
                    "activeDentists",
                    activeDentists
            );

            request.setAttribute(
                    "totalAppointments",
                    totalAppointments
            );

            request.setAttribute(
                    "pendingAppointments",
                    pendingAppointments
            );

            request.setAttribute(
                    "confirmedAppointments",
                    confirmedAppointments
            );

            request.setAttribute(
                    "rescheduleAppointments",
                    rescheduleAppointments
            );

            request.setAttribute(
                    "completedAppointments",
                    completedAppointments
            );

            request.setAttribute(
                    "cancelledAppointments",
                    cancelledAppointments
            );

            request.setAttribute(
                    "successfulPayments",
                    successfulPayments
            );

            request.setAttribute(
                    "totalRevenue",
                    totalRevenue
            );

            request.setAttribute(
                    "cashRevenue",
                    cashRevenue
            );

            request.setAttribute(
                    "cardRevenue",
                    cardRevenue
            );

            request.setAttribute(
                    "bankTransferRevenue",
                    bankTransferRevenue
            );

            request.setAttribute(
                    "selectedFromDate",
                    fromDateText != null
                    ? fromDateText
                    : ""
            );

            request.setAttribute(
                    "selectedToDate",
                    toDateText != null
                    ? toDateText
                    : ""
            );

            if (reportError != null) {

                request.setAttribute(
                        "reportError",
                        reportError
                );
            }

            request.getRequestDispatcher(
                    "/admin/reports.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "reportError",
                    "Unable to generate clinic report."
            );

            request.setAttribute(
                    "totalPatients",
                    0
            );

            request.setAttribute(
                    "activeDentists",
                    0
            );

            request.setAttribute(
                    "totalAppointments",
                    0
            );

            request.setAttribute(
                    "pendingAppointments",
                    0
            );

            request.setAttribute(
                    "confirmedAppointments",
                    0
            );

            request.setAttribute(
                    "rescheduleAppointments",
                    0
            );

            request.setAttribute(
                    "completedAppointments",
                    0
            );

            request.setAttribute(
                    "cancelledAppointments",
                    0
            );

            request.setAttribute(
                    "successfulPayments",
                    0
            );

            request.setAttribute(
                    "totalRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "cashRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "cardRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "bankTransferRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "selectedFromDate",
                    fromDateText != null
                    ? fromDateText
                    : ""
            );

            request.setAttribute(
                    "selectedToDate",
                    toDateText != null
                    ? toDateText
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/reports.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}