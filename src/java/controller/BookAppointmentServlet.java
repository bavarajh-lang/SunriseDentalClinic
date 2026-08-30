package controller;

import dao.AppointmentDAO;
import model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        /*
         * 1. User login check
         */
        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        /*
         * 2. Only PATIENT can create appointments
         */
        String role =
                (String) session.getAttribute("role");

        if (!"PATIENT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only patients can book appointments."
            );
            return;
        }

        try {

            /*
             * 3. Get form values
             */
            String serviceIdValue =
                    request.getParameter("serviceId");

            String dentistIdValue =
                    request.getParameter("dentistId");

            String appointmentDateValue =
                    request.getParameter("appointmentDate");

            String appointmentTimeValue =
                    request.getParameter("appointmentTime");

            String reason =
                    request.getParameter("reason");


            /*
             * 4. Basic validation
             */
            if (serviceIdValue == null
                    || serviceIdValue.trim().isEmpty()
                    || dentistIdValue == null
                    || dentistIdValue.trim().isEmpty()
                    || appointmentDateValue == null
                    || appointmentDateValue.trim().isEmpty()
                    || appointmentTimeValue == null
                    || appointmentTimeValue.trim().isEmpty()) {

                session.setAttribute(
                        "appointmentError",
                        "Please complete all required appointment fields."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointment"
                );

                return;
            }


            /*
             * 5. Convert form values
             */
            int serviceId =
                    Integer.parseInt(serviceIdValue);

            int dentistId =
                    Integer.parseInt(dentistIdValue);

            LocalDate selectedDate =
                    LocalDate.parse(appointmentDateValue);

            LocalTime selectedTime =
                    LocalTime.parse(appointmentTimeValue);


            /*
             * 6. Prevent past dates
             */
            LocalDate today =
                    LocalDate.now();

            if (selectedDate.isBefore(today)) {

                session.setAttribute(
                        "appointmentError",
                        "You cannot book an appointment for a past date."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointment"
                );

                return;
            }


            /*
             * 7. If booking today,
             * prevent past time
             */
            if (selectedDate.equals(today)
                    && selectedTime.isBefore(LocalTime.now())) {

                session.setAttribute(
                        "appointmentError",
                        "Please select a future appointment time."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointment"
                );

                return;
            }


            /*
             * 8. Logged-in user ID
             */
            int userId =
                    (Integer) session.getAttribute("userId");


            AppointmentDAO appointmentDAO =
                    new AppointmentDAO();


            /*
             * 9. Get patient ID using user ID
             */
            int patientId =
                    appointmentDAO.getPatientIdByUserId(userId);

            if (patientId == -1) {

                session.setAttribute(
                        "appointmentError",
                        "Patient profile could not be found."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointment"
                );

                return;
            }


            /*
             * 10. Convert to SQL Date and Time
             */
            Date appointmentDate =
                    Date.valueOf(selectedDate);

            Time appointmentTime =
                    Time.valueOf(selectedTime);


            /*
             * 11. Check dentist slot availability
             */
            boolean available =
                    appointmentDAO.isSlotAvailable(
                            dentistId,
                            appointmentDate,
                            appointmentTime
                    );

            if (!available) {

                session.setAttribute(
                        "appointmentError",
                        "This dentist already has an appointment "
                        + "at the selected date and time. "
                        + "Please choose another slot."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointment"
                );

                return;
            }


            /*
             * 12. Clean optional reason
             */
            if (reason != null) {
                reason = reason.trim();
            }


            /*
             * 13. Build Appointment object
             */
            Appointment appointment =
                    new Appointment(
                            patientId,
                            dentistId,
                            serviceId,
                            appointmentDate,
                            appointmentTime,
                            reason
                    );


            /*
             * 14. Save appointment
             */
            boolean created =
                    appointmentDAO.createAppointment(
                            appointment
                    );


            /*
             * 15. Success / failure
             */
            if (created) {

                session.setAttribute(
                        "appointmentSuccess",
                        "Appointment request submitted successfully. "
                        + "Your appointment number is "
                        + appointment.getAppointmentNo()
                        + ". Status: PENDING."
                );

            } else {

                session.setAttribute(
                        "appointmentError",
                        "Unable to create the appointment. "
                        + "Please try again."
                );
            }


            /*
             * 16. Return to booking page
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/BookAppointment"
            );

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "appointmentError",
                    "Invalid service or dentist selected."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookAppointment"
            );

        } catch (IllegalArgumentException e) {

            session.setAttribute(
                    "appointmentError",
                    "Invalid appointment date or time."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookAppointment"
            );

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "appointmentError",
                    "Something went wrong while creating the appointment."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookAppointment"
            );
        }
    }
}