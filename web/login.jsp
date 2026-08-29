<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | Sunrise Dental Clinic</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            background: #f4f8fb;
            display: flex;
            flex-direction: column;
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

        .register-link {
            text-decoration: none;
            color: #1677a8;
            font-weight: bold;
        }

        .login-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .login-card {
            width: 100%;
            max-width: 430px;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.10);
        }

        .login-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-title h1 {
            color: #1677a8;
            margin-bottom: 8px;
        }

        .login-title p {
            color: #6b7280;
            font-size: 14px;
        }

        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            background: #fdecec;
            color: #a12626;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-size: 14px;
            font-weight: bold;
            color: #374151;
        }

        input {
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            outline: none;
            font-size: 14px;
        }

        input:focus {
            border-color: #1677a8;
        }

        .password-box {
            position: relative;
        }

        .password-box input {
            padding-right: 75px;
        }

        .show-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #1677a8;
            font-weight: bold;
            cursor: pointer;
        }

        .login-btn {
            width: 100%;
            border: none;
            padding: 13px;
            border-radius: 6px;
            background: #1677a8;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .login-btn:hover {
            background: #105f88;
        }

        .bottom-text {
            text-align: center;
            margin-top: 22px;
            color: #6b7280;
            font-size: 14px;
        }

        .bottom-text a {
            color: #1677a8;
            font-weight: bold;
            text-decoration: none;
        }

        .role-note {
            margin-top: 25px;
            padding: 13px;
            background: #eef7fb;
            border-radius: 6px;
            color: #4b5563;
            font-size: 13px;
            line-height: 1.5;
        }

        @media(max-width: 500px) {
            .login-card {
                padding: 30px 22px;
            }
        }
    </style>
</head>

<body>

    <header class="header">
        <div class="logo">
            Sunrise Dental Clinic
        </div>

        <a href="register.jsp" class="register-link">
            Register
        </a>
    </header>

    <div class="login-wrapper">

        <div class="login-card">

            <div class="login-title">
                <h1>Welcome Back</h1>
                <p>Login to access Sunrise Dental Clinic.</p>
            </div>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="LoginServlet" method="POST">

                <div class="form-group">
                    <label>Username or Email</label>

                    <input
                        type="text"
                        name="usernameOrEmail"
                        placeholder="Enter username or email"
                        required>
                </div>

                <div class="form-group">
                    <label>Password</label>

                    <div class="password-box">

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter password"
                            required>

                        <button
                            type="button"
                            class="show-btn"
                            onclick="togglePassword()">
                            Show
                        </button>

                    </div>
                </div>

                <button type="submit" class="login-btn">
                    Login
                </button>

            </form>

            <div class="bottom-text">
                New patient?
                <a href="register.jsp">
                    Create an account
                </a>
            </div>

            <div class="role-note">
                Patients can register online. Staff accounts are created by the clinic administrator.
            </div>

        </div>

    </div>

    <script>
        function togglePassword() {

            const passwordField =
                    document.getElementById("password");

            const button =
                    document.querySelector(".show-btn");

            if (passwordField.type === "password") {

                passwordField.type = "text";
                button.innerText = "Hide";

            } else {

                passwordField.type = "password";
                button.innerText = "Show";
            }
        }
    </script>

</body>
</html>