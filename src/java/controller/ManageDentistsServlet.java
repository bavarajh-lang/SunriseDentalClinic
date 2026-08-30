package controller;

import dao.DentistDAO;
import model.Dentist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/ManageDentists")
public class ManageDentistsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        DentistDAO dentistDAO = new DentistDAO();

        List<Dentist> dentists =
                dentistDAO.getAllDentists();

        request.setAttribute(
                "dentists",
                dentists
        );

        request.getRequestDispatcher(
                "/admin/manage-dentists.jsp"
        ).forward(request, response);
    }
}