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
        
        String sql = "SELECT id, daty, idclientlib, idmagasinlib, montant, montantttc, montantpaye, montantreste, etat, numproforma FROM PROFORMA_CPL_NUM ORDER BY daty DESC";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
        
        List<Map<String, Object>> list = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> dto = new HashMap<>();
            dto.put("id", rs.getString("id"));
            dto.put("daty", rs.getDate("daty") != null ? rs.getDate("daty").toString() : null);
            dto.put("idClientLib", rs.getString("idclientlib"));
            dto.put("idMagasinLib", rs.getString("idmagasinlib"));
            dto.put("montant", rs.getDouble("montant"));
            dto.put("montantTtc", rs.getDouble("montantttc"));
            dto.put("montantPaye", rs.getDouble("montantpaye"));
            dto.put("montantReste", rs.getDouble("montantreste"));
            dto.put("etat", rs.getInt("etat"));
            dto.put("numproforma", rs.getString("numproforma"));
            list.add(dto);
        }
        
        Gson gson = new Gson();
        out.print(gson.toJson(list));
    } catch (Exception e) {
        e.printStackTrace();
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", e.getMessage());
        Gson gson = new Gson();
        out.print(gson.toJson(error));
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

