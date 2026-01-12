<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:49
  To change this template use File | Settings | File Templates.
--%>

<%@page import="java.util.*"%>
<%@page import="proforma.*"%>
<%@page import="user.*"%>
<%@page import="vente.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.Reservation" %>

<%
  UserEJB u = (user.UserEJB)session.getValue("u");
  String lien = (String) session.getValue("lien");
  String pageActuel = "vente/proforma/proforma-fiche.jsp";
%>
<%
  try{
    String pageModif = "vente/proforma/proforma-saisie.jsp";
    ProformaLib f = new ProformaLib();
    f.setNomTable("PROFORMA_CPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche de la facture proforma");
    ProformaLib prof=(ProformaLib)pc.getBase();
    String id=prof.getTuppleID();
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("idclient").setLibelle("Id client");
    pc.getChampByName("idclientLib").setLibelle("Client");
      pc.getChampByName("remarque").setLibelle("Remarque");
      pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
      pc.getChampByName("montantremise").setLibelle("Montant de la remise");
      pc.getChampByName("iddevise").setLibelle("Devise");
      pc.getChampByName("montant").setLibelle("Montant sans remise");
      pc.getChampByName("montanttotal").setLibelle("Montant HT avec remise");
      pc.getChampByName("montanttotal").setVisible(false);
      pc.getChampByName("montanttva").setLibelle("Montant(TVA)");
      pc.getChampByName("montanttva").setVisible(false);
      pc.getChampByName("montantttc").setLibelle("Montant(TTC)");
      pc.getChampByName("montantttc").setVisible(false);
      pc.getChampByName("montantreste").setLibelle("Montant restant");
      pc.getChampByName("montantpaye").setLibelle("Montant Pay&eacute;");
      pc.getChampByName("montantpaye").setVisible(false);
      pc.getChampByName("datedebutmin").setVisible(false);
      pc.getChampByName("datefinmax").setVisible(false);
      pc.getChampByName("idMagasinLib").setLibelle("Magasin");
      pc.getChampByName("designation").setLibelle("D&eacute;signation");
      pc.getChampByName("idorigine").setLibelle("ID Origine");
      pc.getChampByName("Etatpaymentlib").setLibelle("&Eacute;tat Payment");
      pc.getChampByName("idorigine").setVisible(false);
      pc.getChampByName("etat").setVisible(false);
      pc.getChampByName("montantttcAr").setVisible(false);
      pc.getChampByName("montantrevient").setVisible(false);
      pc.getChampByName("margebrute").setVisible(false);
      pc.getChampByName("idReservation").setVisible(false);
      pc.getChampByName("tauxdechange").setVisible(false);
      //pc.getChampByName("idorigine").setVisible(false);
      pc.getChampByName("idMagasin").setVisible(false);
      pc.getChampByName("adresse").setVisible(false);
      pc.getChampByName("contact").setVisible(false);
      //pc.getChampByName("montant").setVisible(false);
      pc.getChampByName("avoir").setVisible(false);
      pc.getChampByName("idclient").setVisible(false);
      pc.getChampByName("periode").setLibelle("P&eacute;riode");
      pc.getChampByName("lieulocation").setLibelle("Lieu de location");

    pc.getChampByName("idclientLib").setLien(lien+"?but=client/client-fiche.jsp", "id=" + pc.getChampByName("idclient").getValeur() + "&nom=");

    if(pc.getChampByName("idorigine").getValeur().startsWith("PROF")){
      pc.getChampByName("idorigine").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
    }

    String classe = "proforma.Proforma";

    Map<String, String> map = new HashMap<String, String>();
    map.put("proforma-detail-liste", "");
    map.put("proforma-lie", "");
    map.put("bondecommande", "");
    map.put("facture", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
      tab = "proforma-detail-liste";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";
    int etat = prof.getEtat();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=vente/demandeprix/demandeprix-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
       
              <%if( etat < 11 && etat>0){ %>
             <!-- <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/proforma/proforma-fiche.jsp&classe="+classe %> " style="margin-right: 10px">Valider</a> -->
             <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree.jsp&idProforma=" + request.getParameter("id") %> " style="margin-right: 10px">Payer</a>
              <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
<%--              <a  class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=vente/proforma/proforma-fiche.jsp&classe="+classe %>">Annuler</a>--%>
              <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/proforma/apresValiderProforma.jsp&acte=valider&id="+ request.getParameter("id")%>" style="margin-right: 10px">Cr&eacute;er BC</a>
              <%}%>
              <%if( etat == 11 ){
                Proforma proforma = new Proforma();
                proforma.setId(request.getParameter("id"));
                Reservation res = proforma.getReservation();
              %>
<%--              <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/apresFacturer.jsp&id=" + res.getId() + "&bute=vente/vente-fiche.jsp&classe=vente.Vente" %> " style="margin-right: 10px">Facturer</a>--%>
              <%}%>
                    <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=proforma&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer en PDF</a>
              <!--a href="<%=(String) session.getValue("lien")%>/../../ExportProforma?id=<%=request.getParameter("id")%>" class="btn btn-primary">Export Excel</a-->
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
          <li class="<%=map.get("proforma-detail-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=proforma-detail-liste">D&eacute;tails</a></li>
          <li class="<%=map.get("proforma-lie")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=proforma-lie">Proforma Li&eacute;</a></li>
          <li class="<%=map.get("bondecommande")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=bondecommande">Liste des R&eacute;servations</a></li>
            <%if( etat == 11 ){
                Proforma proforma = new Proforma();
                proforma.setId(request.getParameter("id"));
                Reservation res = proforma.getReservation();
            %>
            <li class="<%=map.get("facture")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&idReservation=<%= res.getId()%>&tab=facture">Liste des Factures</a></li>
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

<%
  } catch (Exception e) {
    e.printStackTrace();

  }%>
<script>
    window.onload = function() {
        supprimerLocalStorage();
    };
    function supprimerLocalStorage() {
        // Sélectionner tous les éléments dont l'ID commence par 'idClient'
        //console.log("TAILMLLL",localStorage.length)
        //for (let i = 0; i < localStorage.length; i++) {
        //    let key = localStorage.key(i);  // Récupérer le nom de chaque clé
        //    console.log(key);
        //    if (key && key.startsWith('idP')) {  // Vérifier si l'ID commence par 'idClient'
        //        localStorage.removeItem(key);  // Supprimer l'élément du localStorage
        //        console.log(`Clé ${key} supprimée du localStorage.`);
        //    }
        //}
        localStorage.clear();
        localStorage.removeItem("idCLient");
        localStorage.removeItem("idClientlibelle");
    }
</script>
