<%@ page import="caution.CautionLib" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="affichage.Onglet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="utils.ConstanteLocation" %><%--
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
        String pageModif = "caution/caution-saisie.jsp";
        String classe = "caution.Caution";
        String pageActuel = "caution/caution-fiche.jsp";

        //Information sur la fiche
        CautionLib objet = new CautionLib();
        PageConsulte pc = new PageConsulte(objet, request, (user.UserEJB) session.getValue("u"));
        objet = (CautionLib) pc.getBase();
        String id = request.getParameter("id");
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("modepaiement").setLibelle("Mode de paiement");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("idmodepaiement").setVisible(false);
        pc.getChampByName("montantreservation").setVisible(false);
        pc.getChampByName("pct_applique").setLibelle("Taux Appliqu&eacute;");
        pc.getChampByName("referencepaiement").setLibelle("R&eacute;f&eacute;rence Paiement");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("montantgrp").setLibelle("Caution");
        pc.getChampByName("dateprevuerestitution").setVisible(false);
        pc.getChampByName("idreservation").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id="+objet.getIdreservation()+"&libelle=");
        pc.getChampByName("idreservation").setLibelle("Reservation");


        pc.setTitre("D&eacute;tails caution");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap();
        map.put("caution-details", "");
        map.put("ecriture-detail", "");
        map.put("verification-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "caution-details";
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
                          <!--  <a class="btn btn-primary pull-right" href="<%= lien + "?but=caisse/mvt/mvtcaisse-saisie-caution.jsp&type=encaisser&idcaution=" + id+"&idreservation="+objet.getIdreservation()%>" style="margin-right: 10px">Encaisser</a> -->
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=caisse/mvt/mvtcaisse-saisie-caution.jsp&type=regler&idcaution=" + id+"&idreservation="+objet.getIdreservation()%>" style="margin-right: 10px">Regler</a>
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
                    <li class="<%=map.get("caution-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=caution-details">Details</a></li>
<%--                    <li class="<%=map.get("ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=ecriture-detail">Liste des ecritures</a></li>--%>
<%--                    <li class="<%=map.get("verification-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%=id%>&idresa=<%= objet.getIdreservation()%>&tab=verification-liste">Verifications</a></li>--%>
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

