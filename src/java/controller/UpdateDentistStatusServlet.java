package controller;

import dao.DentistDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/UpdateDentistStatusServlet")
public class UpdateDentistStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * RoleFilter already protects /admin/*
         * Still check session before using messages.
         */
        if (session == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        try {

            String dentistIdValue =
                    request.getParameter("dentistId");

            String status =
                    request.getParameter("status");


            /*
             * Basic validation
             */
            if (dentistIdValue == null
                    || dentistIdValue.trim().isEmpty()
                    || status == null
                    || status.trim().isEmpty()) {

                session.setAttribute(
                        "dentistError",
                        "Invalid dentist status request."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/ManageDentists"
                );

                return;
            }


            /*
             * Allow only valid DB status values
             */
            status =
                    status.trim().toUpperCase();

            if (!"ACTIVE".equals(status)
                    && !"INACTIVE".equals(status)) {

                session.setAttribute(
                        "dentistError",
                        "Invalid dentist status."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/ManageDentists"
                );

                return;
            }


            int dentistId =
                    Integer.parseInt(
                            dentistIdValue
                    );


            if (dentistId <= 0) {

                session.setAttribute(
                        "dentistError",
                        "Invalid dentist selected."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/ManageDentists"
                );

                return;
            }


            /*
             * Update database
             */
            DentistDAO dentistDAO =
                    new DentistDAO();

            boolean updated =
                    dentistDAO.updateDentistStatus(
                            dentistId,
                            status
                    );


            if (updated) {

                if ("ACTIVE".equals(status)) {

                    session.setAttribute(
                            "dentistSuccess",
                            "Dentist activated successfully."
                    );

                } else {

                    session.setAttribute(
                            "dentistSuccess",
                            "Dentist deactivated successfully."
                    );
                }

            } else {

                session.setAttribute(
                        "dentistError",
                        "Unable to update dentist status."
                );
            }


            /*
             * Return to Manage Dentists
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ManageDentists"
            );

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "dentistError",
                    "Invalid dentist ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ManageDentists"
            );

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "dentistError",
                    "Something went wrong while updating the dentist."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ManageDentists"
            );
        }
    }
}