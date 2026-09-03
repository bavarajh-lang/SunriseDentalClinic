<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String role =
            String.valueOf(
                    session.getAttribute("role")
            );

    String dashboardUrl =
            request.getContextPath();

    if ("ADMIN".equals(role)) {

        dashboardUrl +=
                "/admin/Dashboard";

    } else if ("ASSISTANT".equals(role)) {

        dashboardUrl +=
                "/assistant/Dashboard";

    } else if ("CASHIER".equals(role)) {

        dashboardUrl +=
                "/cashier/Dashboard";

    } else if ("PATIENT".equals(role)) {

        dashboardUrl +=
                "/patient/dashboard.jsp";

    } else {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
        );

        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Help | Sunrise Dental Clinic
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f8fb;
            color: #1f2937;
        }

        .topbar {
            background: #0f5f87;
            color: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 21px;
            font-weight: bold;
        }

        .links {
            display: flex;
            gap: 18px;
            align-items: center;
        }

        .links a {
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 35px 25px;
        }

        .header {
            margin-bottom: 25px;
        }

        .header h1 {
            color: #0f5f87;
            font-size: 32px;
            margin-bottom: 7px;
        }

        .header p {
            color: #6b7280;
            line-height: 1.6;
        }

        .role-box {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .role-box strong {
            color: #0f5f87;
        }

        .help-grid {
            display: grid;
            grid-template-columns: repeat(2,1fr);
            gap: 20px;
        }

        .help-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .help-card h2 {
            color: #0f5f87;
            font-size: 18px;
            margin-bottom: 12px;
        }

        .help-card p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.7;
            margin-bottom: 8px;
        }

        .steps {
            padding-left: 20px;
            color: #4b5563;
            font-size: 13px;
            line-height: 1.8;
        }

        .notice {
            margin-top: 25px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .notice h3 {
            color: #0f5f87;
            margin-bottom: 9px;
        }

        .notice p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.7;
        }

        @media(max-width: 750px) {

            .help-grid {
                grid-template-columns: 1fr;
            }

            .topbar {
                padding: 16px 20px;
            }

            .container {
                padding: 25px 18px;
            }
        }

    </style>

</head>

<body>

<div class="topbar">

    <div class="logo">
        Sunrise Dental Clinic
    </div>

    <div class="links">

        <a href="<%= dashboardUrl %>">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/LogoutServlet">
            Logout
        </a>

    </div>

</div>

<div class="container">

    <div class="header">

        <h1>
            System Help
        </h1>

        <p>
            Guidance for using the Sunrise Dental Clinic
            appointment, treatment and billing system.
        </p>

    </div>

    <div class="role-box">

        Logged in as:

        <strong>
            <%= role %>
        </strong>

    </div>

    <div class="help-grid">

        <div class="help-card">

            <h2>
                Patient Appointments
            </h2>

            <ol class="steps">

                <li>
                    Patient logs in to the system.
                </li>

                <li>
                    Select dentist, requested dental service,
                    date and available time.
                </li>

                <li>
                    Submit the appointment request.
                </li>

                <li>
                    The request remains pending until reviewed
                    by the assigned dentist assistant.
                </li>

            </ol>

        </div>

        <div class="help-card">

            <h2>
                Appointment Management
            </h2>

            <ol class="steps">

                <li>
                    Dentist assistant reviews pending requests.
                </li>

                <li>
                    Confirm, suggest another date/time or
                    cancel the request when necessary.
                </li>

                <li>
                    Confirmed appointments are available for
                    treatment recording.
                </li>

            </ol>

        </div>

        <div class="help-card">

            <h2>
                Treatment & Billing
            </h2>

            <ol class="steps">

                <li>
                    Assistant records diagnosis and actual
                    treatment after the dentist completes treatment.
                </li>

                <li>
                    Additional treatment items may be added.
                </li>

                <li>
                    A patient bill is generated from consultation
                    and actual treatment items.
                </li>

                <li>
                    The cashier processes the final payment.
                </li>

            </ol>

        </div>

        <div class="help-card">

            <h2>
                Payment & Receipt
            </h2>

            <ol class="steps">

                <li>
                    Cashier selects an unpaid patient bill.
                </li>

                <li>
                    Choose Cash, Card or Bank Transfer.
                </li>

                <li>
                    Complete the payment.
                </li>

                <li>
                    Open or print the receipt and use the
                    secure QR code for the digital receipt.
                </li>

            </ol>

        </div>

        <div class="help-card">

            <h2>
                Appointment Search
            </h2>

            <p>
                Authorized clinic staff can use Appointment Search
                to find a record using its appointment number.
            </p>

            <p>
                The result includes patient, dentist, requested
                service, schedule and appointment status information.
            </p>

        </div>

        <div class="help-card">

            <h2>
                Administrator Features
            </h2>

            <p>
                Administrators can manage dentists, assistants
                and cashiers, review patients and appointments,
                inspect payment records, generate reports and
                view system audit logs.
            </p>

        </div>

    </div>

    <div class="notice">

        <h3>
            Safe Logout
        </h3>

        <p>
            Always use the Logout option after completing clinic
            work, especially when using a shared computer.
            The system session also expires after inactivity.
        </p>

    </div>

</div>

</body>

</html>