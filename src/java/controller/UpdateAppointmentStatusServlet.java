package controller;

import dao.AppointmentDAO;

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

@WebServlet("/assistant/UpdateAppointmentStatusServlet")
public class UpdateAppointmentStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * =========================================
         * SESSION CHECK
         * =========================================
         */
        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * =========================================
         * ROLE CHECK
         * =========================================
         */
        String role =
                (String) session.getAttribute("role");

        if (!"ASSISTANT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only dentist assistants can update appointments."
            );

            return;
        }


        try {

            /*
             * =========================================
             * GET FORM VALUES
             * =========================================
             */
            String appointmentIdValue =
                    request.getParameter("appointmentId");

            String action =
                    request.getParameter("action");


            /*
             * =========================================
             * BASIC VALIDATION
             * =========================================
             */
            if (appointmentIdValue == null
                    || appointmentIdValue.trim().isEmpty()
                    || action == null
                    || action.trim().isEmpty()) {

                setError(
                        session,
                        "Invalid appointment request."
                );

                redirectToPendingAppointments(
                        request,
                        response
                );

                return;
            }


            int appointmentId =
                    Integer.parseInt(
                            appointmentIdValue.trim()
                    );


            if (appointmentId <= 0) {

                setError(
                        session,
                        "Invalid appointment selected."
                );

                redirectToPendingAppointments(
                        request,
                        response
                );

                return;
            }


            action =
                    action.trim().toUpperCase();


            int assistantUserId =
                    (Integer) session.getAttribute("userId");


            AppointmentDAO appointmentDAO =
                    new AppointmentDAO();


            /*
             * =========================================
             * CONFIRM APPOINTMENT
             * =========================================
             */
            if ("CONFIRM".equals(action)) {

                boolean confirmed =
                        appointmentDAO
                                .confirmAppointmentByAssistant(
                                        assistantUserId,
                                        appointmentId
                                );


                if (confirmed) {

                    session.setAttribute(
                            "appointmentUpdateSuccess",
                            "Appointment confirmed successfully."
                    );

                } else {

                    setError(
                            session,
                            "Unable to confirm the appointment. "
                            + "The appointment may already have been updated "
                            + "or may not belong to your assigned dentist."
                    );
                }


                redirectToPendingAppointments(
                        request,
                        response
                );

                return;
            }


            /*
             * =========================================
             * CANCEL APPOINTMENT
             * =========================================
             */
            if ("CANCEL".equals(action)) {

                boolean cancelled =
                        appointmentDAO
                                .cancelAppointmentByAssistant(
                                        assistantUserId,
                                        appointmentId
                                );


                if (cancelled) {

                    session.setAttribute(
                            "appointmentUpdateSuccess",
                            "Appointment cancelled successfully."
                    );

                } else {

                    setError(
                            session,
                            "Unable to cancel the appointment. "
                            + "The appointment may already have been updated "
                            + "or may not belong to your assigned dentist."
                    );
                }


                redirectToPendingAppointments(
                        request,
                        response
                );

                return;
            }


            /*
             * =========================================
             * RESCHEDULE APPOINTMENT
             * =========================================
             */
            if ("RESCHEDULE".equals(action)) {

                String suggestedDateValue =
                        request.getParameter("suggestedDate");

                String suggestedTimeValue =
                        request.getParameter("suggestedTime");

                String assistantNote =
                        request.getParameter("assistantNote");


                /*
                 * Required reschedule fields
                 */
                if (suggestedDateValue == null
                        || suggestedDateValue.trim().isEmpty()
                        || suggestedTimeValue == null
                        || suggestedTimeValue.trim().isEmpty()) {

                    setError(
                            session,
                            "Please select a suggested date and time."
                    );

                    redirectToPendingAppointments(
                            request,
                            response
                    );

                    return;
                }


                /*
                 * Convert values
                 */
                LocalDate suggestedLocalDate =
                        LocalDate.parse(
                                suggestedDateValue.trim()
                        );

                LocalTime suggestedLocalTime =
                        LocalTime.parse(
                                suggestedTimeValue.trim()
                        );


                /*
                 * =========================================
                 * PREVENT PAST DATE
                 * =========================================
                 */
                LocalDate today =
                        LocalDate.now();


                if (suggestedLocalDate.isBefore(today)) {

                    setError(
                            session,
                            "Suggested appointment date cannot be in the past."
                    );

                    redirectToPendingAppointments(
                            request,
                            response
                    );

                    return;
                }


                /*
                 * =========================================
                 * IF TODAY, PREVENT PAST TIME
                 * =========================================
                 */
                if (suggestedLocalDate.equals(today)
                        && suggestedLocalTime
                                .isBefore(LocalTime.now())) {

                    setError(
                            session,
                            "Suggested appointment time must be in the future."
                    );

                    redirectToPendingAppointments(
                            request,
                            response
                    );

                    return;
                }


                Date suggestedDate =
                        Date.valueOf(
                                suggestedLocalDate
                        );

                Time suggestedTime =
                        Time.valueOf(
                                suggestedLocalTime
                        );


                /*
                 * =========================================
                 * CHECK SUGGESTED SLOT AVAILABILITY
                 * =========================================
                 */
                boolean slotAvailable =
                        appointmentDAO
                                .isSuggestedSlotAvailable(
                                        assistantUserId,
                                        appointmentId,
                                        suggestedDate,
                                        suggestedTime
                                );


                if (!slotAvailable) {

                    setError(
                            session,
                            "The suggested date and time are not available "
                            + "for this dentist. Please choose another slot."
                    );

                    redirectToPendingAppointments(
                            request,
                            response
                    );

                    return;
                }


                /*
                 * =========================================
                 * CLEAN ASSISTANT NOTE
                 * =========================================
                 */
                if (assistantNote != null) {

                    assistantNote =
                            assistantNote.trim();

                    if (assistantNote.isEmpty()) {

                        assistantNote = null;
                    }
                }


                /*
                 * =========================================
                 * SAVE RESCHEDULE REQUEST
                 * =========================================
                 */
                boolean rescheduled =
                        appointmentDAO
                                .rescheduleAppointmentByAssistant(
                                        assistantUserId,
                                        appointmentId,
                                        suggestedDate,
                                        suggestedTime,
                                        assistantNote
                                );


                if (rescheduled) {

                    session.setAttribute(
                            "appointmentUpdateSuccess",
                            "New appointment date and time suggested successfully."
                    );

                } else {

                    setError(
                            session,
                            "Unable to send the reschedule suggestion. "
                            + "The appointment may already have been updated "
                            + "or may not belong to your assigned dentist."
                    );
                }


                redirectToPendingAppointments(
                        request,
                        response
                );

                return;
            }


            /*
             * =========================================
             * INVALID ACTION
             * =========================================
             */
            setError(
                    session,
                    "Invalid appointment action."
            );

            redirectToPendingAppointments(
                    request,
                    response
            );


        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid appointment ID."
            );

            redirectToPendingAppointments(
                    request,
                    response
            );


        } catch (IllegalArgumentException e) {

            setError(
                    session,
                    "Invalid date or time selected."
            );

            redirectToPendingAppointments(
                    request,
                    response
            );


        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while updating the appointment."
            );

            redirectToPendingAppointments(
                    request,
                    response
            );
        }
    }


    /*
     * =========================================
     * SET ERROR MESSAGE
     * =========================================
     */
    private void setError(
            HttpSession session,
            String message) {

        session.setAttribute(
                "appointmentUpdateError",
                message
        );
    }


    /*
     * =========================================
     * REDIRECT BACK TO PENDING APPOINTMENTS
     * =========================================
     */
    private void redirectToPendingAppointments(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/assistant/PendingAppointments"
        );
    }
}