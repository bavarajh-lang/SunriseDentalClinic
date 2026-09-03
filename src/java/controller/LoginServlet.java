package controller;

import dao.AuditLogDAO;
import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail =
                request.getParameter(
                        "usernameOrEmail"
                );

        String password =
                request.getParameter(
                        "password"
                );

        if (usernameOrEmail == null
                || usernameOrEmail.trim().isEmpty()
                || password == null
                || password.trim().isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter your username or email and password."
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        try {

            UserDAO userDAO =
                    new UserDAO();

            User user =
                    userDAO.login(
                            usernameOrEmail.trim(),
                            password
                    );

            if (user == null) {

                request.setAttribute(
                        "errorMessage",
                        "Invalid username/email or password."
                );

                request.getRequestDispatcher(
                        "/login.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            if (user.getStatus() == null
                    || !"ACTIVE".equalsIgnoreCase(
                            user.getStatus()
                    )) {

                request.setAttribute(
                        "errorMessage",
                        "Your account is inactive. Please contact the administrator."
                );

                request.getRequestDispatcher(
                        "/login.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            HttpSession oldSession =
                    request.getSession(false);

            if (oldSession != null) {

                oldSession.invalidate();
            }

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "user",
                    user
            );

            session.setAttribute(
                    "userId",
                    user.getUserId()
            );

            session.setAttribute(
                    "fullName",
                    user.getFullName()
            );

            session.setAttribute(
                    "role",
                    user.getRole()
            );

            session.setMaxInactiveInterval(
                    30 * 60
            );

            AuditLogDAO auditLogDAO =
                    new AuditLogDAO();

            auditLogDAO.logAction(
                    user.getUserId(),
                    "LOGIN",
                    "User logged in successfully.",
                    "USER",
                    (long) user.getUserId()
            );

            String role =
                    user.getRole();

            if ("ADMIN".equals(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/Dashboard"
                );

            } else if ("PATIENT".equals(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/patient/Dashboard"
                );

            } else if ("ASSISTANT".equals(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/Dashboard"
                );

            } else if ("CASHIER".equals(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/cashier/Dashboard"
                );

            } else {

                session.invalidate();

                request.setAttribute(
                        "errorMessage",
                        "Invalid user role."
                );

                request.getRequestDispatcher(
                        "/login.jsp"
                ).forward(
                        request,
                        response
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to login at this time. Please try again."
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}