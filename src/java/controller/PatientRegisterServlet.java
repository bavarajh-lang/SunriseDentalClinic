package controller;

import dao.PatientDAO;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/PatientRegisterServlet")
public class PatientRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String emergencyContactName =
                request.getParameter("emergencyContactName");
        String emergencyContactPhone =
                request.getParameter("emergencyContactPhone");

        if (fullName == null || fullName.trim().isEmpty()
                || username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please complete all required fields."
            );

            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);

            return;
        }

        Patient patient = new Patient(
                fullName.trim(),
                username.trim(),
                email.trim(),
                password,
                phone,
                dateOfBirth,
                gender,
                address,
                emergencyContactName,
                emergencyContactPhone
        );

        PatientDAO patientDAO = new PatientDAO();

        boolean registered =
                patientDAO.registerPatient(patient);

        if (registered) {

            request.setAttribute(
                    "successMessage",
                    "Registration successful. You can now login."
            );

            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);

        } else {

            request.setAttribute(
                    "errorMessage",
                    "Registration failed. Username or email may already exist."
            );

            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);
        }
    }
}