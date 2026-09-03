package controller;

import facade.ClinicFacade;
import model.PatientBill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patient/MyBills")
public class PatientBillsServlet extends HttpServlet {

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

        if (!"PATIENT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only patients can access their bills."
            );

            return;
        }

        int patientUserId;

        try {

            patientUserId =
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

            ClinicFacade clinicFacade =
                    new ClinicFacade();

            List<PatientBill> bills =
                    clinicFacade
                            .getPatientBills(
                                    patientUserId
                            );

            int totalBills =
                    clinicFacade
                            .getPatientTotalBillsCount(
                                    patientUserId
                            );

            int unpaidBills =
                    clinicFacade
                            .getPatientUnpaidBillsCount(
                                    patientUserId
                            );

            int paidBills =
                    clinicFacade
                            .getPatientPaidBillsCount(
                                    patientUserId
                            );

            request.setAttribute(
                    "bills",
                    bills
            );

            request.setAttribute(
                    "totalBills",
                    totalBills
            );

            request.setAttribute(
                    "unpaidBills",
                    unpaidBills
            );

            request.setAttribute(
                    "paidBills",
                    paidBills
            );

            request.getRequestDispatcher(
                    "/patient/my-bills.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "billError",
                    "Unable to load your billing information."
            );

            request.setAttribute(
                    "bills",
                    new ArrayList<PatientBill>()
            );

            request.setAttribute(
                    "totalBills",
                    0
            );

            request.setAttribute(
                    "unpaidBills",
                    0
            );

            request.setAttribute(
                    "paidBills",
                    0
            );

            request.getRequestDispatcher(
                    "/patient/my-bills.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}