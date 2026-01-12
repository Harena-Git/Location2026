<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.dmdprix.DmdPrixLib" %>

<% try{
    DmdPrixLib dmdPrixLib = new DmdPrixLib();


    String listeCrt[] = {"id", "daty","clientLib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","clientLib"};
    PageRecherche pr = new PageRecherche(dmdPrixLib, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idMagasin", new Magasin(), "val", "id");
    pr.setTitre("Liste des Demande de Prix");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/dmdprix/dmdprix-liste.jsp");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("clientLib").setLibelle("Client");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/dmdprix/dmdprix-saisie.jsp&acte=update");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/dmdprix/dmdprix-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","Client"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/dmdprix/inc/dmdprixfille-liste.jsp&id=");
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
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
