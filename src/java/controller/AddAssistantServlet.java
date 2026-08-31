package controller;

import dao.AssistantDAO;
import model.Assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/AddAssistantServlet")
public class AddAssistantServlet extends HttpServlet {

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
                    "Only administrators can add assistants."
            );

            return;
        }

        try {

            String fullName =
                    request.getParameter("fullName");

            String username =
                    request.getParameter("username");

            String email =
                    request.getParameter("email");

            String phone =
                    request.getParameter("phone");

            String password =
                    request.getParameter("password");

            String dentistIdValue =
                    request.getParameter("dentistId");

            if (fullName == null
                    || fullName.trim().isEmpty()) {

                setError(
                        session,
                        "Assistant full name is required."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (username == null
                    || username.trim().isEmpty()) {

                setError(
                        session,
                        "Username is required."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (email == null
                    || email.trim().isEmpty()) {

                setError(
                        session,
                        "Email address is required."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (password == null
                    || password.trim().isEmpty()) {

                setError(
                        session,
                        "Password is required."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (password.length() < 3) {

                setError(
                        session,
                        "Password must contain at least 3 characters."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (dentistIdValue == null
                    || dentistIdValue.trim().isEmpty()) {

                setError(
                        session,
                        "Please select a dentist for this assistant."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            int dentistId =
                    Integer.parseInt(
                            dentistIdValue.trim()
                    );

            if (dentistId <= 0) {

                setError(
                        session,
                        "Invalid dentist selected."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            fullName =
                    fullName.trim();

            username =
                    username.trim();

            email =
                    email.trim();

            if (username.length() > 50) {

                setError(
                        session,
                        "Username is too long."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (email.length() > 100) {

                setError(
                        session,
                        "Email address is too long."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            AssistantDAO assistantDAO =
                    new AssistantDAO();

            if (assistantDAO.usernameExists(
                    username)) {

                setError(
                        session,
                        "This username is already in use."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (assistantDAO.emailExists(
                    email)) {

                setError(
                        session,
                        "This email address is already in use."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            Assistant assistant =
                    new Assistant();

            assistant.setFullName(
                    fullName
            );

            assistant.setUsername(
                    username
            );

            assistant.setEmail(
                    email
            );

            assistant.setPhone(
                    cleanValue(phone)
            );

            boolean added =
                    assistantDAO.addAssistant(
                            assistant,
                            password,
                            dentistId
                    );

            if (added) {

                session.setAttribute(
                        "assistantSuccess",
                        "Assistant added and assigned successfully. "
                        + "Assistant Number: "
                        + assistant.getAssistantNo()
                );

            } else {

                setError(
                        session,
                        "Unable to add assistant. "
                        + "The selected dentist may already have an assistant."
                );
            }

            redirect(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid dentist selected."
            );

            redirect(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while adding the assistant."
            );

            redirect(
                    request,
                    response
            );
        }
    }

    private String cleanValue(
            String value) {

        if (value == null
                || value.trim().isEmpty()) {

            return null;
        }

        return value.trim();
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