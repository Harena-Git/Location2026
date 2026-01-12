<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 15/04/2025
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.Check" %>
<%@ page import="reservation.CheckOutLib" %>
<%
    try{
        String lien = (String) session.getValue("lien");
        CheckOutLib t = new CheckOutLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (CheckOutLib) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("reservation").setLibelle("ID Livraison");
        pc.getChampByName("produitlibelle").setLibelle("Produit");
        pc.getChampByName("daty").setLibelle("Date de r&eacute;ception");
        pc.getChampByName("heure").setLibelle("Heure check out");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("kilometragecheckin").setLibelle("Kilom&eacute;trage Check In");
        pc.getChampByName("kilometragecheckout").setLibelle("Kilom&eacute;trage Check Out");
        pc.getChampByName("distancereelle").setLibelle("Distance r&eacute;elle");
        pc.getChampByName("quantite").setLibelle("Quantit&eacute;");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("kilometragecheckin").setVisible(false);
        pc.getChampByName("kilometragecheckout").setVisible(false);
        pc.getChampByName("val").setLibelle("Magasin");
        pc.getChampByName("pu").setLibelle("Prix Unitaire");
        pc.getChampByName("refproduit").setLibelle("Reference produit");
        pc.getChampByName("idmagasin").setVisible(false);
        pc.getChampByName("idProduit").setLibelle("Id Produit");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("distancereelle").setVisible(false);
        pc.getChampByName("idReservationMere").setLibelle("Id r&eacute;servation");
        pc.getChampByName("idReservationMere").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id=");
        pc.getChampByName("reservation").setLien(lien+"?but=check/checkin-fiche.jsp", "id=");
//        pc.getChampByName("idreservation").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("Etat");
        pc.setTitre("Fiche de R&eacute;ception");
        String pageModif = "check/checkout-modif.jsp";
        String pageActuel = "check/checkout-fiche.jsp";
        String classe = "reservation.CheckOut";
        String nomTable = "CHECKOUTLIB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/liste-acte", "");
        map.put("inc/reservation-facture", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="#"><i class="fa fa-arrow-circle-left"></i></a><% out.println(pc.getTitre()); %></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
<%--                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>--%>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=check/checkin-fiche.jsp&classe="+classe %>" style="margin-right: 10px"><button class="btn btn-danger">Annuler</button></a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=reservation/reservation-fiche.jsp&classe="+classe+"&nomtable=checkout&tab=inc/liste-checkout&idresa="+t.getIdReservationMere()%> " style="margin-right: 10px" onsubmit="closeModal()">Viser</a>
                            <a class="btn btn-primary" href="<%= lien + "?but=vente/vente-saisie.jsp&id=" + id %> " style="margin-right: 10px">Facturer</a>
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
                    <li class="<%=map.get("inc/liste-acte")%>"><a href="<%= lien %>?but=<%= pageActuel %>&idreservation=<%= id %>&tab=inc/liste-acte">Liste Services rattrachees</a></li>
                    <li class="<%=map.get("inc/reservation-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&idreservation=<%= id %>&tab=inc/reservation-facture">Liste Facture </a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>


</div>


<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
