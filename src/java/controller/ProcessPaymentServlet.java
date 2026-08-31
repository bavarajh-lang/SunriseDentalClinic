package controller;

import dao.BillDAO;
import model.Bill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cashier/ProcessPayment")
public class ProcessPaymentServlet extends HttpServlet {

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

        if (!"CASHIER".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only cashiers can process payments."
            );

            return;
        }

        try {

            String billIdValue =
                    request.getParameter("billId");

            if (billIdValue == null
                    || billIdValue.trim().isEmpty()) {

                setError(
                        session,
                        "Invalid bill selected."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            int billId =
                    Integer.parseInt(
                            billIdValue.trim()
                    );

            if (billId <= 0) {

                setError(
                        session,
                        "Invalid bill selected."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            BillDAO billDAO =
                    new BillDAO();

            Bill bill =
                    billDAO.getBillById(
                            billId
                    );

            if (bill == null) {

                setError(
                        session,
                        "The selected bill could not be found."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            if (!"UNPAID".equals(
                    bill.getPaymentStatus())) {

                setError(
                        session,
                        "This bill is no longer waiting for payment."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            request.setAttribute(
                    "bill",
                    bill
            );

            request.getRequestDispatcher(
                    "/cashier/process-payment.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid bill selected."
            );

            redirectPendingBills(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Unable to load payment information."
            );

            redirectPendingBills(
                    request,
                    response
            );
        }
    }

    private void setError(
            HttpSession session,
            String message) {

        session.setAttribute(
                "paymentError",
                message
        );
    }

    private void redirectPendingBills(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/cashier/PendingBills"
        );
    }
}