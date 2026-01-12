<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>


<%
  try{
    ReservationDetailsLib t = new ReservationDetailsLib();
    t.setNomTable("RESERVATIONDETAILS_LIB_MARGE");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"idproduit","referenceproduit", "libelleproduit", "image", "qtearticle","qte","daty"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID","Reference", "Produit", "Image", "Quantit&eacute;","Nombre de jours","Date de R&eacute;servation"};
    //pr.getTableau().setTailleImage("100");
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idproduit"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
    }if(pr.getTableau().getHtml() == null)
  {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }


%>
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
        appliquerLienEntreColonnes(0, 1);
        // supprimerColonne(0)
    });
</script>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
