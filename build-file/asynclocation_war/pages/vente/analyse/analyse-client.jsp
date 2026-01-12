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
        t.setNomTable("TOP10_CLIENTS_PAR_MOIS_ANNEE");

        String listeCrt[] = {"moisInt", "annee"};
        String listeInt[] = {};
        String libEntete[] = {"rang", "idClientLib", "mois", "annee", "ca"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Classement des ventes par client");
        pr.setUtilisateur(u);
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("vente/analyse/analyse-client.jsp");

        Liste[] liste = new Liste[1];
        liste[0] = new Liste("moisInt");
        liste[0].makeListeMois();

        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        pr.getFormu().getChamp("moisInt").setDefaut(String.valueOf(Utilitaire.getMoisEnCours()));

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String libEnteteAffiche[] = {"Rang", "Client", "mois", "annee", "Chiffre d'affaire"};
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
                        <h5 class="card-title text-center h520pxSemibold">Classement des ventes par client</h5>
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
<%  String colAbs1 = "idClientLib";
    String[] colOrd1 = {""};
    String[] colAff1 = {""};

    java.util.Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idClientLib", "ca")};
    Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
    g1.setTypeGraphe("bar");
    out.println(g1.getHtml("ctx1"));
}catch (Exception e){
    e.printStackTrace();
}
%>
