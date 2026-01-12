
<%@page import="caisse.MvtCaisseCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    try{
    String lien = (String) session.getValue("lien");
    MvtCaisseCpl caisse = new MvtCaisseCpl();
    PageConsulte pc = new PageConsulte(caisse, request, u);
    pc.setTitre("Fiche du mouvement de caisse");
    pc.getBase();
		String iff=request.getParameter("idFF");
    String id=pc.getBase().getTuppleID();

    caisse = (MvtCaisseCpl) pc.getBase();

    String[] ordre = {"id", "designation", "idCaisseLib", "daty"};
    pc.setOrdre(ordre);

    pc.getChampByName("id").setLibelle("Id");

        pc.getChampByName("idDevise").setLibelle("Devise");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idCaisseLib").setLibelle("Caisse");
    pc.getChampByName("idVenteDetail").setVisible(false);
    pc.getChampByName("idVirement").setVisible(false);
    pc.getChampByName("idPrevision").setLibelle("ID Pr&eacute;vision");
    pc.getChampByName("idPrevision").setVisible(false);
    pc.getChampByName("idOp").setLibelle("ID OP");
    pc.getChampByName("debit").setLibelle("d&eacute;bit");
    pc.getChampByName("credit").setLibelle("cr&eacute;dit");
    pc.getChampByName("idmodepaiement").setVisible(false);
    pc.getChampByName("idmodepaiementlib").setLibelle("Mode de payment");
    if(caisse.getIdproforma()!=null && caisse.getIdproforma().startsWith("PROF")){
        pc.getChampByName("idproforma").setLibelle("Proforma");
        pc.getChampByName("idproforma").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp&", "id=");
    }
    if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().startsWith("VNT")){
        pc.getChampByName("idOrigine").setLibelle("Facture");
        pc.getChampByName("idOrigine").setLien(lien+"?but=vente/vente-fiche.jsp&", "id=");
    }else if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().startsWith("FCF")){
        pc.getChampByName("idOrigine").setLibelle("Facture Fournisseur");
        pc.getChampByName("idOrigine").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp&", "id=");
    } else {
        pc.getChampByName("idOrigine").setLibelle("Origine");
    }

    if(caisse.getIdOp() != null && caisse.getIdOp().startsWith("RESA")){
        pc.getChampByName("idOp").setLibelle("R&eacute;servation");
        pc.getChampByName("idOp").setLien(lien+"?but=reservation/reservation-fiche.jsp&", "id=");
    }

    pc.getChampByName("idVente").setLibelle("Facture");
    pc.getChampByName("idVente").setVisible(false);

    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("idTiers").setVisible(false);
    String pageActuel = "caisse/mvt/mvtCaisse-fiche.jsp";
    String classe = "caisse.MvtCaisse";
    Onglet onglet =  new Onglet("page1");
    onglet.setDossier("inc");


    onglet.setDossier("inc");
    Map<String, String> map = new HashMap<String, String>();
    map.put("ecriture-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "ecriture-details";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";

%>

<div class="content-wrapper">
    <%if(iff!=null){%>
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/facturefournisseur-fiche.jsp&id="+iff%> ><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <%}else{%>
    <h1 class="box-title"><a href=<%= lien + "?but=caisse/mvt/mvtCaisse-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <%}%>
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
                            <%
                                if(caisse.getEtat() == 11 ){
                                %>
<%--                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=prevision/prevision-non-regle.jsp&idMvtCaisse=" + request.getParameter("id") %>" style="margin-right: 10px">Attacher pr&eacute;vision</a>--%>
                                <%
                                }
                                if( caisse.getEtat() != 11 ){ %>
                                    <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-modif.jsp&id=" + request.getParameter("id") %>" style="margin-right: 10px">Modifier</a>
                            <%    }
                            %>
                            <% if(caisse.getEtat() > 0 && caisse.getEtat() < 11) { %>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=caisse/mvt/mvtCaisse-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <% } %>

                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
<%--    <div class="row m-0">--%>
<%--        <div class="col-md-12 nopadding">--%>
<%--            <div class="nav-tabs-custom">--%>
<%--                <ul class="nav nav-tabs">--%>
<%--                    <!-- a modifier -->--%>
<%--                    <% if (caisse.getEtat() >= ConstanteEtat.getEtatValider()) {%>--%>
<%--                    <li class="<%=map.get("ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=ecriture-details">&Eacute;criture</a></li>--%>
<%--                    <% }%>--%>
<%--                </ul>--%>
<%--                <div class="tab-content">--%>
<%--                    <jsp:include page="<%= tab%>" >--%>
<%--                        <jsp:param name="idmere" value="<%= id%>" />--%>
<%--                    </jsp:include>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--        </div>--%>
<%--    </div>--%>


    </div>
</div>
</div>

<%

    }catch(Exception e){

    e.printStackTrace();
    }

%>
