<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 03/11/2025
  Time: 11:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.UserEJB" %>
<%@ page import="vente.StatistiqueVente" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="affichage.Liste" %>
<%
    try{
        UserEJB u = (UserEJB) session.getValue("u");
        StatistiqueVente t = new StatistiqueVente();
        t.setNomTable("TOP10_ARTICLE_PAR_MOIS_ANNEE");

        String listeCrt[] = {"top","moisInt", "annee"};
        String listeInt[] = {"top"};
        String libEntete[] = {"rang", "idProduitLib", "mois", "annee", "qteJour"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Classement des produits par quantit&eacute; en jour");
        pr.setUtilisateur(u);
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("vente/analyse/analyse-article.jsp");

        Liste[] liste = new Liste[2];
        liste[0] = new Liste("moisInt");
        liste[0].makeListeMois();
        liste[1] = new Liste("top2");
        String[] val = {"3", "5", "10"};
        liste[1].ajouterValeur(val, val);

        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        pr.getFormu().getChamp("moisInt").setDefaut(String.valueOf(Utilitaire.getMoisEnCours()));
        pr.getFormu().getChamp("top1").setVisible(false);
        pr.getFormu().getChamp("top1").setDefaut("1");
        pr.getFormu().getChamp("top2").setLibelle("Top");
        pr.getFormu().getChamp("top2").setDefaut("10");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String libEnteteAffiche[] = {"Rang", "Produit", "mois", "annee", "Quantit&eacute; en jour"};
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
            out.println(pr.getTableau().getHtml());
        %>
        <div class="row m-0 mt-4" style="margin-top: 20px;">
            <div class="col-md-12 nopadding mb-4">
                <div class="cardradius h-100">
                    <div class="card-body">
                        <h5 class="card-title text-center h520pxSemibold">Classement des produits par quantit&eacute; en jour</h5>
                        <canvas id="graph_cheese"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%  String colAbs1 = "idProduitLib";
    String[] colOrd1 = {""};
    String[] colAff1 = {""};

    java.util.Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idProduitLib", "qteJour")};
    Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
    g1.setTypeGraphe("bar");
    out.println(g1.getHtml("ctx1"));
}catch (Exception e){
    e.printStackTrace();
}
%>
