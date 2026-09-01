package controller;

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
                request.getParameter("usernameOrEmail");

        String password =
                request.getParameter("password");

        if (usernameOrEmail == null
                || usernameOrEmail.trim().isEmpty()
                || password == null
                || password.trim().isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter your username/email and password."
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

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
                    "Invalid login details or inactive account."
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        if (user.getRole() == null
                || user.getRole().trim().isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Your account role is not available."
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

        String contextPath =
                request.getContextPath();

        switch (user.getRole()) {

            case "ADMIN":

                response.sendRedirect(
                        contextPath
                        + "/admin/Dashboard"
                );

                break;

            case "PATIENT":

                response.sendRedirect(
                        contextPath
                        + "/patient/dashboard.jsp"
                );

                break;

            case "ASSISTANT":

                response.sendRedirect(
                        contextPath
                        + "/assistant/dashboard.jsp"
                );

                break;

            case "CASHIER":

                response.sendRedirect(
                        contextPath
                        + "/cashier/Dashboard"
                );

                break;

            default:

                session.invalidate();

                request.setAttribute(
                        "errorMessage",
                        "Your account role is not supported."
                );

                request.getRequestDispatcher(
                        "/login.jsp"
                ).forward(
                        request,
                        response
                );

                break;
        }
    }
}