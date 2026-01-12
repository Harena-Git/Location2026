<%@page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.DmdAchatLib" %>

<% try{
    DmdAchatLib o = new DmdAchatLib();
    String[] listeCrt = {"id","daty","fournisseurlib","remarque"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id", "daty","fournisseurlib","remarque"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt,4, libEntete, libEntete.length);

    pr.setTitre("Liste des demandes d'achat");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facturefournisseur/dmdachat/dmdachat-liste.jsp");

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] libEnteteAffiche = {"ID", "Date","Fournisseur","Remarque"};
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
            out.println(pr.getTableauRecap().getHtml());
        %>
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



