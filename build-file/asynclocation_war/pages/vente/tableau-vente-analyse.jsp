<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="vente.VenteDetailAnalyse" %>

<% try{
    VenteDetailAnalyse t = new VenteDetailAnalyse();
    String listeCrt[] = {"idProduitLib","reference","datejour"};
    String listeInt[] = {"datejour"};
    String libEntete[] = {"id", "reference","idProduitLib","duree","nbclient","ca"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("ANALYSE DE VENTE");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/tableau-vente-analyse.jsp");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Article");
    pr.getFormu().getChamp("datejour1").setLibelle("Date min");
    pr.getFormu().getChamp("datejour1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datejour2").setLibelle("Date max");
    pr.getFormu().getChamp("datejour2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = {"ca"};
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteRecap = {"","Nombre","Somme du chiffre d'affaire"};
    pr.getTableauRecap().setLibeEntete(libEnteteRecap);

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID","R&eacute;f&eacute;rence","Article","Dur&eacute;e (jrs)","Nombre client","Chiffre d'affaire"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



