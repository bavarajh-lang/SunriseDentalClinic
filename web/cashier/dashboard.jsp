<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cashier Dashboard | Sunrise Dental Clinic</title>

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
            <a href="pending-bills.jsp">Pending Bills</a>
            <a href="payments.jsp">Payments</a>
            <a href="receipts.jsp">Receipts</a>
            <a href="daily-summary.jsp">Daily Summary</a>
        </nav>

    </aside>

    <main class="main">

        <div class="topbar">

            <strong>
                Welcome, <%= session.getAttribute("fullName") %>
            </strong>

           <a href="<%= request.getContextPath() %>/LogoutServlet"
   class="logout">
    Logout
</a>

        </div>

        <div class="content">

            <h1>Cashier Dashboard</h1>

            <p class="subtitle">
                Manage patient payments, bills and receipts.
            </p>

            <div class="stats">

                <div class="card">
                    <h3>Pending Bills</h3>
                    <p>0</p>
                </div>

                <div class="card">
                    <h3>Today's Payments</h3>
                    <p>0</p>
                </div>

                <div class="card">
                    <h3>Today's Revenue</h3>
                    <p>Rs. 0</p>
                </div>

                <div class="card">
                    <h3>Paid Bills</h3>
                    <p>0</p>
                </div>

            </div>

            <div class="section">

                <h2 style="color:#0f5f87;margin-bottom:18px;">
                    Quick Actions
                </h2>

                <div class="actions">

                    <a href="pending-bills.jsp" class="action">
                        <h3>Pending Bills</h3>
                        <p>View bills waiting for payment.</p>
                    </a>

                    <a href="payments.jsp" class="action">
                        <h3>Process Payment</h3>
                        <p>Accept cash, card or bank transfer payments.</p>
                    </a>

                    <a href="receipts.jsp" class="action">
                        <h3>Receipts</h3>
                        <p>View and print completed payment receipts.</p>
                    </a>

                    <a href="daily-summary.jsp" class="action">
                        <h3>Daily Summary</h3>
                        <p>View today's collection and payment totals.</p>
                    </a>

                </div>

            </div>

        </div>

    </main>

</div>

</body>
</html>