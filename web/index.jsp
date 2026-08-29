<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sunrise Dental Clinic</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            color: #1f2937;
            background: #ffffff;
        }

        /* ---------- NAVBAR ---------- */

        .navbar {
            width: 100%;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 8%;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-circle {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: #0f6f9c;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .brand-text h2 {
            color: #0f6f9c;
            font-size: 20px;
        }

        .brand-text span {
            font-size: 12px;
            color: #6b7280;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .nav-links a {
            text-decoration: none;
            color: #374151;
            font-size: 14px;
            font-weight: 600;
        }

        .nav-links a:hover {
            color: #0f6f9c;
        }

        .login-btn {
            padding: 10px 20px;
            border: 1px solid #0f6f9c;
            border-radius: 6px;
            color: #0f6f9c !important;
        }

        .register-btn {
            padding: 11px 20px;
            border-radius: 6px;
            background: #0f6f9c;
            color: white !important;
        }

        /* ---------- HERO ---------- */

        .hero {
            min-height: 580px;
            display: flex;
            align-items: center;
            padding: 60px 8%;
            background:
                linear-gradient(
                    90deg,
                    rgba(235,248,253,0.98) 0%,
                    rgba(235,248,253,0.94) 45%,
                    rgba(235,248,253,0.55) 100%
                );
        }

        .hero-content {
            max-width: 650px;
        }

        .hero-badge {
            display: inline-block;
            background: #dff4fc;
            color: #0f6f9c;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
            margin-bottom: 18px;
        }

        .hero h1 {
            font-size: 48px;
            line-height: 1.15;
            color: #10384f;
            margin-bottom: 20px;
        }

        .hero h1 span {
            color: #0f78a8;
        }

        .hero p {
            font-size: 17px;
            line-height: 1.7;
            color: #5b6470;
            margin-bottom: 28px;
            max-width: 570px;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .primary-btn,
        .secondary-btn {
            text-decoration: none;
            padding: 14px 24px;
            border-radius: 7px;
            font-weight: bold;
            font-size: 15px;
        }

        .primary-btn {
            background: #0f6f9c;
            color: white;
        }

        .secondary-btn {
            border: 1px solid #0f6f9c;
            color: #0f6f9c;
            background: white;
        }

        /* ---------- FEATURES ---------- */

        .section {
            padding: 70px 8%;
        }

        .section-heading {
            text-align: center;
            margin-bottom: 45px;
        }

        .section-heading h2 {
            font-size: 32px;
            color: #10384f;
            margin-bottom: 10px;
        }

        .section-heading p {
            color: #6b7280;
            max-width: 600px;
            margin: auto;
            line-height: 1.6;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
        }

        .feature-card {
            background: #ffffff;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 8px 28px rgba(0,0,0,0.07);
            border: 1px solid #eef2f5;
        }

        .feature-icon {
            width: 52px;
            height: 52px;
            border-radius: 10px;
            background: #e7f6fc;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            margin-bottom: 18px;
        }

        .feature-card h3 {
            color: #0f5f87;
            margin-bottom: 10px;
        }

        .feature-card p {
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
        }

        /* ---------- SERVICES ---------- */

        .services {
            background: #f5fafc;
        }

        .service-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .service-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        .service-card h3 {
            color: #0f5f87;
            font-size: 16px;
            margin-bottom: 7px;
        }

        .service-card p {
            color: #6b7280;
            font-size: 13px;
        }

        /* ---------- HOW IT WORKS ---------- */

        .steps {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .step {
            text-align: center;
            padding: 20px;
        }

        .step-number {
            width: 45px;
            height: 45px;
            background: #0f6f9c;
            color: white;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 14px;
            font-weight: bold;
        }

        .step h3 {
            color: #10384f;
            margin-bottom: 8px;
        }

        .step p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        /* ---------- CTA ---------- */

        .cta {
            background: #0f5f87;
            color: white;
            margin: 0 8% 60px;
            padding: 45px;
            border-radius: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 30px;
        }

        .cta h2 {
            font-size: 28px;
            margin-bottom: 8px;
        }

        .cta p {
            color: #d9edf6;
        }

        .cta a {
            background: white;
            color: #0f5f87;
            text-decoration: none;
            padding: 14px 22px;
            border-radius: 7px;
            font-weight: bold;
            white-space: nowrap;
        }

        /* ---------- FOOTER ---------- */

        footer {
            background: #082e43;
            color: white;
            padding: 35px 8%;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            gap: 30px;
            flex-wrap: wrap;
        }

        .footer-content h3 {
            margin-bottom: 8px;
        }

        .footer-content p {
            color: #bfd1db;
            font-size: 13px;
            line-height: 1.6;
        }

        .copyright {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.15);
            color: #9eb8c5;
            font-size: 12px;
            text-align: center;
        }

        /* ---------- RESPONSIVE ---------- */

        @media(max-width: 950px) {
            .feature-grid {
                grid-template-columns: 1fr 1fr;
            }

            .service-grid {
                grid-template-columns: 1fr 1fr;
            }

            .steps {
                grid-template-columns: 1fr 1fr;
            }

            .nav-links a:not(.login-btn):not(.register-btn) {
                display: none;
            }

            .hero h1 {
                font-size: 39px;
            }
        }

        @media(max-width: 600px) {
            .navbar {
                padding: 15px 5%;
            }

            .brand-text span {
                display: none;
            }

            .nav-links {
                gap: 8px;
            }

            .login-btn,
            .register-btn {
                padding: 9px 12px;
                font-size: 12px !important;
            }

            .hero {
                padding: 50px 6%;
                min-height: 520px;
            }

            .hero h1 {
                font-size: 34px;
            }

            .feature-grid,
            .service-grid,
            .steps {
                grid-template-columns: 1fr;
            }

            .cta {
                margin: 0 5% 40px;
                flex-direction: column;
                align-items: flex-start;
            }
        }

    </style>
</head>

<body>

    <!-- NAVBAR -->

    <nav class="navbar">

        <div class="brand">

            <div class="logo-circle">
                🦷
            </div>

            <div class="brand-text">
                <h2>Sunrise Dental Clinic</h2>
                <span>Healthy smiles begin here</span>
            </div>

        </div>

        <div class="nav-links">

            <a href="#home">Home</a>
            <a href="#services">Services</a>
            <a href="#features">Features</a>
            <a href="#contact">Contact</a>

            <a href="login.jsp" class="login-btn">
                Login
            </a>

            <a href="register.jsp" class="register-btn">
                Register
            </a>

        </div>

    </nav>


    <!-- HERO -->

    <section class="hero" id="home">

        <div class="hero-content">

            <div class="hero-badge">
                Professional Dental Care
            </div>

            <h1>
                Your Smile Deserves
                <span>Better Care.</span>
            </h1>

            <p>
                Sunrise Dental Clinic provides convenient and reliable dental
                services with easy online appointment booking, treatment
                management and secure digital billing.
            </p>

            <div class="hero-buttons">

                <a href="register.jsp" class="primary-btn">
                    Book an Appointment
                </a>

                <a href="login.jsp" class="secondary-btn">
                    Patient Login
                </a>

            </div>

        </div>

    </section>


    <!-- FEATURES -->

    <section class="section" id="features">

        <div class="section-heading">
            <h2>Everything You Need in One Place</h2>

            <p>
                Patients can manage their dental appointments and records
                through a simple and secure online system.
            </p>
        </div>

        <div class="feature-grid">

            <div class="feature-card">

                <div class="feature-icon">📅</div>

                <h3>Online Appointments</h3>

                <p>
                    Choose a dental service, dentist, preferred date and time
                    and submit an appointment request online.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">🔔</div>

                <h3>Appointment Updates</h3>

                <p>
                    Receive updates when your dentist assistant confirms,
                    reschedules or updates your appointment.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">📋</div>

                <h3>Treatment History</h3>

                <p>
                    View previous appointments, treatments and important
                    dental records from your patient account.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">💳</div>

                <h3>Digital Billing</h3>

                <p>
                    View detailed treatment charges and payment status
                    securely from your patient dashboard.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">📱</div>

                <h3>QR Digital Receipt</h3>

                <p>
                    Access your digital bill and receipt quickly using
                    the QR code generated by the clinic.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">🔐</div>

                <h3>Secure Patient Portal</h3>

                <p>
                    Patient information, appointments and billing records
                    are available through authenticated accounts.
                </p>

            </div>

        </div>

    </section>


    <!-- SERVICES -->

    <section class="section services" id="services">

        <div class="section-heading">
            <h2>Our Dental Services</h2>

            <p>
                Select the service you require when requesting your
                appointment.
            </p>
        </div>

        <div class="service-grid">

            <div class="service-card">
                <h3>Dental Consultation</h3>
                <p>General examination and consultation.</p>
            </div>

            <div class="service-card">
                <h3>Teeth Cleaning</h3>
                <p>Professional cleaning and plaque removal.</p>
            </div>

            <div class="service-card">
                <h3>Tooth Filling</h3>
                <p>Treatment for cavities and damaged teeth.</p>
            </div>

            <div class="service-card">
                <h3>Tooth Extraction</h3>
                <p>Safe tooth extraction procedures.</p>
            </div>

            <div class="service-card">
                <h3>Root Canal Treatment</h3>
                <p>Treatment for infected or damaged tooth pulp.</p>
            </div>

            <div class="service-card">
                <h3>Teeth Whitening</h3>
                <p>Professional cosmetic whitening treatment.</p>
            </div>

            <div class="service-card">
                <h3>Dental X-Ray</h3>
                <p>Dental imaging for diagnosis and treatment planning.</p>
            </div>

            <div class="service-card">
                <h3>Braces Consultation</h3>
                <p>Orthodontic assessment and treatment planning.</p>
            </div>

        </div>

    </section>


    <!-- HOW IT WORKS -->

    <section class="section">

        <div class="section-heading">

            <h2>How Appointment Booking Works</h2>

            <p>
                Book and manage your dental appointment in four simple steps.
            </p>

        </div>

        <div class="steps">

            <div class="step">
                <div class="step-number">1</div>
                <h3>Create Account</h3>
                <p>Register as a Sunrise Dental Clinic patient.</p>
            </div>

            <div class="step">
                <div class="step-number">2</div>
                <h3>Choose Service</h3>
                <p>Select your dental service, dentist, date and time.</p>
            </div>

            <div class="step">
                <div class="step-number">3</div>
                <h3>Get Confirmation</h3>
                <p>The dentist assistant checks availability and confirms your request.</p>
            </div>

            <div class="step">
                <div class="step-number">4</div>
                <h3>Visit Clinic</h3>
                <p>Attend your confirmed appointment and receive treatment.</p>
            </div>

        </div>

    </section>


    <!-- CTA -->

    <section class="cta">

        <div>
            <h2>Ready to book your dental appointment?</h2>

            <p>
                Create your patient account and choose a convenient appointment time.
            </p>
        </div>

        <a href="register.jsp">
            Register Now
        </a>

    </section>


    <!-- FOOTER -->

    <footer id="contact">

        <div class="footer-content">

            <div>
                <h3>Sunrise Dental Clinic</h3>
                <p>
                    Professional and patient-focused dental care.
                </p>
            </div>

            <div>
                <h3>Clinic Services</h3>
                <p>
                    Consultation<br>
                    Cleaning<br>
                    Root Canal<br>
                    Orthodontic Care
                </p>
            </div>

            <div>
                <h3>Patient Portal</h3>
                <p>
                    Online Appointments<br>
                    Treatment History<br>
                    Digital Bills<br>
                    QR Receipts
                </p>
            </div>

            <div>
                <h3>Contact</h3>
                <p>
                    Sunrise Dental Clinic<br>
                    Colombo, Sri Lanka
                </p>
            </div>

        </div>

        <div class="copyright">
            © 2026 Sunrise Dental Clinic Management System
        </div>

    </footer>

</body>
</html>