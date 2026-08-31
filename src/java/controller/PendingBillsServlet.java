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
import java.util.List;

@WebServlet("/cashier/PendingBills")
public class PendingBillsServlet extends HttpServlet {

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
                    "Only cashiers can access pending bills."
            );

            return;
        }

        try {

            BillDAO billDAO =
                    new BillDAO();

            List<Bill> unpaidBills =
                    billDAO.getUnpaidBills();

            request.setAttribute(
                    "unpaidBills",
                    unpaidBills
            );

            request.getRequestDispatcher(
                    "/cashier/pending-bills.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "pendingBillsError",
                    "Unable to load pending bills."
            );

            request.getRequestDispatcher(
                    "/cashier/pending-bills.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}