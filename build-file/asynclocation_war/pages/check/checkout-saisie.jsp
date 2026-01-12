<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.*" %>
<%@page import="annexe.Point"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="utils.ConstanteLocation" %>
<%
  try {
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    CheckOut fille = new CheckOut("CHECKOUT");
    String idreservation = request.getParameter("idresa");
    Check[] res = null;
    if(idreservation!=null){
mere.setId(idreservation);
      res = mere.getListeCheckIn("CHECKOUT_DATERETOUR",null);
    }
    int nombreLigne = res == null ? 10 : res.length;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);


    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("idclient").setVisible(false);
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("reservation_0").setLibelle("Produit");

    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("reservation"),"reservation.Check","id","CHECKINLIBELLE","id","id"," and idreservationmere = '"+idreservation+"'");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date de la r&eacute;ception");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure de la r&eacute;ception");
    pi.getFormufle().getChampMulitple("kilometrage").setVisible(false);
    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
      pi.getFormufle().getChamp("etat_materiel_0").setLibelle("&Eacute;tat du materiel");
      pi.getFormufle().getChamp("jour_retard_0").setLibelle("Jour de retard");
      pi.getFormufle().getChamp("etat_materiel_lib_0").setLibelle("&Eacute;tat du mat&eacute;riel");
      pi.getFormufle().getChamp("retenue_0").setLibelle("Retenue (en %)");
      pi.getFormufle().getChamp("responsable_0").setLibelle("Responsable");
      pi.getFormufle().getChamp("refproduit_0").setLibelle("R&eacutef&eacute;rence produit");

      pi.getFormufle().getChampMulitple("etat_materiel").setVisible(false);
      pi.getFormufle().getChampMulitple("etat").setVisible(false);
    pi.getFormufle().getChampMulitple("remarque").setVisible(false);

    affichage.Liste[] liste = new Liste[1];
    Magasin cat= new Magasin();
		liste[0] = new Liste("idmagasin", cat, "val", "id");
		pi.getFormufle().changerEnChamp(liste);

    for(int i = 0; i < nombreLigne; i++){
      pi.getFormufle().getChamp("daty_"+i).setDefaut(utilitaire.Utilitaire.dateDuJour());
      pi.getFormufle().getChamp("heure_"+i).setDefaut(utilitaire.Utilitaire.heureCouranteHM());
      pi.getFormufle().getChamp("idmagasin_"+i).setDefaut(Point.getDefaultMagasin());
      pi.getFormufle().getChamp("etat_materiel_"+i).setDefaut("0");
    }
    if(idreservation!=null&&res.length>0){
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        for (int i = 0; i < res.length; i++)
        {
            pi.getFormufle().getChamp("jour_retard_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("reservation_"+i).setDefaut(res[i].getId());
            pi.getFormufle().getChamp("idmagasin_"+i).setDefaut(ConstanteLocation.magasinAtioik);
            pi.getFormufle().getChamp("quantite_"+i).setDefaut(String.valueOf(res[i].getQte()));
            pi.getFormufle().getChamp("refproduit_"+i).setDefaut(res[i].getRefproduit());
            if (res[i].getDaty() != null){
                pi.getFormufle().getChamp("daty_"+i).setDefaut(sdf.format(res[i].getDaty()));
            }
        }
    }
    pi.getFormufle().getChamp("idmagasin_0").setLibelle("Lieu de stockage");

    pi.preparerDataFormu();
    String[] order = {"refproduit", "reservation", "daty","heure","quantite","responsable","retenue","jour_retard","idmagasin","etat_materiel_lib"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.CheckOut";
    String butApresPost = "reservation/reservation-fiche.jsp&id="+idreservation+"&tab=inc/liste-checkout";
    String colonneMere = "";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
  <h1>Enregistrement de la r&eacute;ception</h1>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="nomtable" type="hidden" id="nomtable" value="CHECKOUT">
    </form>
  </div>
</div>
<script>
    const valeurs = [
    <% if (res != null) {
      for (int i = 0; i < res.length; i++) { %>
    {
      Produit: "<%= res[i].getProduitLibelle() %>"
    } <%= (i < res.length - 1) ? "," : "" %>
      <% }
    } %>
    ];
    window.addEventListener('DOMContentLoaded', function() {
      for (let i = 0; i < valeurs.length; i++) {
        const produitInput = document.getElementById('reservation_' + i +'libelle');
        if (produitInput) produitInput.value = valeurs[i].Produit;
      }
    }
  );

    function calculerMontant(indice, source) {
        var totalTTC = 0;
        $('input[id^="jour_retard_"]').each(function() {
            var id = $(this).attr('id');
            var index = id.split("_")[2];
            var jour_retard = parseFloat($(this).val());
            if (!isNaN(jour_retard)) {
                var montantHT = (jour_retard * 5);
                if(parseFloat(montantHT)>100){
                    $("#retenue_"+index).val(100);
                }else{
                    $("#retenue_"+index).val(montantHT);
                }

            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(totalTTC));
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('button[name="Submit2"]').innerText = 'Enregistrer et Valider';
    });
</script>
<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>
