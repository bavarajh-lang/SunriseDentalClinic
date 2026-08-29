<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Patient Registration | Sunrise Dental Clinic</title>

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

        .header {
            background: white;
            padding: 18px 8%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .logo {
            font-size: 23px;
            font-weight: bold;
            color: #1677a8;
        }

        .login-link {
            text-decoration: none;
            color: #1677a8;
            font-weight: bold;
        }

        .page-container {
            width: 90%;
            max-width: 900px;
            margin: 45px auto;
        }

        .register-card {
            background: white;
            border-radius: 12px;
            padding: 35px 40px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .title {
            text-align: center;
            margin-bottom: 30px;
        }

        .title h1 {
            color: #1677a8;
            margin-bottom: 8px;
        }

        .title p {
            color: #6b7280;
        }

        .message {
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 6px;
        }

        .success {
            background: #e8f7ee;
            color: #176b3a;
        }

        .error {
            background: #fdecec;
            color: #a12626;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        label {
            font-weight: bold;
            margin-bottom: 7px;
            font-size: 14px;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            outline: none;
            font-size: 14px;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #1677a8;
        }

        textarea {
            resize: vertical;
            min-height: 85px;
        }

        .section-title {
            grid-column: 1 / -1;
            color: #1677a8;
            font-size: 17px;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 8px;
            margin-top: 8px;
        }

        .register-btn {
            width: 100%;
            margin-top: 28px;
            padding: 14px;
            border: none;
            border-radius: 6px;
            background: #1677a8;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .register-btn:hover {
            background: #105f88;
        }

        .bottom-text {
            text-align: center;
            margin-top: 20px;
            color: #6b7280;
        }

        .bottom-text a {
            color: #1677a8;
            font-weight: bold;
            text-decoration: none;
        }

        @media(max-width: 650px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width,
            .section-title {
                grid-column: auto;
            }

            .register-card {
                padding: 25px 20px;
            }
        }
    </style>
</head>

<body>

    <header class="header">
        <div class="logo">
            Sunrise Dental Clinic
        </div>

        <a href="login.jsp" class="login-link">
            Login
        </a>
    </header>

    <main class="page-container">

        <div class="register-card">

            <div class="title">
                <h1>Patient Registration</h1>
                <p>Create your patient account to book dental appointments.</p>
            </div>

            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message success">
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="PatientRegisterServlet" method="POST">

                <div class="form-grid">

                    <div class="section-title">
                        Personal Information
                    </div>

                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text"
                               name="fullName"
                               placeholder="Enter your full name"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Date of Birth</label>
                        <input type="date"
                               name="dateOfBirth">
                    </div>

                    <div class="form-group">
                        <label>Gender</label>

                        <select name="gender">
                            <option value="">Select gender</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel"
                               name="phone"
                               placeholder="Enter phone number">
                    </div>

                    <div class="form-group full-width">
                        <label>Address</label>
                        <textarea name="address"
                                  placeholder="Enter your address"></textarea>
                    </div>

                    <div class="section-title">
                        Account Information
                    </div>

                    <div class="form-group">
                        <label>Username *</label>
                        <input type="text"
                               name="username"
                               placeholder="Choose a username"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email"
                               name="email"
                               placeholder="Enter your email"
                               required>
                    </div>

                    <div class="form-group full-width">
                        <label>Password *</label>
                        <input type="password"
                               name="password"
                               placeholder="Create a password"
                               minlength="6"
                               required>
                    </div>

                    <div class="section-title">
                        Emergency Contact
                    </div>

                    <div class="form-group">
                        <label>Contact Person</label>
                        <input type="text"
                               name="emergencyContactName"
                               placeholder="Emergency contact name">
                    </div>

                    <div class="form-group">
                        <label>Contact Number</label>
                        <input type="tel"
                               name="emergencyContactPhone"
                               placeholder="Emergency contact number">
                    </div>

                </div>

                <button type="submit" class="register-btn">
                    Create Patient Account
                </button>

            </form>

            <div class="bottom-text">
                Already have an account?
                <a href="login.jsp">Login here</a>
            </div>

        </div>

    </main>

</body>
</html>