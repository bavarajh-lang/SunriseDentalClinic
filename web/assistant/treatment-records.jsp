<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.TreatmentRecord"%>
<%@page import="model.TreatmentItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<TreatmentRecord> treatmentRecords =
            (List<TreatmentRecord>) request.getAttribute("treatmentRecords");

    String treatmentRecordsError =
            (String) request.getAttribute("treatmentRecordsError");

    String billError =
            (String) session.getAttribute("billError");

    String billSuccess =
            (String) session.getAttribute("billSuccess");

    SimpleDateFormat completedDateFormat =
            new SimpleDateFormat("dd MMM yyyy - hh:mm a");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Treatment Records | Sunrise Dental Clinic
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        html,
        body {
            width: 100%;
            min-height: 100%;
            overflow-x: hidden;
        }

        body {
            background: #f4f8fb;
            color: #1f2937;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            min-width: 260px;
            background: #0f5f87;
            color: white;
            padding: 25px 20px;
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 35px;
        }

        .menu a {
            display: block;
            text-decoration: none;
            color: white;
            padding: 12px 14px;
            margin-bottom: 7px;
            border-radius: 6px;
            transition: 0.2s;
        }

        .menu a:hover,
        .menu .active {
            background: rgba(255,255,255,0.18);
        }

        .main {
            flex: 1;
            min-width: 0;
        }

        .topbar {
            background: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }

        .welcome {
            font-weight: bold;
        }

        .logout {
            color: #b91c1c;
            text-decoration: none;
            font-weight: bold;
        }

        .content {
            padding: 30px;
            min-width: 0;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 6px;
            font-size: 32px;
        }

        .page-title p {
            color: #6b7280;
            line-height: 1.5;
        }

        .success-message {
            background: #ecfdf3;
            border: 1px solid #86efac;
            color: #166534;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 22px;
            line-height: 1.5;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 7px;
            margin-bottom: 22px;
            line-height: 1.5;
        }

        .records {
            display: grid;
            gap: 24px;
        }

        .record-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            min-width: 0;
        }

        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            padding-bottom: 18px;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
        }

        .record-number {
            color: #0f5f87;
            font-size: 19px;
            margin-bottom: 6px;
        }

        .patient-number {
            color: #6b7280;
            font-size: 13px;
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            background: #dbeafe;
            color: #1e40af;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 20px;
        }

        .detail-box {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
        }

        .detail-label {
            display: block;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            color: #6b7280;
            margin-bottom: 7px;
        }

        .detail-value {
            font-size: 14px;
            color: #1f2937;
            line-height: 1.5;
        }

        .clinical-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }

        .clinical-box {
            background: #f9fafb;
            border-radius: 8px;
            padding: 16px;
        }

        .clinical-box.full {
            grid-column: 1 / -1;
        }

        .clinical-box h4 {
            color: #0f5f87;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .clinical-box p {
            color: #4b5563;
            font-size: 14px;
            line-height: 1.6;
            white-space: pre-line;
        }

        .requested-service {
            background: #eef7fb;
            border-left: 4px solid #0f5f87;
            padding: 15px;
            border-radius: 7px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .requested-service strong {
            color: #0f5f87;
        }

        .treatment-section {
            margin-top: 10px;
        }

        .treatment-section h3 {
            color: #0f5f87;
            margin-bottom: 15px;
            font-size: 17px;
        }

        .table-wrapper {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 700px;
        }

        th {
            background: #eef7fb;
            color: #374151;
            text-align: left;
            padding: 12px;
            font-size: 12px;
            border-bottom: 1px solid #dbe4ea;
        }

        td {
            padding: 13px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
            vertical-align: top;
        }

        .custom-badge {
            display: inline-block;
            margin-left: 6px;
            padding: 3px 7px;
            background: #fef3c7;
            color: #92400e;
            border-radius: 12px;
            font-size: 10px;
            font-weight: bold;
        }

        .amount {
            font-weight: bold;
            color: #374151;
            white-space: nowrap;
        }

        .total-box {
            margin-top: 18px;
            display: flex;
            justify-content: flex-end;
        }

        .total-content {
            min-width: 280px;
            background: #eef7fb;
            border-radius: 8px;
            padding: 16px 18px;
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: center;
        }

        .total-content span {
            color: #4b5563;
            font-weight: bold;
        }

        .total-content strong {
            color: #0f5f87;
            font-size: 20px;
        }

        .completed-box {
            margin-top: 20px;
            background: #ecfdf3;
            border-left: 4px solid #16a34a;
            padding: 14px 16px;
            border-radius: 7px;
            color: #166534;
            font-size: 13px;
            line-height: 1.5;
        }

        .billing-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .billing-info h4 {
            color: #0f5f87;
            margin-bottom: 6px;
            font-size: 15px;
        }

        .billing-info p {
            color: #6b7280;
            font-size: 12px;
            line-height: 1.5;
            max-width: 600px;
        }

        .bill-form {
            flex-shrink: 0;
        }

        .btn-bill {
            border: none;
            background: #0f5f87;
            color: white;
            padding: 11px 18px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
            white-space: nowrap;
        }

        .btn-bill:hover {
            background: #0b4f71;
            transform: translateY(-1px);
        }

        .empty-state {
            background: white;
            border-radius: 12px;
            padding: 55px 25px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .empty-state h2 {
            color: #0f5f87;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6b7280;
            line-height: 1.6;
        }

        @media(max-width: 1100px) {

            .details-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 700px) {

            .sidebar {
                display: none;
            }

            .content {
                padding: 20px;
            }

            .topbar {
                padding: 16px 20px;
            }

            .record-header {
                flex-direction: column;
            }

            .details-grid,
            .clinical-grid {
                grid-template-columns: 1fr;
            }

            .clinical-box.full {
                grid-column: auto;
            }

            .total-box {
                justify-content: stretch;
            }

            .total-content {
                width: 100%;
                min-width: 0;
            }

            .billing-section {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-bill {
                width: 100%;
            }
        }

    </style>

</head>

<body>

<div class="layout">

    <aside class="sidebar">

        <div class="logo">
            Sunrise Dental
        </div>

        <nav class="menu">

            <a href="<%= request.getContextPath() %>/assistant/dashboard.jsp">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/assistant/PendingAppointments">
                Pending Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/ConfirmedAppointments">
                Confirmed Appointments
            </a>

            <a href="<%= request.getContextPath() %>/assistant/TreatmentRecords"
               class="active">
                Treatment Records
            </a>

            <a href="<%= request.getContextPath() %>/assistant/create-bill.jsp">
                Create Bill
            </a>

            <a href="<%= request.getContextPath() %>/assistant/patient-history.jsp">
                Patient History
            </a>

            <a href="<%= request.getContextPath() %>/assistant/notifications.jsp">
                Notifications
            </a>

        </nav>

    </aside>

    <main class="main">

        <div class="topbar">

            <div class="welcome">

                Welcome,
                <%= session.getAttribute("fullName") %>

            </div>

            <a href="<%= request.getContextPath() %>/LogoutServlet"
               class="logout">

                Logout

            </a>

        </div>

        <div class="content">

            <div class="page-title">

                <h1>
                    Treatment Records
                </h1>

                <p>
                    View completed treatments recorded for patients
                    of your assigned dentist and generate patient bills.
                </p>

            </div>

            <%
                if (treatmentRecordsError != null) {
            %>

            <div class="error-message">

                <strong>
                    Error!
                </strong>

                <br>

                <%= treatmentRecordsError %>

            </div>

            <%
                }
            %>

            <%
                if (billError != null) {
            %>

            <div class="error-message">

                <strong>
                    Billing Error
                </strong>

                <br>

                <%= billError %>

            </div>

            <%
                    session.removeAttribute("billError");
                }
            %>

            <%
                if (billSuccess != null) {
            %>

            <div class="success-message">

                <strong>
                    Success!
                </strong>

                <br>

                <%= billSuccess %>

            </div>

            <%
                    session.removeAttribute("billSuccess");
                }
            %>

            <%
                if (treatmentRecords != null
                        && !treatmentRecords.isEmpty()) {
            %>

            <div class="records">

                <%
                    for (TreatmentRecord record : treatmentRecords) {
                %>

                <div class="record-card">

                    <div class="record-header">

                        <div>

                            <h2 class="record-number">

                                <%= record.getAppointmentNo() %>

                            </h2>

                            <div class="patient-number">

                                Patient No:

                                <strong>
                                    <%= record.getPatientNo() %>
                                </strong>

                            </div>

                        </div>

                        <span class="status">
                            COMPLETED
                        </span>

                    </div>

                    <div class="details-grid">

                        <div class="detail-box">

                            <span class="detail-label">
                                Patient Name
                            </span>

                            <span class="detail-value">

                                <%= record.getPatientName() %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Dentist
                            </span>

                            <span class="detail-value">

                                Dr.
                                <%= record.getDentistName() %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Appointment Date
                            </span>

                            <span class="detail-value">

                                <%= record.getAppointmentDate() %>

                            </span>

                        </div>

                        <div class="detail-box">

                            <span class="detail-label">
                                Treatment Record ID
                            </span>

                            <span class="detail-value">

                                TR-
                                <%= String.format(
                                        "%05d",
                                        record.getTreatmentRecordId()
                                ) %>

                            </span>

                        </div>

                    </div>

                    <div class="requested-service">

                        <strong>
                            Patient Requested Service:
                        </strong>

                        <%= record.getRequestedServiceName() %>

                    </div>

                    <div class="clinical-grid">

                        <div class="clinical-box">

                            <h4>
                                Diagnosis
                            </h4>

                            <p>

                                <%
                                    if (record.getDiagnosis() != null
                                            && !record.getDiagnosis()
                                            .trim()
                                            .isEmpty()) {
                                %>

                                <%= record.getDiagnosis() %>

                                <%
                                    } else {
                                %>

                                No diagnosis recorded.

                                <%
                                    }
                                %>

                            </p>

                        </div>

                        <div class="clinical-box">

                            <h4>
                                Treatment Notes
                            </h4>

                            <p>

                                <%
                                    if (record.getTreatmentNotes() != null
                                            && !record.getTreatmentNotes()
                                            .trim()
                                            .isEmpty()) {
                                %>

                                <%= record.getTreatmentNotes() %>

                                <%
                                    } else {
                                %>

                                No treatment notes recorded.

                                <%
                                    }
                                %>

                            </p>

                        </div>

                        <div class="clinical-box full">

                            <h4>
                                Dentist Notes
                            </h4>

                            <p>

                                <%
                                    if (record.getDentistNotes() != null
                                            && !record.getDentistNotes()
                                            .trim()
                                            .isEmpty()) {
                                %>

                                <%= record.getDentistNotes() %>

                                <%
                                    } else {
                                %>

                                No additional dentist notes.

                                <%
                                    }
                                %>

                            </p>

                        </div>

                    </div>

                    <div class="treatment-section">

                        <h3>
                            Actual Treatments Performed
                        </h3>

                        <%
                            List<TreatmentItem> items =
                                    record.getTreatmentItems();

                            if (items != null
                                    && !items.isEmpty()) {
                        %>

                        <div class="table-wrapper">

                            <table>

                                <thead>

                                    <tr>

                                        <th>
                                            Treatment
                                        </th>

                                        <th>
                                            Description
                                        </th>

                                        <th>
                                            Quantity
                                        </th>

                                        <th>
                                            Unit Price
                                        </th>

                                        <th>
                                            Total
                                        </th>

                                    </tr>

                                </thead>

                                <tbody>

                                    <%
                                        for (TreatmentItem item : items) {
                                    %>

                                    <tr>

                                        <td>

                                            <%= item.getItemName() %>

                                            <%
                                                if (item.getServiceId() == null) {
                                            %>

                                            <span class="custom-badge">
                                                EXTRA
                                            </span>

                                            <%
                                                }
                                            %>

                                        </td>

                                        <td>

                                            <%
                                                if (item.getDescription() != null
                                                        && !item.getDescription()
                                                        .trim()
                                                        .isEmpty()) {
                                            %>

                                            <%= item.getDescription() %>

                                            <%
                                                } else {
                                            %>

                                            -

                                            <%
                                                }
                                            %>

                                        </td>

                                        <td>

                                            <%= item.getQuantity() %>

                                        </td>

                                        <td class="amount">

                                            Rs.
                                            <%= String.format(
                                                    "%.2f",
                                                    item.getUnitPrice()
                                            ) %>

                                        </td>

                                        <td class="amount">

                                            Rs.
                                            <%= String.format(
                                                    "%.2f",
                                                    item.getLineTotal()
                                            ) %>

                                        </td>

                                    </tr>

                                    <%
                                        }
                                    %>

                                </tbody>

                            </table>

                        </div>

                        <div class="total-box">

                            <div class="total-content">

                                <span>
                                    Treatment Total
                                </span>

                                <strong>

                                    Rs.
                                    <%= String.format(
                                            "%.2f",
                                            record.getTreatmentTotal()
                                    ) %>

                                </strong>

                            </div>

                        </div>

                        <%
                            } else {
                        %>

                        <div class="error-message">
                            No treatment items found for this record.
                        </div>

                        <%
                            }
                        %>

                    </div>

                    <%
                        if (record.getCompletedAt() != null) {
                    %>

                    <div class="completed-box">

                        Treatment completed on

                        <strong>

                            <%= completedDateFormat.format(
                                    record.getCompletedAt()
                            ) %>

                        </strong>

                    </div>

                    <%
                        }
                    %>

                    <div class="billing-section">

                        <div class="billing-info">

                            <h4>
                                Patient Billing
                            </h4>

                            <p>
                                Generate the bill using the dentist
                                consultation fee and the treatments
                                recorded above. If a bill already exists,
                                the existing bill will be opened.
                            </p>

                        </div>

                        <form action="<%= request.getContextPath() %>/assistant/GenerateBill"
                              method="post"
                              class="bill-form">

                            <input type="hidden"
                                   name="appointmentId"
                                   value="<%= record.getAppointmentId() %>">

                            <button type="submit"
                                    class="btn-bill">

                                Generate / View Bill

                            </button>

                        </form>

                    </div>

                </div>

                <%
                    }
                %>

            </div>

            <%
                } else {
            %>

            <div class="empty-state">

                <h2>
                    No Treatment Records
                </h2>

                <p>
                    No completed treatments have been recorded
                    for your assigned dentist yet.
                </p>

            </div>

            <%
                }
            %>

        </div>

    </main>

</div>

</body>

</html>