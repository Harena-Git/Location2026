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

        // Le front attend: { id, libelle, dimension, pu, unite, image }
        String sql = "SELECT id, libelle, pu, unite, image FROM ST_INGREDIENTSAUTOVENTE_MIMAGE WHERE ROWNUM <= 500 ORDER BY libelle";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        List<Map<String, Object>> list = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> dto = new HashMap<>();
            dto.put("id", rs.getString("ID"));
            dto.put("libelle", rs.getString("LIBELLE"));
            dto.put("dimension", "");
            dto.put("pu", rs.getObject("PU"));
            dto.put("unite", rs.getString("UNITE"));
            dto.put("image", rs.getString("IMAGE"));
            list.add(dto);
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

