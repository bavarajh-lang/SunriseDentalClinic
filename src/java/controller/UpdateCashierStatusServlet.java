package controller;

import dao.CashierDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/UpdateCashierStatusServlet")
public class UpdateCashierStatusServlet extends HttpServlet {

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
                    "Only administrators can update cashier status."
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
                        "Invalid cashier selected."
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
                        "Invalid cashier status."
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
                        "Invalid cashier selected."
                );

                redirect(
                        request,
                        response
                );

                return;
            }

            CashierDAO cashierDAO =
                    new CashierDAO();

            boolean updated =
                    cashierDAO.updateCashierStatus(
                            userId,
                            status
                    );

            if (updated) {

                if ("ACTIVE".equals(status)) {

                    session.setAttribute(
                            "cashierSuccess",
                            "Cashier account activated successfully."
                    );

                } else {

                    session.setAttribute(
                            "cashierSuccess",
                            "Cashier account deactivated successfully."
                    );
                }

            } else {

                if ("ACTIVE".equals(status)) {

                    setError(
                            session,
                            "Unable to activate cashier. "
                            + "Another active cashier may already exist."
                    );

                } else {

                    setError(
                            session,
                            "Unable to deactivate cashier."
                    );
                }
            }

            redirect(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid cashier selected."
            );

            redirect(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while updating the cashier."
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