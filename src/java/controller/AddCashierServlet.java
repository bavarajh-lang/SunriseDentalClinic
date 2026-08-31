package controller;

import dao.CashierDAO;
import model.Cashier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/AddCashierServlet")
public class AddCashierServlet extends HttpServlet {

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
                    "Only administrators can add cashiers."
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

            if (fullName == null
                    || fullName.trim().isEmpty()) {

                setError(
                        session,
                        "Cashier full name is required."
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

            fullName =
                    fullName.trim();

            username =
                    username.trim();

            email =
                    email.trim();

            if (fullName.length() > 100) {

                setError(
                        session,
                        "Cashier name is too long."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

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

            CashierDAO cashierDAO =
                    new CashierDAO();

            if (cashierDAO.hasActiveCashier()) {

                setError(
                        session,
                        "An active cashier already exists. "
                        + "Deactivate the current cashier before adding a new cashier."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            if (cashierDAO.usernameExists(
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

            if (cashierDAO.emailExists(
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

            Cashier cashier =
                    new Cashier();

            cashier.setFullName(
                    fullName
            );

            cashier.setUsername(
                    username
            );

            cashier.setEmail(
                    email
            );

            cashier.setPhone(
                    cleanValue(phone)
            );

            boolean added =
                    cashierDAO.addCashier(
                            cashier,
                            password
                    );

            if (added) {

                session.setAttribute(
                        "cashierSuccess",
                        "Cashier account created successfully."
                );

            } else {

                setError(
                        session,
                        "Unable to create cashier. "
                        + "Another active cashier may already exist."
                );
            }

            redirect(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while creating the cashier."
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
                "cashierError",
                message
        );
    }

    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/ManageCashiers"
        );
    }
}