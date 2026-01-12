<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 27/11/2025
  Time: 14:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="vente.ChiffreAffaireAnnuel" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
  String anneeParam = request.getParameter("annee");
  String allParam = request.getParameter("all");

  java.util.Calendar cal = java.util.Calendar.getInstance();
  int currentYear = cal.get(java.util.Calendar.YEAR);

  boolean voirTout = (allParam != null && allParam.equals("true"));

  int annee = currentYear;
  if (!voirTout && anneeParam != null && !anneeParam.isEmpty()) {
    annee = Integer.parseInt(anneeParam);
  }

  // Données
  Map<String, Double> caData = null;
  Map<String, Map<String, Double>> allData = null;
  if (voirTout) {
    allData = ChiffreAffaireAnnuel.getDataChartAllYears();
  } else {
    caData = ChiffreAffaireAnnuel.getDataChart(annee);
  }
%>


<div class="content-wrapper" style="padding:20px;">
  <h1>Chiffre d'affaire annuel</h1>
  <div class="cardradius">
    <div class="card-body">
      <form method="get" action="<%= session.getAttribute("lien") %>">
        <input type="hidden" name="but" value="vente/ca/graphe-ca-annuel.jsp">
        <div class="d-flex" style="align-items: end">
          <div class="col-md-3">
            <label for="annee" class="input-label">Année Min</label>
            <input type="number" id="annee" name="annee" class="form-control"
                   value="<%= (!voirTout ? annee : currentYear) %>"
                   placeholder="ex: 2025">
          </div>
          <div class="col-md-2 mb-3 d-flex align-items-end">
            <button type="submit" class="btn btn-primary btn-small w-100" style="height: 34px">Appliquer</button>
          </div>
        </div>
      </form>

      <canvas id="c_ca"></canvas>
      <h5 class="card-title text-center">
        <% if (voirTout) { %>
        Chiffre d'affaires – Toutes les années
        <% } else { %>
        Chiffre d'affaires annuel (<%= annee %>)
        <% } %>
      </h5>
    </div>
  </div>
</div>
<%
  if (voirTout) {
    int i = 0;
    for (Map.Entry<String, Map<String, Double>> entry : allData.entrySet()) {
      String year = entry.getKey();
      Map<String, Double> yearData = entry.getValue();

      Graphe g = new Graphe(new Map[]{yearData}, "CA",
              new String[]{""}, new String[]{year}, "c_ca", "");
      g.setTypeGraphe("line");
      out.println(g.getHtml("ctx_" + year));
      i++;
    }
  } else {
    Graphe g = new Graphe(new Map[]{caData}, "CA",
            new String[]{""}, new String[]{}, "c_ca", "");
    g.setTypeGraphe("line");
    out.println(g.getHtml("ctx_ca"));
  }
%>



<style>
  .card {
    transition: transform 0.2s ease-in-out;
    padding: 20px;
    background: #fcfcfc;
    border-radius: 20px;
  }
  canvas {
    max-height: 400px;
  }
</style>
