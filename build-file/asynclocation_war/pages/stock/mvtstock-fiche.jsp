<%@page import="stock.MvtStockLib"%>
<%@page import="stock.MvtStock"%>
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
    MvtStockLib unite = new MvtStockLib();
    PageConsulte pc = new PageConsulte(unite, request, u);
    pc.setTitre("Fiche de mouvement de stock");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idMagasinlib").setLibelle("Magasin");
    pc.getChampByName("idVentelib").setLibelle("Vente");
    pc.getChampByName("idTransfertlib").setLibelle("Transfert");
    pc.getChampByName("idTypeMvStocklib").setLibelle("Type de mouvement de stock");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");

    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idVente").setVisible(false);
    pc.getChampByName("idTransfert").setVisible(false);
    pc.getChampByName("idTypeMvStock").setVisible(false);
    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("idobjet").setLibelle("Origine");
    String pageActuel = "stock/mvtstock-fiche.jsp";

    String lien = (String) session.getValue("lien");

    pc.getChampByName("idobjet").setLien("module.jsp?but=reservation/reservation-fiche.jsp", "id=");
    String pageModif = "stock/mvtstock-modif.jsp";
    String classe = "stock.MvtStock";

    Map<String, String> map = new HashMap<String, String>();
    map.put("mvtfille-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "mvtfille-liste";
    }
    MvtStockLib mvt=(MvtStockLib)pc.getBase();
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=stock/mvtstock-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row">
              <div class="col-md-12" >
              <div class="box-fiche">
                <div class="box">
                      <div class="box-body ">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(mvt.getEtat()<11){ %>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=stock/mvtstock-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                                <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=annexe/unite/unite-liste.jsp&classe="+classe %>">Supprimer</a>
                            <% } %>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs" style="margin-top: 20px;">
                    <!-- a modifier -->
                    <li class="<%=map.get("mvtfille-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=mvtfille-liste">Mouvement détails</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idmvtstock" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>

