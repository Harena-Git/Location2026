<%@page import="faturefournisseur.As_BonDeCommande"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="vente.BonDeCommande" %>
<%@ page import="vente.BonDeCommandeCpl" %>

<% try{
    BonDeCommandeCpl f = new BonDeCommandeCpl();
    f.setNomTable("BONDECOMMANDE_CLIENT_CPL");
    String listeCrt[] = {"id","daty","designation","idclientlib","modepaiementlib","reference"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","designation","idclientlib","modepaiementlib","reference","etatlib"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bon de commande");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/bondecommande/bondecommande-liste.jsp");
    pr.getFormu().getChamp("designation").setLibelle("Designation");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("modepaiementlib").setLibelle("Mode paiement");
    pr.getFormu().getChamp("reference").setLibelle("Reference");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","etat","Remarque","Designation","Mode paiement","Fournisseur","Reference","Etat"};
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
