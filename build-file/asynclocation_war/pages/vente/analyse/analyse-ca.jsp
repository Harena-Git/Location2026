<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 03/11/2025
  Time: 11:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.UserEJB" %>
<%@ page import="vente.StatistiqueVente" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="affichage.Graphe" %>
<%
    try{
        UserEJB u = (UserEJB) session.getValue("u");
        StatistiqueVente t = new StatistiqueVente();
        t.setNomTable("CA_PAR_MOIS");

        String listeCrt[] = {"debut"};
        String listeInt[] = {"debut"};
        String libEntete[] = {"mois","ca"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Chiffre d'affaire mensuel");
        pr.setUtilisateur(u);
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("vente/analyse/analyse-ca.jsp");

        pr.getFormu().getChamp("debut1").setDefaut("01/01/2024");
        pr.getFormu().getChamp("debut1").setLibelle("Date d&eacute;but");
        pr.getFormu().getChamp("debut2").setLibelle("Date fin");
        pr.getFormu().getChamp("debut2").setDefaut(Utilitaire.dateDuJour());

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String libEnteteAffiche[] = {"Mois", "Chiffre d'affaire"};
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
                        <h5 class="card-title text-center h520pxSemibold">Chiffre d'affaire Mensuel</h5>
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
<%  String colAbs1 = "mois";
    String[] colOrd1 = {""};
    String[] colAff1 = {""};

    java.util.Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "mois", "ca")};
    Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
    g1.setTypeGraphe("bar");
    out.println(g1.getHtml("ctx1"));
    }catch (Exception e){
        e.printStackTrace();
    }
%>
