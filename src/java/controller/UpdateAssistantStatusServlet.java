package controller;

import dao.AssistantDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/UpdateAssistantStatusServlet")
public class UpdateAssistantStatusServlet extends HttpServlet {

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

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can update assistant status."
            );

            return;
        }

        try {

            String userIdValue =
                    request.getParameter("userId");

            String status =
                    request.getParameter("status");

            if (userIdValue == null
                    || userIdValue.trim().isEmpty()) {

                setError(
                        session,
                        "Invalid assistant selected."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (!"ACTIVE".equals(status)
                    && !"INACTIVE".equals(status)) {

                setError(
                        session,
                        "Invalid assistant status."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            int userId =
                    Integer.parseInt(
                            userIdValue.trim()
                    );

            if (userId <= 0) {

                setError(
                        session,
                        "Invalid assistant selected."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            AssistantDAO assistantDAO =
                    new AssistantDAO();

            boolean updated =
                    assistantDAO.updateAssistantStatus(
                            userId,
                            status
                    );

            if (updated) {

                if ("ACTIVE".equals(status)) {

                    session.setAttribute(
                            "assistantSuccess",
                            "Assistant account activated successfully."
                    );

                } else {

                    session.setAttribute(
                            "assistantSuccess",
                            "Assistant account deactivated successfully."
                    );
                }

            } else {

                setError(
                        session,
                        "Unable to update assistant status."
                );
            }

            redirect(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid assistant selected."
            );

            redirect(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while updating the assistant."
            );

            redirect(
                    request,
                    response
            );
        }
    }

    private void setError(
            HttpSession session,
            String message) {

        session.setAttribute(
                "assistantError",
                message
        );
    }

    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/ManageAssistants"
        );
    }
}