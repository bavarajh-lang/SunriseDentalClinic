<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null ||
        !"ASSISTANT".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assistant Dashboard | Sunrise Dental Clinic</title>

    <style>
        *{
            box-sizing:border-box;
            margin:0;
            padding:0;
            font-family:Arial,sans-serif;
        }

        body{
            background:#f4f8fb;
            color:#1f2937;
        }

        .layout{
            display:flex;
            min-height:100vh;
        }

        .sidebar{
            width:260px;
            background:#0f5f87;
            color:white;
            padding:25px 20px;
        }

        .logo{
            font-size:22px;
            font-weight:bold;
            margin-bottom:35px;
        }

        .menu a{
            display:block;
            color:white;
            text-decoration:none;
            padding:12px 14px;
            margin-bottom:7px;
            border-radius:6px;
        }

        .menu a:hover,
        .menu .active{
            background:rgba(255,255,255,.18);
        }

        .main{
            flex:1;
        }

        .topbar{
            background:white;
            padding:18px 30px;
            display:flex;
            justify-content:space-between;
            box-shadow:0 2px 10px rgba(0,0,0,.06);
        }

        .logout{
            color:#b91c1c;
            text-decoration:none;
            font-weight:bold;
        }

        .content{
            padding:30px;
        }

        h1{
            color:#0f5f87;
            margin-bottom:5px;
        }

        .subtitle{
            color:#6b7280;
            margin-bottom:25px;
        }

        .stats{
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:18px;
            margin-bottom:30px;
        }

        .card{
            background:white;
            padding:22px;
            border-radius:10px;
            box-shadow:0 5px 20px rgba(0,0,0,.06);
        }

        .card h3{
            font-size:14px;
            color:#6b7280;
            margin-bottom:10px;
        }

        .card p{
            font-size:28px;
            font-weight:bold;
            color:#0f5f87;
        }

        .section{
            background:white;
            padding:25px;
            border-radius:10px;
            box-shadow:0 5px 20px rgba(0,0,0,.06);
        }

        .actions{
            display:grid;
            grid-template-columns:repeat(3,1fr);
            gap:15px;
        }

        .action{
            text-decoration:none;
            background:#eef7fb;
            padding:20px;
            border-radius:8px;
            color:#1f2937;
        }

        .action h3{
            color:#0f5f87;
            margin-bottom:6px;
        }

        .action p{
            color:#6b7280;
            font-size:13px;
        }
    </style>
</head>

<body>

<div class="layout">

    <aside class="sidebar">

        <div class="logo">Sunrise Dental</div>

        <nav class="menu">
            <a class="active" href="dashboard.jsp">Dashboard</a>
            <a href="pending-appointments.jsp">Pending Appointments</a>
            <a href="confirmed-appointments.jsp">Confirmed Appointments</a>
            <a href="treatment-records.jsp">Treatment Records</a>
            <a href="create-bill.jsp">Create Bill</a>
            <a href="patient-history.jsp">Patient History</a>
            <a href="notifications.jsp">Notifications</a>
        </nav>

    </aside>

    <main class="main">

        <div class="topbar">

            <strong>
                Welcome, <%= session.getAttribute("fullName") %>
            </strong>

            <a href="../LogoutServlet" class="logout">Logout</a>

        </div>

        <div class="content">

            <h1>Dentist Assistant Dashboard</h1>

            <p class="subtitle">
                Manage your assigned dentist's appointments and treatment records.
            </p>

            <div class="stats">

                <div class="card">
                    <h3>Pending Requests</h3>
                    <p>0</p>
                </div>

                <div class="card">
                    <h3>Today's Confirmed</h3>
                    <p>0</p>
                </div>

                <div class="card">
                    <h3>Completed Treatments</h3>
                    <p>0</p>
                </div>

                <div class="card">
                    <h3>Bills to Generate</h3>
                    <p>0</p>
                </div>

            </div>

            <div class="section">

                <h2 style="color:#0f5f87;margin-bottom:18px;">
                    Quick Actions
                </h2>

                <div class="actions">

                    <a href="pending-appointments.jsp" class="action">
                        <h3>Pending Appointments</h3>
                        <p>Check requested dates and dentist availability.</p>
                    </a>

                    <a href="confirmed-appointments.jsp" class="action">
                        <h3>Confirmed Appointments</h3>
                        <p>View confirmed appointments for your dentist.</p>
                    </a>

                    <a href="treatment-records.jsp" class="action">
                        <h3>Record Treatment</h3>
                        <p>Add diagnosis and actual dental work performed.</p>
                    </a>

                    <a href="create-bill.jsp" class="action">
                        <h3>Prepare Bill</h3>
                        <p>Create bill from completed treatment items.</p>
                    </a>

                    <a href="patient-history.jsp" class="action">
                        <h3>Patient History</h3>
                        <p>Review previous appointment and treatment history.</p>
                    </a>

                </div>

            </div>

        </div>

    </main>

</div>

</body>
</html>