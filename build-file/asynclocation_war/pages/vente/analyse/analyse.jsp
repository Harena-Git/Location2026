<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


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

        String listeCrt[] = {"annee"};
        String listeInt[] = {};
        String libEntete[] = {"rang", "idClientLib", "mois", "annee", "ca"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Statistiques");
        pr.setUtilisateur(u);
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("vente/analyse/analyse.jsp");

        Liste[] liste = new Liste[1];
        liste[0] = new Liste("moisInt");
        liste[0].makeListeMois();

        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        // ---------------------------------------------------------

        StatistiqueVente t2 = new StatistiqueVente();
        t2.setNomTable("TOP10_ARTICLE_PAR_MOIS_ANNEE");

        String listeCrt2[] = {"annee"};
        String listeInt2[] = {};
        String libEntete2[] = {"rang", "idProduitLib", "mois", "annee", "qteJour"};

        PageRecherche pr2 = new PageRecherche(t2, request, listeCrt2, listeInt2, 3, libEntete2, libEntete2.length);
        pr2.setUtilisateur(u);
        pr2.setLien((String) session.getValue("lien"));

        String[] colSomme2 = null;
        pr2.creerObjetPage(libEntete2, colSomme2);


        // ---------------------------------------------------------


        StatistiqueVente t3 = new StatistiqueVente();
        t3.setNomTable("CA_PAR_MOIS");

        String listeCrt3[] = {"annee"};
        String listeInt3[] = {};
        String libEntete3[] = {"annee","mois","ca"};

        PageRecherche pr3 = new PageRecherche(t3, request, listeCrt3, listeInt3, 3, libEntete3, libEntete3.length);
        pr3.setUtilisateur(u);
        pr3.setLien((String) session.getValue("lien"));

        String[] colSomme3 = null;
        pr3.creerObjetPage(libEntete3, colSomme3);
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

        <div class="row m-0 mt-4" style="margin-top: 20px;">
            <div class="col-md-6 nopadding mb-4">
                <div class="cardradius h-100">
                    <div class="card-body">
                        <h5 class="card-title text-center">
                            Répartition du chiffre d’affaires par client
                        </h5>
                        <canvas id="graph_cheese"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="cardradius h-100">
                    <div class="card-body">
                        <h5 class="card-title text-center">Répartition des produits par prix</h5>
                        <canvas id="graph2"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-12">
                <div class="cardradius h-100">
                    <div class="card-body">
                        <canvas id="graph3"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
<%  String colAbs1 = "idClientLib";
    String[] colOrd1 = {""};
    String[] colAff1 = {""};

    java.util.Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idClientLib", "ca")};
    Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
    g1.setTypeGraphe("pie");
    out.println(g1.getHtml("ctx1"));

    // ------------------------

    String colAbs2 = "idProduitLib";
    String[] colOrd2 = {""};
    String[] colAff2 = {""};

    java.util.Map<String, Double>[] data2 = new Map[]{AdminGen.getDataChart(pr2.getTableau().getData(), "idProduitLib", "qteJour")};
    Graphe g2 = new Graphe(data2, colAbs2, colOrd2, colAff2, "graph2", "");
    g2.setTypeGraphe("pie");
    out.println(g2.getHtml("ctx2"));


    // -----------------------------

    StatistiqueVente[] dataStat3 = (StatistiqueVente[]) pr3.getTableau().getData();

    double[] caParMois = new double[12];
    String[] moisLabels = {
            "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
            "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    };

    double seuilBas = 500000;    // CA faible
    double seuilMoyen = 2000000; // CA moyen

    String[] couleurs = new String[12];

    for (int i = 0; i < 12; i++) {
        caParMois[i] = 0;
        couleurs[i] = "'rgba(200,200,200,0.6)'"; // valeur par défaut (gris)
    }

    for (StatistiqueVente stat : dataStat3) {
        int moisInt = stat.getMoisInt();
        if (moisInt >= 1 && moisInt <= 12) {
            double ca = stat.getCa();
            caParMois[moisInt - 1] = ca;

            if (ca < seuilBas) {
                couleurs[moisInt - 1] = "'rgba(255, 99, 132, 0.7)'"; // rouge (danger)
            } else if (ca < seuilMoyen) {
                couleurs[moisInt - 1] = "'rgba(255, 206, 86, 0.7)'"; // jaune/orange (avertissement)
            } else {
                couleurs[moisInt - 1] = "'rgba(75, 192, 192, 0.7)'"; // vert (bon)
            }
        }
    }
    %>

<script>
    const ctx3 = document.getElementById('graph3').getContext('2d');

    new Chart(ctx3, {
        data: {
            labels: <%= java.util.Arrays.toString(moisLabels)
                .replace("[", "['")
                .replace("]", "']")
                .replace(", ", "', '") %>,
            datasets: [
                {
                    type: 'bar',
                    label: 'Chiffre d’affaires (Ar)',
                    data: <%= java.util.Arrays.toString(caParMois) %>,
                    backgroundColor: [<%= String.join(", ", couleurs) %>],
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    yAxisID: 'y'
                },
                {
                    type: 'line',
                    label: 'Tendance du CA',
                    data: <%= java.util.Arrays.toString(caParMois) %>,
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 2,
                    fill: false,
                    tension: 0.3,
                    pointBackgroundColor: 'rgba(255, 99, 132, 1)',
                    yAxisID: 'y'
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: 'Chiffre d’affaires par mois'
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Montant (Ar)'
                    }
                }
            }
        }
    });
</script>

<%
}catch (Exception e){
    e.printStackTrace();
}
%>
