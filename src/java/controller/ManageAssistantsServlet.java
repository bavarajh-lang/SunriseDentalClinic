package controller;

import dao.AssistantDAO;
import model.Assistant;
import model.Dentist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/ManageAssistants")
public class ManageAssistantsServlet extends HttpServlet {

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

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can manage assistants."
            );

            return;
        }

        try {

            AssistantDAO assistantDAO =
                    new AssistantDAO();

            List<Assistant> assistants =
                    assistantDAO.getAllAssistants();

            List<Dentist> unassignedDentists =
                    assistantDAO.getUnassignedDentists();

            request.setAttribute(
                    "assistants",
                    assistants
            );

            request.setAttribute(
                    "unassignedDentists",
                    unassignedDentists
            );

            request.getRequestDispatcher(
                    "/admin/manage-assistants.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "assistantPageError",
                    "Unable to load assistant information."
            );

            request.getRequestDispatcher(
                    "/admin/manage-assistants.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}