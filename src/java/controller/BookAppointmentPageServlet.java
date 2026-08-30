package controller;

import dao.DentalServiceDAO;
import dao.DentistDAO;

import model.DentalService;
import model.Dentist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/BookAppointment")
public class BookAppointmentPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        DentalServiceDAO dentalServiceDAO =
                new DentalServiceDAO();

        DentistDAO dentistDAO =
                new DentistDAO();

        List<DentalService> services =
                dentalServiceDAO.getActiveServices();

        List<Dentist> dentists =
                dentistDAO.getActiveDentists();

        request.setAttribute(
                "services",
                services
        );

        request.setAttribute(
                "dentists",
                dentists
        );

        request.getRequestDispatcher(
                "/patient/book-appointment.jsp"
        ).forward(request, response);
    }
}