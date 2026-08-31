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

@WebServlet("/assistant/GenerateBill")
public class GenerateBillServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
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
                    "Only dentist assistants can generate bills."
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

            List<TreatmentRecord> treatmentRecords =
                    treatmentDAO
                            .getTreatmentRecordsByAssistantUserId(
                                    assistantUserId
                            );

            boolean allowed =
                    false;

            if (treatmentRecords != null) {

                for (TreatmentRecord record
                        : treatmentRecords) {

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
                        "You do not have permission to generate a bill for this treatment."
                );

                return;
            }

            BillDAO billDAO =
                    new BillDAO();

            Bill existingBill =
                    billDAO.getBillByAppointmentId(
                            appointmentId
                    );

            Bill bill;

            if (existingBill != null) {

                bill =
                        existingBill;

                session.setAttribute(
                        "billSuccess",
                        "Bill already exists. Existing bill opened."
                );

            } else {

                bill =
                        billDAO.generateBillForAppointment(
                                appointmentId
                        );

                if (bill == null) {

                    setError(
                            session,
                            "Unable to generate the bill. "
                            + "Please make sure the treatment has been completed."
                    );

                    redirectTreatmentRecords(
                            request,
                            response
                    );

                    return;
                }

                session.setAttribute(
                        "billSuccess",
                        "Bill generated successfully. Bill Number: "
                        + bill.getBillNo()
                );
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/assistant/ViewBill?appointmentId="
                    + bill.getAppointmentId()
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
                    "Something went wrong while generating the bill."
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