<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="reservation.CheckOutLib" %>

<% try{
    CheckOutLib t = new CheckOutLib();
    String[] listeCrt = {"id","daty","produitlibelle","refproduit","etat_materiel_lib", "responsable"};
    String[] listeInt = {};
    String[] libEntete = {"idproduit","id","refproduit","produitlibelle", "image",  "daty","etat_materiel_lib", "responsable"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste mat&eacute;riel retour");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("check/checkout-liste.jsp");
    pr.getFormu().getChamp("daty").setLibelle("Date");
    pr.getFormu().getChamp("produitlibelle").setLibelle("Produit");
    pr.getFormu().getChamp("refproduit").setLibelle("R&eacute;f&eacute;rence produit");
    pr.getFormu().getChamp("etat_materiel_lib").setLibelle("&Eacute;tat mat&eacute;riel");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteAffiche = {"Id produit","id","R&eacute;f&eacute;rence produit", "Article", "Image", "Date","&Eacute;tat mat&eacute;riel", "Responsable"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idproduit"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attLien);
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

<script>
    function appliquerLienEntreColonnes(cola, colb) {
        const lignes = document.querySelectorAll('tr');
        lignes.forEach((ligne, index) => {
            if (index === 0) return;
            const colonnes = ligne.querySelectorAll('td');
            if (colonnes.length > Math.max(cola, colb)) {
                const colonneSource = colonnes[cola];
                const colonneDest = colonnes[colb];

                const lienSource = colonneSource.querySelector('a');
                const existeDejaLienDest = colonneDest.querySelector('a');

                if (lienSource && !existeDejaLienDest) {
                    const urlLien = lienSource.getAttribute('href');
                    const texteColonneDest = colonneDest.childNodes[0].textContent;
                    const nouveauLien = document.createElement('a');
                    nouveauLien.href = urlLien;
                    nouveauLien.textContent = texteColonneDest;

                    colonneDest.innerHTML = '';
                    colonneDest.appendChild(nouveauLien);
                }
            }
        });
    }

    function supprimerColonne(numColonne) {
        const lignes = document.querySelectorAll('tr');
        lignes.forEach(ligne => {
            const colonnes = ligne.querySelectorAll('td, th');
            if (colonnes.length > numColonne) {
                colonnes[numColonne].remove();
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        appliquerLienEntreColonnes(0, 2);
        // supprimerColonne(0);
    });


</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



