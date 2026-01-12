<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.CheckOutLib" %>
<%@ page import="reservation.Check" %>
<%@ page import="reservation.Reservation" %>


<%
  try{
    CheckOutLib t = new CheckOutLib();
    t.setNomTable("checkoutlib");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"idproduit","id", "refproduit", "produitlibelle","quantite","daty","heure","val", "responsable"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setAWhere(" and IDRESERVATIONMERE='"+request.getParameter("id")+"'");
  }
  pr.creerObjetPage(libEntete, colSomme);

  //Reservation resa=new Reservation();
  //resa.setId(request.getParameter("id"));
  //pr.getTableau().setData(resa.getListeCheckOut(null,null));
  //pr.getTableau().transformerDataString();
  int nombreLigne = pr.getTableau().getData().length;

  String monId="";
  if(pr.getTableau().getData().length>0)
    monId=((Check)(pr.getTableau().getData()[0])).getId();

  Map<String,String> lienTab=new HashMap();
//  lienTab.put("Modifier",pr.getLien() + "?but=check/checkin-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?classe=reservation.CheckOut&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkout&acte=valider&nomtable=checkout&idresa="+request.getParameter("id"));
//  lienTab.put("Annuler",pr.getLien() + "?but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkout&classe=reservation.Check&acte=annuler&id="+monId);
  lienTab.put("Facturer",pr.getLien() + "?but=vente/vente-saisie.jsp&id=" + request.getParameter("id")+"");
  pr.getTableau().setLienClicDroite(lienTab);
  //pr.getTableau().setModalOnClick(true);


%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID Produit","ID", "R&eacute;ference", "Produit","Quantit&eacute;","Date de fin","Heure", "Magasin", "Responsable"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=check/checkout-fiche.jsp",pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id","idproduit"};
    String attLien[] = {"id","id"};
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    CheckOutLib[] liste=(CheckOutLib[]) pr.getTableau().getData();
    String lien = "";

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
        appliquerLienEntreColonnes(0, 2);
        // supprimerColonne(0);
    });


</script>
<%=pr.getModalHtml("modalContent")%>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
