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
import java.util.List;

@WebServlet("/admin/ManageCashiers")
public class ManageCashiersServlet extends HttpServlet {

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
                    "Only administrators can manage cashiers."
            );

            return;
        }

        try {

            CashierDAO cashierDAO =
                    new CashierDAO();

            List<Cashier> cashiers =
                    cashierDAO.getAllCashiers();

            boolean activeCashierExists =
                    cashierDAO.hasActiveCashier();

            request.setAttribute(
                    "cashiers",
                    cashiers
            );

            request.setAttribute(
                    "activeCashierExists",
                    activeCashierExists
            );

            request.getRequestDispatcher(
                    "/admin/manage-cashiers.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "cashierPageError",
                    "Unable to load cashier information."
            );

            request.getRequestDispatcher(
                    "/admin/manage-cashiers.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}