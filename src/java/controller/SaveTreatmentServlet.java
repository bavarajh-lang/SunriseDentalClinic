package controller;

import dao.TreatmentDAO;
import model.TreatmentItem;
import model.TreatmentRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/assistant/SaveTreatmentServlet")
public class SaveTreatmentServlet extends HttpServlet {

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

        if (!"ASSISTANT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only dentist assistants can record treatments."
            );

            return;
        }

        try {

            String appointmentIdValue =
                    request.getParameter("appointmentId");

            String diagnosis =
                    request.getParameter("diagnosis");

            String treatmentNotes =
                    request.getParameter("treatmentNotes");

            String dentistNotes =
                    request.getParameter("dentistNotes");

            if (appointmentIdValue == null
                    || appointmentIdValue.trim().isEmpty()) {

                setError(
                        session,
                        "Invalid appointment selected."
                );

                redirectConfirmed(
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

                redirectConfirmed(
                        request,
                        response
                );

                return;
            }

            if (diagnosis == null
                    || diagnosis.trim().isEmpty()) {

                setError(
                        session,
                        "Diagnosis is required."
                );

                redirectTreatmentForm(
                        request,
                        response,
                        appointmentId
                );

                return;
            }

            if (treatmentNotes == null
                    || treatmentNotes.trim().isEmpty()) {

                setError(
                        session,
                        "Treatment notes are required."
                );

                redirectTreatmentForm(
                        request,
                        response,
                        appointmentId
                );

                return;
            }

            String[] serviceIdValues =
                    request.getParameterValues("serviceId");

            String[] itemNames =
                    request.getParameterValues("itemName");

            String[] quantities =
                    request.getParameterValues("quantity");

            String[] unitPrices =
                    request.getParameterValues("unitPrice");

            String[] descriptions =
                    request.getParameterValues("description");

            if (serviceIdValues == null
                    || itemNames == null
                    || quantities == null
                    || unitPrices == null
                    || serviceIdValues.length == 0) {

                setError(
                        session,
                        "At least one treatment item is required."
                );

                redirectTreatmentForm(
                        request,
                        response,
                        appointmentId
                );

                return;
            }

            int itemCount =
                    serviceIdValues.length;

            if (itemNames.length != itemCount
                    || quantities.length != itemCount
                    || unitPrices.length != itemCount) {

                setError(
                        session,
                        "Invalid treatment item information."
                );

                redirectTreatmentForm(
                        request,
                        response,
                        appointmentId
                );

                return;
            }

            List<TreatmentItem> treatmentItems =
                    new ArrayList<>();

            for (int i = 0; i < itemCount; i++) {

                String serviceValue =
                        serviceIdValues[i];

                String itemName =
                        itemNames[i];

                String quantityValue =
                        quantities[i];

                String unitPriceValue =
                        unitPrices[i];

                String description = null;

                if (descriptions != null
                        && i < descriptions.length) {

                    description =
                            cleanValue(
                                    descriptions[i]
                            );
                }

                if (serviceValue == null
                        || serviceValue.trim().isEmpty()) {

                    setError(
                            session,
                            "Please select a treatment for every item."
                    );

                    redirectTreatmentForm(
                            request,
                            response,
                            appointmentId
                    );

                    return;
                }

                if (itemName == null
                        || itemName.trim().isEmpty()) {

                    setError(
                            session,
                            "Treatment name is required."
                    );

                    redirectTreatmentForm(
                            request,
                            response,
                            appointmentId
                    );

                    return;
                }

                int quantity =
                        Integer.parseInt(
                                quantityValue.trim()
                        );

                if (quantity <= 0
                        || quantity > 100) {

                    setError(
                            session,
                            "Treatment quantity must be between 1 and 100."
                    );

                    redirectTreatmentForm(
                            request,
                            response,
                            appointmentId
                    );

                    return;
                }

                BigDecimal unitPrice =
                        new BigDecimal(
                                unitPriceValue.trim()
                        );

                if (unitPrice.compareTo(
                        BigDecimal.ZERO) < 0) {

                    setError(
                            session,
                            "Treatment price cannot be negative."
                    );

                    redirectTreatmentForm(
                            request,
                            response,
                            appointmentId
                    );

                    return;
                }

                Integer serviceId = null;

                if (!"CUSTOM".equalsIgnoreCase(
                        serviceValue.trim())) {

                    serviceId =
                            Integer.valueOf(
                                    serviceValue.trim()
                            );

                    if (serviceId <= 0) {

                        setError(
                                session,
                                "Invalid dental service selected."
                        );

                        redirectTreatmentForm(
                                request,
                                response,
                                appointmentId
                        );

                        return;
                    }
                }

                TreatmentItem treatmentItem =
                        new TreatmentItem();

                treatmentItem.setServiceId(
                        serviceId
                );

                treatmentItem.setItemName(
                        itemName.trim()
                );

                treatmentItem.setDescription(
                        description
                );

                treatmentItem.setQuantity(
                        quantity
                );

                treatmentItem.setUnitPrice(
                        unitPrice.doubleValue()
                );

                treatmentItem.calculateLineTotal();

                treatmentItems.add(
                        treatmentItem
                );
            }

            TreatmentRecord treatmentRecord =
                    new TreatmentRecord();

            treatmentRecord.setAppointmentId(
                    appointmentId
            );

            treatmentRecord.setDiagnosis(
                    diagnosis.trim()
            );

            treatmentRecord.setTreatmentNotes(
                    treatmentNotes.trim()
            );

            treatmentRecord.setDentistNotes(
                    cleanValue(
                            dentistNotes
                    )
            );

            int assistantUserId =
                    (Integer) session.getAttribute("userId");

            TreatmentDAO treatmentDAO =
                    new TreatmentDAO();

            boolean saved =
                    treatmentDAO.saveTreatment(
                            assistantUserId,
                            treatmentRecord,
                            treatmentItems
                    );

            if (saved) {

                session.setAttribute(
                        "treatmentSuccess",
                        "Treatment record saved successfully. "
                        + "The appointment has been marked as COMPLETED."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/ConfirmedAppointments"
                );

            } else {

                setError(
                        session,
                        "Unable to save the treatment. "
                        + "The appointment may already be completed "
                        + "or may not belong to your assigned dentist."
                );

                redirectTreatmentForm(
                        request,
                        response,
                        appointmentId
                );
            }

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Please enter valid quantity and price values."
            );

            redirectConfirmed(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while saving the treatment."
            );

            redirectConfirmed(
                    request,
                    response
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

    private void setError(
            HttpSession session,
            String message) {

        session.setAttribute(
                "treatmentError",
                message
        );
    }

    private void redirectConfirmed(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/assistant/ConfirmedAppointments"
        );
    }

    private void redirectTreatmentForm(
            HttpServletRequest request,
            HttpServletResponse response,
            int appointmentId)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/assistant/RecordTreatment?appointmentId="
                + appointmentId
        );
    }
}