<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="vente.VenteDetailAnalyseCl" %>

<% try{
    VenteDetailAnalyseCl t = new VenteDetailAnalyseCl();
    String listeCrt[] = {"idClientLib","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"daty","idClientLib","nbarticle","ca"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("ANALYSE DE VENTE PAR CLIENT");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/tableau-vente-analyse-cl.jsp");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = {"ca"};
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteRecap = {"","Nombre","Somme du chiffre d'affaire"};
    pr.getTableauRecap().setLibeEntete(libEnteteRecap);

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idProduit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"Date","Client","Nombre article","Chiffre d'affaire"};
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



