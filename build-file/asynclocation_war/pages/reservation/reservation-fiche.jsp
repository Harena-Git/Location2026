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
<%@ page import="java.sql.Date" %>
<%@ page import="caution.CautionLib" %>

<%
    try{
        String ismodal = request.getParameter("ismodal");
        String lien = (String) session.getValue("lien");
        ReservationLib t = new ReservationLib();
        t.setNomTable("RESERVATION_LIB_MIN_DATYF");
        UserEJB userEJB  = (user.UserEJB) session.getValue("u");
        PageConsulte pc = new PageConsulte(t, request, userEJB);
        t = (ReservationLib) pc.getBase();
        CautionLib caution = t.getCautions();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("idclient").setVisible(false);
        pc.getChampByName("idclientlib").setLibelle("Client(e)");
        pc.getChampByName("idclientlib").setLien(lien+"?but=client/client-fiche.jsp", "id=" + pc.getChampByName("idclient").getValeur() + "&nom=");
        if(pc.getChampByName("idorigine").getValeur().startsWith("PROF")){
            pc.getChampByName("idorigine").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
        }
        pc.getChampByName("idorigine").setLibelle("Proforma");
        pc.getChampByName("modelivraison").setDefaut(t.getModelivraisonAffiche());
        pc.getChampByName("modelivraison").setLibelle("Livraison/R&eacute;cup&eacute;ration");
        pc.getChampByName("daty").setLibelle("Date de Location");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
//        pc.getChampByName("montant").setLibelle("Montant HT sans remise");
        pc.getChampByName("montantTva").setLibelle("Montant TVA");
        pc.getChampByName("montantTTC").setLibelle("Montant TTC");
//        pc.getChampByName("montantremise").setLibelle("Montant remise");
        pc.getChampByName("lieulocation").setLibelle("Lieu de location");
        pc.getChampByName("montanttotal").setLibelle("Montant HT avec remise");
        pc.getChampByName("equiperesp").setLibelle("&Eacute;quipe Responsable");
        pc.getChampByName("desceequiperesp").setLibelle("Note de l'&Eacute;quipe Responsable");
        pc.getChampByName("equiperesp").setVisible(false);
        pc.getChampByName("desceequiperesp").setVisible(false);
        pc.getChampByName("etatlib").setVisible(false);
        if (!userEJB.getUser().getIdrole().equalsIgnoreCase("achat")){
            pc.getChampByName("montanttotal").setLibelle("Montant");
            pc.getChampByName("paye").setLibelle("Montant Acompte");
            pc.getChampByName("resteAPayer").setLibelle("Reste &agrave; payer");
            pc.getChampByName("montantcaution").setLibelle("Montant caution");
            pc.getChampByName("montantremise").setLibelle("Montant remise");
            pc.getChampByName("datyCaution").setLibelle("Date retour caution");
            pc.getChampByName("debitCaution").setLibelle("Montant retour caution");
        } else {
            pc.getChampByName("montanttotal").setVisible(false);
            pc.getChampByName("paye").setVisible(false);
            pc.getChampByName("resteAPayer").setVisible(false);
            pc.getChampByName("montantcaution").setVisible(false);
            pc.getChampByName("montantremise").setVisible(false);
            pc.getChampByName("datyCaution").setVisible(false);
            pc.getChampByName("debitCaution").setVisible(false);
        }
        pc.getChampByName("revient").setVisible(false);
        pc.getChampByName("marge").setVisible(false);
        pc.getChampByName("datePrevisionRetour").setLibelle("Date pr&eacute;visionnelle de retour");
        pc.getChampByName("datePrevisionDepart").setLibelle("Date pr&eacute;visionnelle de d&eacute;part");
        pc.getChampByName("numBl").setLibelle("Num&eacute;ro du bon de livraison");
        pc.setTitre("Fiche de la r&eacute;servation");
        String pageModif = "reservation/reservation-saisie.jsp";
        String pageActuel = "reservation/reservation-fiche.jsp";
        String classe = "reservation.ReservationLib";
        String classeAnnuler = "reservation.Reservation";
        String nomTable = "RESERVATION_LIB";
//        if (userEJB.getUser().getIdrole().equalsIgnoreCase("achat")){
//            pc.getChampByName("idorigine").setVisible(false);
//        }
//        pc.getChampByName("montantremise").setVisible(false);
        pc.getChampByName("montant").setVisible(false);
        pc.getChampByName("montantTva").setVisible(false);
        pc.getChampByName("montantTTC").setVisible(false);
        pc.getChampByName("periode").setLibelle("P&eacute;riode");

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/reservation-details", "");
        map.put("inc/liste-checkin", "");
        map.put("inc/liste-checkout", "");
        map.put("inc/reservation-paiement", "");
        map.put("inc/reservation-facture", "");
        map.put("inc/liste-acte-service", "");
        map.put("inc/caution-liste", "");
        map.put("inc/verification-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/reservation-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        ReservationLib dp=(ReservationLib)pc.getBase();
        pc.setModalOnClick(true);
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=reservation/reservation-liste.jsp"%>><i class="fa fa-angle-left"></i></a><% out.println(pc.getTitre()); %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                           out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(dp.getEtat()<11){ %>
                            <a class="btn btn-small btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=reservation/reservation-fiche.jsp&classe=reservation.Reservation&nomtable=RESERVATION"%> " style="margin-right: 8px">Valider</a>
                            <a class="btn btn-small btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 8px">Modifier</a>
                            <a class="btn btn-small btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=reservation/reservation-fiche.jsp&classe="+classeAnnuler %>" style="margin-right: 8px">Annuler</a>
                            <% } %>

                            <!-- <a class="btn btn-small btn-info" href="<%= lien + "?but=acte/acte-saisie.jsp&idresa=" + id + "&idclient=" + pc.getChampByName("idclient").getValeur() %> " style="margin-right: 8px">Ajouter Service</a> -->
                            <% if(dp.getEtat()>=11){ %>
<%--                            <a class="btn btn-small btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/apresFacturer.jsp&id=" + id+ "&bute=vente/vente-fiche.jsp&classe=vente.Vente" %> " style="margin-right: 8px">Facturer</a>--%>
<%--                            <a class="btn btn-small btn-primary" href="<%= lien + "?but=caution/caution-saisie-multiple.jsp&id=" + id %> " style="margin-right: 8px">Ajouter caution</a>--%>
<%--                            <a class="btn btn-small btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOp=" + request.getParameter("id") + "&montant="+dp.getMontantTTC()+"&devise=AR&&tiers="+dp.getIdclient() %> " style="margin-right: 8px">Acompte</a>--%>
                                <a class="btn btn-small btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annulerVisa&bute=reservation/reservation-fiche.jsp&classe="+classeAnnuler %>" style="margin-right: 8px">Annuler Visa</a>
                                <% if (!userEJB.getUser().getIdrole().equalsIgnoreCase("vente")){ %>
    <%--                                <a class="btn btn-small btn-primary" href="<%= lien + "?but=caution/reservation-verification-multiple.jsp&id=" + id %> " style="margin-right: 8px">V&eacute;rification Location</a>--%>
                                        <% if (t.getNumBl() != null){ %>
                                            <a class="btn btn-small btn-secondary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=bl&id=<%=id%>" style="margin-right: 8px">Imprimer BL</a>
                                            <a class="btn btn-small btn-secondary pull-right" href="<%= lien + "?but=check/checkout-saisie.jsp&idresa=" + id%>" style="margin-right: 8px">Retour</a>
                                        <% } else { %>
                                            <a class="btn btn-small btn-primary pull-right" href="<%= lien + "?but=check/checkin-saisie.jsp&idresa=" + id%>" style="margin-right: 8px">Livraison/R&eacute;cup&eacute;ration</a>
                                        <% }
                                } %>
                                <a class="btn btn-small btn-secondary pull-right" href="<%= lien + "?but=reservation/equiperesp-saisie.jsp&idresa=" + id%>" style="margin-right: 8px">Ajouter &eacute;quipe responsable</a>
                                <% if (!userEJB.getUser().getIdrole().equalsIgnoreCase("achat") && caution.getDaty() == null){ %>
                                    <a class="btn btn-primary pull-right" href="<%= lien + "?but=caisse/mvt/mvtcaisse-saisie-caution.jsp&type=regler&idcaution=" + caution.getId() +"&idreservation="+t.getId()%>" style="margin-right: 10px">Regler caution</a>
                                <% }
                            } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("inc/reservation-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-details&ismodal=true','modalContent')">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-checkin&ismodal=true','modalContent')">Livraison/R&eacute;cup&eacute;ration effectu&eacute;e</a></li>
                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-checkout&ismodal=true','modalContent')">R&eacute;ception effectu&eacute;e</a></li>
                        <li class="<%=map.get("inc/reservation-paiement")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-paiement&ismodal=true','modalContent')">Liste Paiement effectu&eacute;s </a></li>
                        <li class="<%=map.get("inc/liste-acte")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-acte-service&ismodal=true','modalContent')">Liste services rattach&eacute;s </a></li>
                        <li class="<%=map.get("inc/reservation-facture")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-facture&ismodal=true','modalContent')">Liste Facture  </a></li>
                    <%}else {%>
                        <li class="<%=map.get("inc/reservation-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-details">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkin">Livraison/R&eacute;cup&eacute;ration effectu&eacute;e</a></li>
                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkout">R&eacute;ception effectu&eacute;e</a></li>
<%--                        <li class="<%=map.get("inc/reservation-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-paiement">Liste des Acomptes effectu&eacute;s </a></li>--%>
<%--                        <li class="<%=map.get("inc/liste-acte-service")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-acte-service">Liste des services rattach&eacute;s </a></li>--%>
                        <% if (!userEJB.getUser().getIdrole().equalsIgnoreCase("achat")){ %>
                            <li class="<%=map.get("inc/reservation-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/reservation-facture">Liste des Factures  </a></li>
                            <li class="<%=map.get("inc/caution-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/caution-liste">Caution</a></li>
    <%--                        <li class="<%=map.get("inc/verification-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/verification-liste">V&eacute;rification  </a></li>--%>
                        <% }
                    }%>
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

