<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="vente.dmdprix.DmdPrixLib" %>
<%@ page import="vente.dmdprix.DmdPrixFilleLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    DmdPrixFilleLib t = new DmdPrixFilleLib();
    t.setNomTable("DMDPRIXFILLELIB");
    PageConsulte pc = new PageConsulte(t, request, u);
    pc.setTitre("Fiche Demande de Prix");
    DmdPrixFilleLib base = (DmdPrixFilleLib) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("idMere").setLibelle("Id demande de prix");
    pc.getChampByName("produit").setVisible(false);
    pc.getChampByName("produitLib").setLibelle("Produit");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idPersonne").setVisible(false);
    pc.getChampByName("idPersonneLib").setLibelle("Personne");

//    pc.getChampByName("clientLib").setLien((String) session.getValue("lien") + "?but=client/client-fiche.jsp&id="+base.getClient(), "page=");

    String pageActuel = "vente/dmdprix/dmdprixfille-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "vente/dmdprix/dmdprix-saisie.jsp";
    String classe = "vente.dmdprix.DmdPrixFille";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/dmdprixfille-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/dmdprixfille-liste";
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
                        <h1 class="box-title"><a href=<%= lien + "?but=vente/dmdprix/dmdprix-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
<%--                            <a class="btn btn-success pull-right"  href="<%= lien + "?but=vente/devis/devis-saisie.jsp&id=" + id%>" style="margin-right: 10px">Cr&eacute;er devis</a>--%>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
