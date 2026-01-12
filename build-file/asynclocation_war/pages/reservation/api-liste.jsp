<%@ page contentType="application/json;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.*" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(200);
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521/EE.oracle.docker",
                "atipik",
                "atipik"
        );

        // Le front attend: { id, client, date, remarque, etatPayment, etatLogistique, montant }
        String sql = "SELECT id, idclientlib, daty, remarque, etatpayment, etatpaymentlib, etatlogistique, etatlogistiquelib, montant " +
                "FROM RESERVATION_ETATLOGISTIQUELIB " +
                "WHERE ROWNUM <= 500 " +
                "ORDER BY daty DESC";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        List<Map<String, Object>> list = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", rs.getString("ID"));
            row.put("client", rs.getString("IDCLIENTLIB"));
            row.put("date", rs.getObject("DATY"));
            row.put("remarque", rs.getString("REMARQUE"));
            row.put("etatPayment", rs.getObject("ETATPAYMENT"));
            row.put("etatPaymentLib", rs.getString("ETATPAYMENTLIB"));
            row.put("etatLogistique", rs.getObject("ETATLOGISTIQUE"));
            row.put("etatLogistiqueLib", rs.getString("ETATLOGISTIQUELIB"));
            row.put("montant", rs.getObject("MONTANT"));
            list.add(row);
        }

        out.print(new Gson().toJson(list));
    } catch (Exception e) {
        e.printStackTrace();
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", e.getMessage());
        out.print(new Gson().toJson(error));
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

