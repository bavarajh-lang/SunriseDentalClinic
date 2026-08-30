package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
    "/admin/*",
    "/patient/*",
    "/assistant/*",
    "/cashier/*"
})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        String contextPath =
                httpRequest.getContextPath();

        if (session == null ||
                session.getAttribute("user") == null) {

            httpResponse.sendRedirect(
                    contextPath + "/login.jsp"
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");

        String uri =
                httpRequest.getRequestURI();

        boolean allowed = false;

        if (uri.startsWith(contextPath + "/admin/")
                && "ADMIN".equals(role)) {

            allowed = true;

        } else if (uri.startsWith(contextPath + "/patient/")
                && "PATIENT".equals(role)) {

            allowed = true;

        } else if (uri.startsWith(contextPath + "/assistant/")
                && "ASSISTANT".equals(role)) {

            allowed = true;

        } else if (uri.startsWith(contextPath + "/cashier/")
                && "CASHIER".equals(role)) {

            allowed = true;
        }

        if (!allowed) {

            httpResponse.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to access this page."
            );

            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}