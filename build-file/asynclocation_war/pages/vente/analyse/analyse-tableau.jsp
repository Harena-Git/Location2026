<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="vente.VenteDetailAnalyse" %>
<%@ page import="vente.StatistiqueTop" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="vente.StatistiqueVente" %>
<%@ page import="user.UserEJB" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    StatistiqueTop t = new StatistiqueTop();
    t.setNomTable("StatistiqueTop");
    String listeCrt[] = {"datejour","top"};
    String listeInt[] = {"datejour","top"};
    String libEntete[] = {"idProduit","idProduitLib","caproduit","idClient","idClientLib","caclient"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("STATISTIQUE");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/analyse/analyse-tableau.jsp");
    pr.getFormu().getChamp("datejour1").setLibelle("Date min");
    pr.getFormu().getChamp("datejour1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datejour2").setLibelle("Date max");
    pr.getFormu().getChamp("datejour2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("top1").setDefaut("1");
    pr.getFormu().getChamp("top2").setDefaut("3");
    pr.getFormu().getChamp("top1").setVisible(false);
    pr.getFormu().getChamp("top2").setLibelle("Top");
    pr.getFormu().setAnotherButton("<button class='btn btn-primary btn-small' id='export_resultat' type='button'> Exporter le resultat </button>");
    //pr.getFormu().getChamp("top").setDefaut("3");
    String[] colSomme = {"caproduit","caclient"};
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteRecap = {"","Nombre","Somme du chiffre d'affaire par produit","Somme du chiffre d'affaire par client"};
    pr.getTableauRecap().setLibeEntete(libEnteteRecap);

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idProduit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID Article","Article","Chiffre d'affaire par article","ID Client","Client","Chiffre d'affaire par client"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

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

    StatistiqueVente [] dataStat3 = (StatistiqueVente[]) pr3.getTableau().getData();

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

<style>
    .main-footer{
        display: none;
    }
</style>

<div class="content-wrapper" id="content-wrapper-id">
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
        <div class="col-md-6 nopadding mb-4">
            <div class="cardradius h-100">
                <div class="card-body">
                    <canvas id="graph1"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="cardradius h-100">
                <div class="card-body">
                    <canvas id="graph2"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="cardradius h-100">
<%--                <div class="card-body">--%>
<%--                    <canvas id="graph3"></canvas>--%>
<%--                </div>--%>
                <div style="width:100%; height:350px;">
                    <canvas id="graph3"></canvas>
                </div>
            </div>
        </div>

<%
    // Récupérer les données pour les graphiques
    java.util.Map<String, Double> dataClientMap = AdminGen.getDataChart(pr.getTableau().getData(), "idClientLib", "caclient");
    java.util.Map<String, Double> dataProduitMap = AdminGen.getDataChart(pr.getTableau().getData(), "idProduitLib", "caproduit");

    // Préparer les labels et valeurs pour le JS
    String clientLabels = dataClientMap.keySet().toString().replace("[", "['").replace("]", "']").replace(", ", "', '");
    String clientData = dataClientMap.values().toString();

    String produitLabels = dataProduitMap.keySet().toString().replace("[", "['").replace("]", "']").replace(", ", "', '");
    String produitData = dataProduitMap.values().toString();
%>

<script>
    // Camembert Clients
    const ctxClient = document.getElementById('graph1').getContext('2d');
    new Chart(ctxClient, {
        type: 'pie',
        data: {
            labels: <%= clientLabels %>,
            datasets: [{
                data: <%= clientData %>,
                backgroundColor: [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: 'Répartition du chiffre d\'affaires par client'
                },
                datalabels: {
                    color: '#fff',
                    formatter: function(value, context) {
                        let total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                        let percentage = (value / total * 100).toFixed(2) + '%';
                        return value + ' (' + percentage + ')';
                    },
                    font: {
                        weight: 'bold',
                        size: 12
                    }
                }
            }
        },
        plugins: [ChartDataLabels] // activer le plugin
    });

    // Camembert Produits
    const ctxProduit = document.getElementById('graph2').getContext('2d');
    new Chart(ctxProduit, {
        type: 'pie',
        data: {
            labels: <%= produitLabels %>,
            datasets: [{
                data: <%= produitData %>,
                backgroundColor: [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: 'Répartition du chiffre d\'affaires par produit'
                },
                datalabels: {
                    color: '#fff',
                    formatter: function(value, context) {
                        let total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                        let percentage = (value / total * 100).toFixed(2) + '%';
                        return value + ' (' + percentage + ')';
                    },
                    font: {
                        weight: 'bold',
                        size: 12
                    }
                }
            }
        },
        plugins: [ChartDataLabels]
    });
</script>

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
                    label: "Chiffre d'affaires (Ar)",
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
                    tension: 0.3,
                    fill: false,
                    pointBackgroundColor: 'rgba(255, 99, 132, 1)',
                    yAxisID: 'y'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // <<< clé responsive
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: "Chiffre d'affaires par mois"
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
    </section>
</div>
<script>
    $(document).ready(function() {
        $(document).on('click', '#export_resultat', function(e) {
            e.preventDefault();

            var element = document.querySelector('.content-wrapper');
            var btn = $(this);

            // 1. Sauvegarder le style actuel pour le remettre après
            var originalMargin = $(element).css('margin-left');
            var originalWidth = $(element).css('width');
            var originalOverflow = $(element).css('overflow');
            var originalBg = $(element).css('background');

            // 2. PRÉPARATION : On force une largeur fixe idéale pour le PDF
            // 1200px est suffisant pour que le tableau tienne sans scrollbar
            btn.hide();

            $(element).css({
                'margin-left': '0px',      // Enlève la marge de la sidebar
                'width': '1200px',         // Force une largeur large pour éviter le scroll
                'min-width': '1200px',     // Sécurité
                'overflow': 'visible',     // Force l'affichage de tout le contenu
                'background': 'white'      // Fond blanc propre
            });

            // 3. IMPORTANT : Forcer Chart.js à redimensionner les graphiques
            // Sinon ils garderont leur ancienne taille et paraîtront petits ou coupés
            for (var id in Chart.instances) {
                Chart.instances[id].resize();
            }

            // 4. Petit délai pour laisser le temps au navigateur d'appliquer les changements
            setTimeout(function() {
                domtoimage.toPng(element)
                    .then(function (dataUrl) {
                        // --- Création du PDF ---
                        var pdf = new jsPDF('p', 'mm', 'a4');
                        var pdfWidth = pdf.internal.pageSize.getWidth();
                        var pdfHeight = pdf.internal.pageSize.getHeight();

                        // Calcul des dimensions de l'image dans le PDF
                        var imgProps = pdf.getImageProperties(dataUrl);
                        var imgHeight = (imgProps.height * pdfWidth) / imgProps.width;

                        // Si l'image est plus haute qu'une page A4, on gère (optionnel, ici on fit tout)
                        // Pour l'instant on ajoute l'image ajustée à la largeur
                        pdf.addImage(dataUrl, 'PNG', 0, 0, pdfWidth, imgHeight);

                        pdf.save('statistiques.pdf');

                        // --- RESTAURATION ---
                        // On remet tout comme avant
                        $(element).css({
                            'margin-left': originalMargin,
                            'width': originalWidth,
                            'min-width': '',
                            'overflow': originalOverflow,
                            'background': originalBg
                        });

                        // On redimensionne les charts pour l'écran normal
                        for (var id in Chart.instances) {
                            Chart.instances[id].resize();
                        }
                        btn.show();
                    })
                    .catch(function (error) {
                        console.error('Erreur export:', error);
                        // Restauration en cas d'erreur
                        $(element).css({'margin-left': originalMargin, 'width': originalWidth});
                        btn.show();
                    });
            }, 500); // Attente de 500ms
        });
    });
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



