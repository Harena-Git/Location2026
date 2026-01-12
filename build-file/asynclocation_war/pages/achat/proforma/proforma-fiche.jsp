
<%@page import="java.util.*"%>
<%@page import="proforma.*"%>
<%@page import="user.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>

<%
  UserEJB u = (user.UserEJB)session.getValue("u");
  String lien = (String) session.getValue("lien");
  String pageActuel = "achat/proforma/proforma-fiche.jsp";
%>
<%
  try{

    ProformaAchatLib f = new ProformaAchatLib();
    f.setNomTable("PROFORMAACHATLIB");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Facture du proforma");
    ProformaAchatLib prof=(ProformaAchatLib)pc.getBase();
    String id=prof.getTuppleID();
    pc.getChampByName("idDmdAchat").setLien("module.jsp?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp", "id=");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idDmdAchat").setLibelle("Ref Demande Achat");
    pc.getChampByName("idFournisseurlib").setLibelle("Fournisseur");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idFournisseur").setVisible(false);
    String classe = "proforma.ProformaAchat";

    Map<String, String> map = new HashMap<String, String>();
    map.put("proforma-fille-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
      tab = "proforma-fille-liste";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";
    int etat = prof.getEtat();
%>

<div class="content-wrapper">
  <h1 class="box-title"><%=pc.getTitre()%></h1>
  <div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-6">
      <div class="box-fiche">
        <div class="box">
          <div class="box-body">
            <%
              out.println(pc.getHtml());
            %>
            <br/>
            <div class="box-footer">
              <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondecommande/bondecommande-saisie.jsp&idProforma="+id%> " style="margin-right: 10px">Cr&eacute;er BC</a>
              <%if( etat < 11 ){ %>
                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=achat/proforma/proforma-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Valider</a>
              <%}%>
              <%--              <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>--%>
            </div>
            <br/>

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

