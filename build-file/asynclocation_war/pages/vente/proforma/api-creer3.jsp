<%@ page contentType="application/json;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.UUID" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(200);
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", "Méthode non supportée");
        out.print(new Gson().toJson(error));
        return;
    }

    StringBuilder body = new StringBuilder();
    try (BufferedReader reader = request.getReader()) {
        String line;
        while ((line = reader.readLine()) != null) {
            body.append(line);
        }
    }

    Gson gson = new Gson();
    Map payload = gson.fromJson(body.toString(), Map.class);
    if (payload == null) payload = new HashMap();

    String datyStr = payload.get("daty") != null ? String.valueOf(payload.get("daty")) : null;
    String idClient = payload.get("idClient") != null ? String.valueOf(payload.get("idClient")) : null;
    String designation = payload.get("designation") != null ? String.valueOf(payload.get("designation")) : null;
    String remarque = payload.get("remarque") != null ? String.valueOf(payload.get("remarque")) : null;
    String idMagasin = payload.get("idMagasin") != null ? String.valueOf(payload.get("idMagasin")) : null;
    String lieuLocation = payload.get("lieuLocation") != null ? String.valueOf(payload.get("lieuLocation")) : null;
    Double etat = payload.get("etat") instanceof Number ? ((Number) payload.get("etat")).doubleValue() : null;
    Double remise = payload.get("remise") instanceof Number ? ((Number) payload.get("remise")).doubleValue() : null;
    Double caution = payload.get("caution") instanceof Number ? ((Number) payload.get("caution")).doubleValue() : null;
    String datePrevResStr = payload.get("dateDebutReservation") != null ? String.valueOf(payload.get("dateDebutReservation")) : null;

    Object detailsObj = payload.get("details");
    List details = (detailsObj instanceof List) ? (List) detailsObj : new ArrayList();

    if (datyStr == null || datyStr.trim().isEmpty() || idMagasin == null || idMagasin.trim().isEmpty()) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", "Champs requis manquants: daty / idMagasin");
        out.print(gson.toJson(error));
        return;
    }

    // L'ancienne version tentait d'insérer dans la vue PROFORMA_CPL_NUM, ce qui déclenche ORA-01779.
    // On insère donc dans les tables sources key-preserved : PROFORMA + PROFORMAMONTANT2 + PROFORMA_DETAILS.
    String newId = "PRF-" + UUID.randomUUID().toString();

    Connection conn = null;
    PreparedStatement ps = null;
    PreparedStatement psMontant = null;
    PreparedStatement psDetail = null;
    PreparedStatement psClient = null;
    ResultSet rsClient = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521/EE.oracle.docker",
                "atipik",
                "atipik"
        );
        conn.setAutoCommit(false);

        String clientNom = null;
        if (idClient != null && !idClient.trim().isEmpty()) {
            psClient = conn.prepareStatement("SELECT nom FROM CLIENTLIB WHERE id = ?");
            psClient.setString(1, idClient);
            rsClient = psClient.executeQuery();
            if (rsClient.next()) {
                clientNom = rsClient.getString("NOM");
            }
        }

        // 1) Insert PROFORMA (table)
        String sqlProforma = "INSERT INTO PROFORMA (id, designation, idmagasin, daty, remarque, etat, idorigine, idclient, idreservation, remise, lieulocation, caution, dateprevres, numproforma) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sqlProforma);
        ps.setString(1, newId);
        ps.setString(2, designation);
        ps.setString(3, idMagasin);
        ps.setDate(4, java.sql.Date.valueOf(datyStr));
        ps.setString(5, remarque);
        if (etat == null) {
            ps.setNull(6, Types.NUMERIC);
        } else {
            ps.setDouble(6, etat);
        }
        ps.setNull(7, Types.VARCHAR); // idorigine
        ps.setString(8, idClient);
        ps.setNull(9, Types.VARCHAR); // idreservation
        if (remise == null) {
            ps.setNull(10, Types.NUMERIC);
        } else {
            ps.setDouble(10, remise);
        }
        ps.setString(11, lieuLocation);
        if (caution == null) {
            ps.setNull(12, Types.NUMERIC);
        } else {
            ps.setDouble(12, caution);
        }
        if (datePrevResStr == null || datePrevResStr.trim().isEmpty()) {
            ps.setNull(13, Types.DATE);
        } else {
            ps.setDate(13, java.sql.Date.valueOf(datePrevResStr));
        }
        ps.setString(14, newId);
        ps.executeUpdate();

        // 2) Insert PROFORMAMONTANT2 (table) - la vue PROFORMA_CPL_NUM fait un JOIN obligatoire dessus
        double total = 0.0;
        for (Object dObj : details) {
            if (!(dObj instanceof Map)) continue;
            Map d = (Map) dObj;
            if (d.get("idProduit") == null) continue;
            double pu = (d.get("pu") instanceof Number) ? ((Number) d.get("pu")).doubleValue() : 0.0;
            double qte = (d.get("qte") instanceof Number) ? ((Number) d.get("qte")).doubleValue() : 0.0;
            double nombre = (d.get("nombre") instanceof Number) ? ((Number) d.get("nombre")).doubleValue() : 0.0;
            total += pu * qte * nombre;
        }
        double remisePct = (remise != null) ? remise.doubleValue() : 0.0;
        double montantRemise = total * (remisePct / 100.0);
        double montantTtc = total - montantRemise;

        String sqlMontant = "INSERT INTO PROFORMAMONTANT2 (id, montant, montanttotal, montantremise, montanttva, montantttc, montantttcar) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        psMontant = conn.prepareStatement(sqlMontant);
        psMontant.setString(1, newId);
        psMontant.setDouble(2, total);
        psMontant.setDouble(3, total);
        psMontant.setDouble(4, montantRemise);
        psMontant.setDouble(5, 0.0);
        psMontant.setDouble(6, montantTtc);
        psMontant.setDouble(7, montantTtc);
        psMontant.executeUpdate();

        // 3) Insert PROFORMA_DETAILS (table) - optionnel, mais utile pour cohérence
        String sqlDetail = "INSERT INTO PROFORMA_DETAILS (id, idproforma, idproduit, qte, pu, remise, designation, unite, nombre, datedebut) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        psDetail = conn.prepareStatement(sqlDetail);
        for (Object dObj : details) {
            if (!(dObj instanceof Map)) continue;
            Map d = (Map) dObj;
            Object idProdObj = d.get("idProduit");
            if (idProdObj == null) continue;

            String idDetail = "PRFD-" + UUID.randomUUID().toString();
            String idProduit = String.valueOf(idProdObj);
            double pu = (d.get("pu") instanceof Number) ? ((Number) d.get("pu")).doubleValue() : 0.0;
            double qte = (d.get("qte") instanceof Number) ? ((Number) d.get("qte")).doubleValue() : 0.0;
            double nombre = (d.get("nombre") instanceof Number) ? ((Number) d.get("nombre")).doubleValue() : 0.0;
            String desigDet = d.get("designation") != null ? String.valueOf(d.get("designation")) : null;
            String unite = d.get("unite") != null ? String.valueOf(d.get("unite")) : null;
            String dateDebutStr = d.get("dateDebut") != null ? String.valueOf(d.get("dateDebut")) : null;

            psDetail.setString(1, idDetail);
            psDetail.setString(2, newId);
            psDetail.setString(3, idProduit);
            psDetail.setDouble(4, qte);
            psDetail.setDouble(5, pu);
            psDetail.setDouble(6, 0.0);
            psDetail.setString(7, desigDet);
            psDetail.setString(8, unite);
            psDetail.setDouble(9, nombre);
            if (dateDebutStr == null || dateDebutStr.trim().isEmpty()) {
                psDetail.setNull(10, Types.DATE);
            } else {
                psDetail.setDate(10, java.sql.Date.valueOf(dateDebutStr));
            }
            psDetail.addBatch();
        }
        psDetail.executeBatch();

        conn.commit();

        Map<String, Object> ok = new HashMap<>();
        ok.put("success", true);
        ok.put("id", newId);
        out.print(gson.toJson(ok));
    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch (Exception ignored) {}
        e.printStackTrace();
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", e.getMessage());
        out.print(gson.toJson(error));
    } finally {
        if (rsClient != null) try { rsClient.close(); } catch (Exception ignored) {}
        if (psClient != null) try { psClient.close(); } catch (Exception ignored) {}
        if (psDetail != null) try { psDetail.close(); } catch (Exception ignored) {}
        if (psMontant != null) try { psMontant.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
