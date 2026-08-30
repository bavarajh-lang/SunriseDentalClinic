package dao;

import model.Dentist;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class DentistDAO {

    /*
     * =========================================
     * GET ALL ACTIVE DENTISTS
     * =========================================
     *
     * Patient appointment booking dropdown-ku
     * use aagum.
     */
    public List<Dentist> getActiveDentists() {

        List<Dentist> dentists = new ArrayList<>();

        String sql =
                "SELECT dentist_id, dentist_no, full_name, " +
                "specialization, phone, email, consultation_fee, status " +
                "FROM dentists " +
                "WHERE status = 'ACTIVE' " +
                "ORDER BY full_name ASC";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Dentist dentist = new Dentist();

                dentist.setDentistId(
                        resultSet.getInt("dentist_id")
                );

                dentist.setDentistNo(
                        resultSet.getString("dentist_no")
                );

                dentist.setFullName(
                        resultSet.getString("full_name")
                );

                dentist.setSpecialization(
                        resultSet.getString("specialization")
                );

                dentist.setPhone(
                        resultSet.getString("phone")
                );

                dentist.setEmail(
                        resultSet.getString("email")
                );

                dentist.setConsultationFee(
                        resultSet.getDouble("consultation_fee")
                );

                dentist.setStatus(
                        resultSet.getString("status")
                );

                dentists.add(dentist);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return dentists;
    }


    /*
     * =========================================
     * GET ALL DENTISTS
     * =========================================
     *
     * Admin Manage Dentists page-ku.
     *
     * ACTIVE + INACTIVE rendu status-um
     * display pannum.
     */
    public List<Dentist> getAllDentists() {

        List<Dentist> dentists = new ArrayList<>();

        String sql =
                "SELECT dentist_id, dentist_no, full_name, " +
                "specialization, phone, email, consultation_fee, status " +
                "FROM dentists " +
                "ORDER BY dentist_id DESC";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Dentist dentist = new Dentist();

                dentist.setDentistId(
                        resultSet.getInt("dentist_id")
                );

                dentist.setDentistNo(
                        resultSet.getString("dentist_no")
                );

                dentist.setFullName(
                        resultSet.getString("full_name")
                );

                dentist.setSpecialization(
                        resultSet.getString("specialization")
                );

                dentist.setPhone(
                        resultSet.getString("phone")
                );

                dentist.setEmail(
                        resultSet.getString("email")
                );

                dentist.setConsultationFee(
                        resultSet.getDouble("consultation_fee")
                );

                dentist.setStatus(
                        resultSet.getString("status")
                );

                dentists.add(dentist);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return dentists;
    }


    /*
     * =========================================
     * ADD NEW DENTIST
     * =========================================
     */
    public boolean addDentist(Dentist dentist) {

        String sql =
                "INSERT INTO dentists " +
                "(dentist_no, full_name, specialization, phone, email, " +
                "consultation_fee, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE')";

        String dentistNo =
                generateDentistNumber();

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    dentistNo
            );

            statement.setString(
                    2,
                    dentist.getFullName()
            );

            statement.setString(
                    3,
                    dentist.getSpecialization()
            );

            statement.setString(
                    4,
                    dentist.getPhone()
            );

            statement.setString(
                    5,
                    dentist.getEmail()
            );

            statement.setDouble(
                    6,
                    dentist.getConsultationFee()
            );

            int result =
                    statement.executeUpdate();

            if (result > 0) {

                dentist.setDentistNo(
                        dentistNo
                );

                dentist.setStatus(
                        "ACTIVE"
                );

                return true;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    /*
     * =========================================
     * CHANGE DENTIST STATUS
     * =========================================
     *
     * Admin dentist-ah delete pannaama
     * ACTIVE / INACTIVE change pannalaam.
     *
     * Existing appointment history safe-aa
     * database-la irukkum.
     */
    public boolean updateDentistStatus(int dentistId,
                                      String status) {

        String sql =
                "UPDATE dentists " +
                "SET status = ? " +
                "WHERE dentist_id = ?";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    status
            );

            statement.setInt(
                    2,
                    dentistId
            );

            int result =
                    statement.executeUpdate();

            return result > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    /*
     * =========================================
     * GENERATE UNIQUE DENTIST NUMBER
     * =========================================
     *
     * Example:
     * DEN-A31F7B
     */
    private String generateDentistNumber() {

        String randomPart =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 6)
                        .toUpperCase();

        return "DEN-" + randomPart;
    }
}