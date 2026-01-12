
<%@page import="produits.ActeLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    ActeLib objet = new ActeLib();
    objet.setNomTable("ACTE_LIB");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche Acte");
    pc.getChampByName("libelle").setVisible(false);
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    ActeLib acte=(ActeLib)pc.getBase();
    String lien = (String) session.getValue("lien");
    String pageModif = "acte/acte-modif.jsp";
    String classe = "produits.ActeLib";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=acte/acte-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if(acte.getEtat()<11){ %>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=acte/acte-fiche.jsp&classe=produits.Acte&nomtable=Acte"%> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=acte/acte-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                            <% } %>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


