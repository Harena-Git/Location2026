<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="user.UserEJB" %>

<%
    try{
        String ismodal = request.getParameter("ismodal");
        String lien = (String) session.getValue("lien");
        ReservationLib t = new ReservationLib();
        t.setNomTable("RESERVATION_LIB_MIN_DATY");
        UserEJB userEJB  = (user.UserEJB) session.getValue("u");
        PageConsulte pc = new PageConsulte(t, request, userEJB);
        t = (ReservationLib) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        //pc.getChampByName("idclient").setVisible(false);
        pc.getChampByName("idclientlib").setLibelle("Client(e)");
        pc.getChampByName("idclient").setLien(lien+"?but=client/client-fiche.jsp", "id=");
        if(pc.getChampByName("idorigine").getValeur().startsWith("PROF")){
            pc.getChampByName("idorigine").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
        }
        pc.getChampByName("idorigine").setLibelle("Id origine");
        pc.getChampByName("daty").setLibelle("Date de R&eacute;servation");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("montant").setVisible(false);
        pc.getChampByName("montantTva").setVisible(false);
        pc.getChampByName("montantTTC").setVisible(false);
        pc.getChampByName("montantremise").setVisible(false);
        pc.getChampByName("montanttotal").setVisible(false);
        pc.getChampByName("paye").setVisible(false);
        pc.getChampByName("revient").setVisible(false);
        pc.getChampByName("resteAPayer").setVisible(false);
        pc.getChampByName("marge").setVisible(false);
//        if (userEJB.getUser().getIdrole().equalsIgnoreCase("achat")){
//            pc.getChampByName("idorigine").setVisible(false);
//        }
        pc.setTitre("Fiche de r&eacute;servation");
        String pageModif = "reservation/reservation-saisie.jsp";
        String pageActuel = "reservation/reservation-fiche-simple.jsp";
        String classe = "reservation.ReservationLib";
        String classeAnnuler = "reservation.Reservation";
        String nomTable = "RESERVATION_LIB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/reservation-details-simple", "");
        map.put("inc/liste-checkin", "");
        map.put("inc/liste-checkout", "");
        map.put("inc/verification-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/reservation-details-simple";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        ReservationLib dp=(ReservationLib)pc.getBase();
        pc.setModalOnClick(true);
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                    <h1 class="box-title"><a href=<%= lien + "?but=reservation/reservation-liste.jsp"%> ><i class="fa fa-arrow-circle-left"></i></a><% out.println(pc.getTitre()); %></h1>
                    </div>
                    <div class="box-body">
                        <%
                           out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if(dp.getEtat()<11){ %>
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=reservation/reservation-fiche-simple.jsp&classe="+classeAnnuler %>" style="margin-right: 10px"><button class="btn btn-danger">Annuler</button></a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=reservation/reservation-fiche-simple.jsp&classe=reservation.Reservation&nomtable=RESERVATION"%> " style="margin-right: 10px">Valider</a>
                            <% } %>

                            <!-- <a class="btn btn-info" href="<%= lien + "?but=acte/acte-saisie.jsp&idresa=" + id + "&idclient=" + pc.getChampByName("idclient").getValeur() %> " style="margin-right: 10px">Ajouter Service</a> -->
                            <% if(dp.getEtat()>=11){ %>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annulerVisa&bute=reservation/reservation-fiche-simple.jsp&classe="+classeAnnuler %>" style="margin-right: 10px"><button class="btn btn-danger">Annuler Visa</button></a>
                            <% if (!userEJB.getUser().getIdrole().equalsIgnoreCase("vente")){ %>
                                <a class="btn btn-info" href="<%= lien + "?but=check/checkin-saisie.jsp&idresa=" + id%>" style="margin-right: 10px">Livraison/R&eacute;cup&eacute;ration</a>
                                <a class="btn btn-primary" href="<%= lien + "?but=caution/reservation-verification-multiple.jsp&id=" + id %> " style="margin-right: 10px">V&eacute;rification Location</a>
                                <a class="btn btn-info" href="<%= lien + "?but=check/checkout-saisie.jsp&idresa=" + id%>" style="margin-right: 10px">R&eacute;ception</a>
                            <% }
                            } %>
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
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("inc/reservation-details-simple")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche-simple.jsp&id=<%= id %>&tab=inc/reservation-details-simple&ismodal=true','modalContent')">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche-simple.jsp&id=<%= id %>&tab=inc/liste-checkin&ismodal=true','modalContent')">Livraison/R&eacute;cup&eacute;ration effectu&eacute;e</a></li>
                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche-simple.jsp&id=<%= id %>&tab=inc/liste-checkout&ismodal=true','modalContent')">R&eacute;ception effectu&eacute;e</a></li>
                    <%}else {%>
                        <li class="<%=map.get("inc/reservation-details-simple")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-details-simple">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkin">Livraison/R&eacute;cup&eacute;ration effectu&eacute;e</a></li>
                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkout">R&eacute;ception effectu&eacute;e</a></li>
                        <li class="<%=map.get("inc/verification-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/verification-liste">V&eacute;rification  </a></li>
                    <%}%>
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

<%=pc.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

