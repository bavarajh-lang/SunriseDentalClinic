package controller;

import dao.BillDAO;
import model.Bill;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/ReceiptQR")
public class QRCodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String token =
                request.getParameter("token");

        if (token == null
                || token.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            return;
        }

        token =
                token.trim();

        if (token.length() > 100) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            return;
        }

        try {

            BillDAO billDAO =
                    new BillDAO();

            Bill bill =
                    billDAO.getPaidBillByQrToken(
                            token
                    );

            if (bill == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );

                return;
            }

            String receiptUrl =
                    buildDigitalReceiptUrl(
                            request,
                            token
                    );

            QRCodeWriter qrCodeWriter =
                    new QRCodeWriter();

            BitMatrix bitMatrix =
                    qrCodeWriter.encode(
                            receiptUrl,
                            BarcodeFormat.QR_CODE,
                            300,
                            300
                    );

            response.setContentType(
                    "image/png"
            );

            response.setHeader(
                    "Cache-Control",
                    "no-store, no-cache, must-revalidate"
            );

            response.setHeader(
                    "Pragma",
                    "no-cache"
            );

            response.setDateHeader(
                    "Expires",
                    0
            );

            try (
                OutputStream outputStream =
                        response.getOutputStream()
            ) {

                MatrixToImageWriter.writeToStream(
                        bitMatrix,
                        "PNG",
                        outputStream
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (!response.isCommitted()) {

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );
            }
        }
    }


    private String buildDigitalReceiptUrl(
            HttpServletRequest request,
            String token) {

        String scheme =
                request.getScheme();

        String serverName =
                request.getServerName();

        int serverPort =
                request.getServerPort();

        String contextPath =
                request.getContextPath();

        StringBuilder url =
                new StringBuilder();

        url.append(
                scheme
        );

        url.append(
                "://"
        );

        url.append(
                serverName
        );

        boolean standardHttp =
                "http".equalsIgnoreCase(scheme)
                && serverPort == 80;

        boolean standardHttps =
                "https".equalsIgnoreCase(scheme)
                && serverPort == 443;

        if (!standardHttp
                && !standardHttps) {

            url.append(
                    ":"
            );

            url.append(
                    serverPort
            );
        }

        url.append(
                contextPath
        );

        url.append(
                "/DigitalReceipt?token="
        );

        url.append(
                token
        );

        return url.toString();
    }
}