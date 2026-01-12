<%@ page import="caution.CautionLib" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="affichage.Onglet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="caution.ReservationVerificationLib" %><%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-26
  Time: 23:58
  To change this template use File | Settings | File Templates.
--%>
<%
  try {
    //Information sur les navigations via la page
    String lien = (String) session.getValue("lien");
    String pageModif = "caution/reservation-verification-multiple.jsp";
    String classe = "caution.ReservationVerification";
    String pageActuel = "caution/reservationverif-fiche.jsp";

    //Information sur la fiche
    ReservationVerificationLib objet = new ReservationVerificationLib();
    PageConsulte pc = new PageConsulte(objet, request, (user.UserEJB) session.getValue("u"));
    objet = (ReservationVerificationLib) pc.getBase();
    String id = request.getParameter("id");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("datereservation").setLibelle("Date de r&eacute;servation");
    pc.getChampByName("daty").setLibelle("Date de v&eacute;rification");
    pc.getChampByName("idreservation").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id="+objet.getIdreservation()+"&libelle=");
    pc.getChampByName("idreservation").setLibelle("R&eacute;servation");


    pc.setTitre("D&eacute;tails de v&eacute;rification de location");
    Onglet onglet = new Onglet("page1");
    onglet.setDossier("inc");
    Map<String, String> map = new HashMap();
    map.put("reservationverif-details", "");
    //map.put("ecriture-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
      tab = "reservationverif-details";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";



%>
<div class="content-wrapper">
  <div class="row">

    <div class="col-md-12" >
      <div class="box-fiche">
        <div class="box">
          <div class="box-title with-border">
            <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=caution/caution-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
          </div>
          <div class="box-body " style="margin:20px">
            <%
              out.println(pc.getHtml());
            %>
            <br/>
            <div class="box-footer">
              <% if (objet.getEtat() < ConstanteEtat.getEtatValider()) {%>
              <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute="+pageActuel+"&classe=" + classe%>"><button class="btn btn-danger" style="margin-right: 10px">Annuler</button></a>
              <a class="btn btn-success pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute="+pageActuel+"&classe=" + classe%> " style="margin-right: 10px">Valider</a>
              <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
              <% } %>
            </div>
            <br/>

          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-md-12">
      <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
          <!-- a modifier -->
          <li class="active"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=reservationverif-details">D&eacute;tails</a></li>
        </ul>
        <div class="tab-content">
          <jsp:include page="<%= tab%>" >
            <jsp:param name="idmere" value="<%= id%>" />
          </jsp:include>
        </div>
      </div>

    </div>
  </div>
</div>


<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>


