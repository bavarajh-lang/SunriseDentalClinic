package controller;

import dao.TreatmentDAO;
import model.TreatmentRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/assistant/TreatmentRecords")
public class TreatmentRecordsServlet extends HttpServlet {

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
                    "Only dentist assistants can access treatment records."
            );

            return;
        }

        try {

            int assistantUserId =
                    (Integer) session.getAttribute("userId");

            TreatmentDAO treatmentDAO =
                    new TreatmentDAO();

            List<TreatmentRecord> treatmentRecords =
                    treatmentDAO
                            .getTreatmentRecordsByAssistantUserId(
                                    assistantUserId
                            );

            request.setAttribute(
                    "treatmentRecords",
                    treatmentRecords
            );

            request.getRequestDispatcher(
                    "/assistant/treatment-records.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "treatmentRecordsError",
                    "Unable to load treatment records."
            );

            request.getRequestDispatcher(
                    "/assistant/treatment-records.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}