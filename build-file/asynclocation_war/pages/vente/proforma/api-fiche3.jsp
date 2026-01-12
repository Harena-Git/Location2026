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

    String id = request.getParameter("id");
    if (id == null || id.trim().isEmpty()) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", "Paramètre id manquant");
        out.print(new Gson().toJson(error));
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

        String sql = "SELECT id, designation, idmagasinlib, daty, idclientlib, etat, iddevise, remarque, " +
                "montanttotal, montantremise, montantreste, remise, periode, etatlib, lieulocation " +
                "FROM PROFORMA_CPL_NUM WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, id);
        rs = ps.executeQuery();

        if (!rs.next()) {
            Map<String, Object> notFound = new HashMap<>();
            notFound.put("success", false);
            notFound.put("error", "Proforma introuvable: " + id);
            out.print(new Gson().toJson(notFound));
            return;
        }

        Map<String, Object> fiche = new HashMap<>();
        fiche.put("id", rs.getString("ID"));
        fiche.put("designation", rs.getString("DESIGNATION"));
        fiche.put("magasin", rs.getString("IDMAGASINLIB"));
        fiche.put("date", rs.getObject("DATY"));
        fiche.put("client", rs.getString("IDCLIENTLIB"));
        fiche.put("etat", rs.getObject("ETAT"));
        fiche.put("devise", rs.getString("IDDEVISE"));
        fiche.put("remarque", rs.getString("REMARQUE"));
        fiche.put("montantSansRemise", rs.getObject("MONTANTTOTAL"));
        fiche.put("montantRemise", rs.getObject("MONTANTREMISE"));
        fiche.put("montantRestant", rs.getObject("MONTANTRESTE"));
        fiche.put("remise", rs.getObject("REMISE"));
        fiche.put("periode", rs.getString("PERIODE"));
        fiche.put("etatPayment", rs.getString("ETATLIB"));
        fiche.put("lieuLocation", rs.getString("LIEULOCATION"));
        fiche.put("details", new ArrayList<>());

        out.print(new Gson().toJson(fiche));
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
