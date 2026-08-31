package controller;

import dao.BillDAO;
import dao.TreatmentDAO;

import model.Bill;
import model.TreatmentRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/assistant/ViewBill")
public class ViewBillServlet extends HttpServlet {

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
                (String) session.getAttribute("role");

        if (!"ASSISTANT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only dentist assistants can access this bill."
            );

            return;
        }

        try {

            String appointmentIdValue =
                    request.getParameter("appointmentId");

            if (appointmentIdValue == null
                    || appointmentIdValue.trim().isEmpty()) {

                setError(
                        session,
                        "Invalid appointment selected."
                );

                redirectTreatmentRecords(
                        request,
                        response
                );

                return;
            }

            int appointmentId =
                    Integer.parseInt(
                            appointmentIdValue.trim()
                    );

            if (appointmentId <= 0) {

                setError(
                        session,
                        "Invalid appointment selected."
                );

                redirectTreatmentRecords(
                        request,
                        response
                );

                return;
            }

            int assistantUserId =
                    (Integer) session.getAttribute("userId");

            TreatmentDAO treatmentDAO =
                    new TreatmentDAO();

            List<TreatmentRecord> records =
                    treatmentDAO
                            .getTreatmentRecordsByAssistantUserId(
                                    assistantUserId
                            );

            boolean allowed =
                    false;

            if (records != null) {

                for (TreatmentRecord record : records) {

                    if (record.getAppointmentId()
                            == appointmentId) {

                        allowed =
                                true;

                        break;
                    }
                }
            }

            if (!allowed) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You do not have permission to view this bill."
                );

                return;
            }

            BillDAO billDAO =
                    new BillDAO();

            Bill bill =
                    billDAO.getBillByAppointmentId(
                            appointmentId
                    );

            if (bill == null) {

                setError(
                        session,
                        "No bill has been generated for this treatment."
                );

                redirectTreatmentRecords(
                        request,
                        response
                );

                return;
            }

            request.setAttribute(
                    "bill",
                    bill
            );

            request.getRequestDispatcher(
                    "/assistant/view-bill.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid appointment selected."
            );

            redirectTreatmentRecords(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Unable to load bill information."
            );

            redirectTreatmentRecords(
                    request,
                    response
            );
        }
    }

    private void setError(
            HttpSession session,
            String message) {

        session.setAttribute(
                "billError",
                message
        );
    }

    private void redirectTreatmentRecords(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/assistant/TreatmentRecords"
        );
    }
}