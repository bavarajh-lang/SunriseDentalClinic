<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Patient Dashboard | Sunrise Dental Clinic</title>

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

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: #0f5f87;
            color: white;
            padding: 25px 20px;
        }

        .logo {
            font-size: 21px;
            font-weight: bold;
            margin-bottom: 35px;
        }

        .menu a {
            display: block;
            text-decoration: none;
            color: white;
            padding: 12px 14px;
            margin-bottom: 8px;
            border-radius: 6px;
        }

        .menu a:hover {
            background: rgba(255,255,255,0.15);
        }

        .menu .active {
            background: rgba(255,255,255,0.20);
        }

        .main {
            flex: 1;
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
            text-decoration: none;
            color: #b91c1c;
            font-weight: bold;
        }

        .content {
            padding: 30px;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #0f5f87;
            margin-bottom: 5px;
        }

        .page-title p {
            color: #6b7280;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 22px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .stat-card h3 {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .stat-card p {
            font-size: 28px;
            font-weight: bold;
            color: #0f5f87;
        }

        .quick-actions {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
        }

        .quick-actions h2 {
            margin-bottom: 20px;
            color: #0f5f87;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .action-card {
            text-decoration: none;
            background: #eef7fb;
            padding: 20px;
            border-radius: 8px;
            color: #1f2937;
            transition: 0.2s;
        }

        .action-card:hover {
            transform: translateY(-2px);
            background: #dceff7;
        }

        .action-card h3 {
            color: #0f5f87;
            margin-bottom: 7px;
        }

        .action-card p {
            font-size: 13px;
            color: #6b7280;
            line-height: 1.4;
        }

        .section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .section h2 {
            color: #0f5f87;
            margin-bottom: 18px;
        }

        .empty-state {
            padding: 25px;
            background: #f9fafb;
            border-radius: 8px;
            color: #6b7280;
            text-align: center;
        }

        @media(max-width: 950px) {
            .stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .action-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media(max-width: 700px) {
            .sidebar {
                display: none;
            }

            .stats,
            .action-grid {
                grid-template-columns: 1fr;
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
            <a href="dashboard.jsp" class="active">Dashboard</a>
            <a href="<%= request.getContextPath() %>/BookAppointment">
        Book Appointment
    </a>
            <a href="<%= request.getContextPath() %>/patient/MyAppointments">
    My Appointments
</a>
            <a href="treatment-history.jsp">Treatment History</a>
            <a href="my-bills.jsp">My Bills</a>
            <a href="notifications.jsp">Notifications</a>
            <a href="profile.jsp">My Profile</a>
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
                <h1>Patient Dashboard</h1>
                <p>Manage your appointments, treatments and bills.</p>
            </div>

            <div class="stats">

                <div class="stat-card">
                    <h3>Upcoming Appointments</h3>
                    <p>0</p>
                </div>

                <div class="stat-card">
                    <h3>Pending Requests</h3>
                    <p>0</p>
                </div>

                <div class="stat-card">
                    <h3>Unpaid Bills</h3>
                    <p>0</p>
                </div>

                <div class="stat-card">
                    <h3>Notifications</h3>
                    <p>0</p>
                </div>

            </div>

            <section class="quick-actions">

                <h2>Quick Actions</h2>

                <div class="action-grid">

                   <a href="<%= request.getContextPath() %>/BookAppointment"
   class="action-card">
                        <h3>Book Appointment</h3>
                        <p>Select a dental service, dentist, date and time.</p>
                    </a>

                   <a href="<%= request.getContextPath() %>/patient/MyAppointments"
   class="action-card">

    <h3>My Appointments</h3>

    <p>
        Check pending, confirmed and previous appointments.
    </p>

</a>

                    <a href="my-bills.jsp" class="action-card">
                        <h3>My Bills</h3>
                        <p>View payment status, digital bills and QR receipts.</p>
                    </a>

                    <a href="treatment-history.jsp" class="action-card">
                        <h3>Treatment History</h3>
                        <p>View previous treatments and dental records.</p>
                    </a>

                    <a href="notifications.jsp" class="action-card">
                        <h3>Notifications</h3>
                        <p>View appointment, billing and treatment updates.</p>
                    </a>

                    <a href="profile.jsp" class="action-card">
                        <h3>My Profile</h3>
                        <p>View and manage your personal details.</p>
                    </a>

                </div>

            </section>

            <section class="section">
                <h2>Next Appointment</h2>

                <div class="empty-state">
                    You currently have no confirmed appointments.
                </div>
            </section>

        </div>

    </main>

</div>

</body>
</html>