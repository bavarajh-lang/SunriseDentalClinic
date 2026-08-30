package controller;

import dao.DentistDAO;
import model.Dentist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/AddDentistServlet")
public class AddDentistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        try {

            String fullName =
                    request.getParameter("fullName");

            String specialization =
                    request.getParameter("specialization");

            String phone =
                    request.getParameter("phone");

            String email =
                    request.getParameter("email");

            String consultationFeeValue =
                    request.getParameter("consultationFee");


            /*
             * Required field validation
             */
            if (fullName == null
                    || fullName.trim().isEmpty()) {

                session.setAttribute(
                        "dentistError",
                        "Dentist full name is required."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/ManageDentists"
                );

                return;
            }


            /*
             * Consultation fee
             */
            double consultationFee = 0.00;

            if (consultationFeeValue != null
                    && !consultationFeeValue.trim().isEmpty()) {

                consultationFee =
                        Double.parseDouble(
                                consultationFeeValue.trim()
                        );
            }


            if (consultationFee < 0) {

                session.setAttribute(
                        "dentistError",
                        "Consultation fee cannot be negative."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/ManageDentists"
                );

                return;
            }


            /*
             * Create Dentist object
             */
            Dentist dentist =
                    new Dentist();

            dentist.setFullName(
                    fullName.trim()
            );

            dentist.setSpecialization(
                    cleanValue(specialization)
            );

            dentist.setPhone(
                    cleanValue(phone)
            );

            dentist.setEmail(
                    cleanValue(email)
            );

            dentist.setConsultationFee(
                    consultationFee
            );


            /*
             * Save to database
             */
            DentistDAO dentistDAO =
                    new DentistDAO();

            boolean added =
                    dentistDAO.addDentist(
                            dentist
                    );


            if (added) {

                session.setAttribute(
                        "dentistSuccess",
                        "Dentist added successfully. "
                        + "Dentist Number: "
                        + dentist.getDentistNo()
                );

            } else {

                session.setAttribute(
                        "dentistError",
                        "Unable to add dentist. Please try again."
                );
            }


            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ManageDentists"
            );

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "dentistError",
                    "Please enter a valid consultation fee."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ManageDentists"
            );

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "dentistError",
                    "Something went wrong while adding the dentist."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ManageDentists"
            );
        }
    }


    private String cleanValue(String value) {

        if (value == null
                || value.trim().isEmpty()) {

            return null;
        }

        return value.trim();
    }
}