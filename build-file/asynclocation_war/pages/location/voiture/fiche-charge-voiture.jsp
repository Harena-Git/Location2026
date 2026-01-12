
<%@page import="faturefournisseur.Fournisseur"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="location.ChargeVoitureLib" %>

<%
  UserEJB u = (user.UserEJB)session.getValue("u");

%>


<%
  ChargeVoitureLib charge = new ChargeVoitureLib();
  charge.setNomTable("CHARGEVOITURE_LIB");
  PageConsulte pc = new PageConsulte(charge, request, u);
  pc.setTitre("Fiche Charge Voiture");
  pc.getBase();
  String id=pc.getBase().getTuppleID();
  pc.getChampByName("idvoiturelib").setLibelle("Voiture");
  pc.getChampByName("idproduitlib").setLibelle("Produit");
  pc.getChampByName("idfournisseurlib").setLibelle("Fournisseur");
  pc.getChampByName("pu").setLibelle("Prix Unitaure");
  pc.getChampByName("etatlib").setLibelle("Etat");


  String lien = (String) session.getValue("lien");
  String pageModif = "location/voiture/modif-charge-voiture.jsp";
  String classe = "location.ChargeVoiture";
%>

<div class="content-wrapper">
  <div class="row">
    <div class="col-md-3"></div>
    <div class="col-md-6">
      <div class="box-fiche">
        <div class="box">
          <div class="box-title with-border">
            <h1 class="box-title"><a href=<%= lien + "?but=location/voiture/liste-charge-voiture.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
          </div>
          <div class="box-body">
            <%
              out.println(pc.getHtml());
            %>
            <br/>
            <div class="box-footer">
              <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>

            </div>
            <br/>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>

