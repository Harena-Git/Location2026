<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="vente.dmdprix.DmdPrixLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    DmdPrixLib dmdPrixLib = new DmdPrixLib();
    PageConsulte pc = new PageConsulte(dmdPrixLib, request, u);
    pc.setTitre("Fiche Demande de Prix");
    DmdPrixLib base = (DmdPrixLib) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("client").setVisible(false);
    pc.getChampByName("clientLib").setLibelle("Client");
    pc.getChampByName("clientLib").setLien((String) session.getValue("lien") + "?but=client/client-fiche.jsp&id="+base.getClient(), "page=");


    String pageActuel = "vente/dmdprix/dmdprix-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "vente/dmdprix/dmdprix-saisie.jsp";
    String classe = "vente.dmdprix.DmdPrix";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/dmdprixfille-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/dmdprixfille-liste";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

//    String idBc = dmdPrixLib.bonDeCommandeLiee(request.getParameter("id"));
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=vente/dmdprix/dmdprix-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=vente/dmdprix/dmdprix-liste.jsp&classe="+classe%>"><button class="btn btn-danger">Annuler</button></a>
                            <a  class="pull-right" href="<%= lien + "?but=vente/proforma/proforma-saisie.jsp&idDmd="+id%>"><button class="btn btn-success">Cr&eacute;er Facture Proforma</button></a>
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
                    <li class="<%=map.get("inc/dmdprixfille-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/dmdprixfille-liste">D&eacute;tails</a></li>
<%--                    <li class="<%=map.get("inc/dmdprix-devis")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/dmdprix-devis">Devis</a></li>--%>
<%--                    <li class="<%=map.get("inc/dmdprix-bondecommande")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/dmdprix-bondecommande">Bon de Commande</a></li>--%>
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
