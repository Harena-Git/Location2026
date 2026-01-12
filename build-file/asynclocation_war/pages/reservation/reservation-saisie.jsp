<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>

<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="client.Client" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="proforma.Proforma" %>
<%@ page import="magasin.Magasin" %>
<%
  try {

    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    ReservationDetails fille = new ReservationDetails();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("daty").setAutre("OnChange='updateDate(this)'");
    pi.getFormu().getChamp("margemoins").setLibelle("Marge moins");
    pi.getFormu().getChamp("margeplus").setLibelle("Marge plus");
    pi.getFormu().getChamp("margemoins").setDefaut("1");
    pi.getFormu().getChamp("margeplus").setDefaut("1");
      pi.getFormu().getChamp("lieulocation").setLibelle("Location");
      pi.getFormu().getChamp("idorigine").setLibelle("Id origine");
      pi.getFormu().getChamp("caution").setLibelle("Caution (En %)");
      pi.getFormu().getChamp("caution").setDefaut("50");
      pi.getFormu().getChamp("remise").setLibelle("Remise (En %)");
      pi.getFormu().getChamp("tva").setLibelle("Tva (En %)");

    Liste[] liste = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("magasin");
    liste[0] = new Liste("idMagasin",m,"val","id");
    pi.getFormu().changerEnChamp(liste);

    Client client = null;
    if(request.getParameter("idclient")!=null){
      pi.getFormu().getChamp("idclient").setDefaut(request.getParameter("idclient"));
      client = (Client)new Client().getById(request.getParameter("idclient"),null,null);
    }
    String daty = request.getParameter("daty");
    String idproduit = request.getParameter("idproduit");
    String tranche = request.getParameter("tranche");

      pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idclient").setPageAppelInsert("client/client-saisie.jsp","id;nom","id;nom");
    //pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client","id","Client", "client/client-saisie.jsp","id;nom");

    pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_M","pu;compte_vente;libelle;tva;unite","pu;compte;designation;tva;unite");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute; (en jours)");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("qtearticle_0").setLibelle("Quantit&eacute; article");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date de d&eacute;but");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure de d&eacute;but");
    pi.getFormufle().getChamp("margemoins_0").setLibelle("Marge moins");
    pi.getFormufle().getChamp("margeplus_0").setLibelle("Marge plus");

    pi.getFormufle().getChamp("margemoins_0").setDefaut("1");
    pi.getFormufle().getChamp("margeplus_0").setDefaut("1");


    for (int i = 0; i < nombreLigne; i++)
    {
      pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
      pi.getFormufle().getChamp("qtearticle_"+i).setDefaut("0");
      pi.getFormufle().getChamp("qtearticle_"+i).setAutre("onChange='calculerMontant()'");
      //pi.getFormufle().getChamp("idVoiture_"+i).setAutre("readOnly");
      pi.getFormufle().getChamp("daty_"+i).setDefaut(Utilitaire.dateDuJour());
      pi.getFormufle().getChamp("heure_"+i).setDefaut(Utilitaire.heureCouranteHM());
      pi.getFormufle().getChamp("margemoins_"+i).setDefaut("1");
      pi.getFormufle().getChamp("margeplus_"+i).setDefaut("1");

      if (daty != null && !daty.equalsIgnoreCase(""))
        {
          pi.getFormufle().getChamp("daty_"+i).setDefaut(daty);
        }
        if(tranche!=null && !tranche.equalsIgnoreCase("")){
          pi.getFormufle().getChamp("heure_"+i).setDefaut(ConstanteAsync.getHeureTranche(tranche));
        }
    }
    if(idproduit != null && !idproduit.equalsIgnoreCase("")){
      //String aWhere = "  and idVoiture = '"+idproduit+"'";
      affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pu","pu","");
    }

    String idProforma = request.getParameter("idProforma");
    if (idProforma != null && !idProforma.trim().isEmpty()) {
      //pi.getFormu().getChamp("idProforma").setDefaut(request.getParameter("idProforma"));
      Proforma proforma = new Proforma();
      proforma.setId(idProforma);
      Reservation bc = proforma.createReservation();
      ReservationDetails[] details = (ReservationDetails[]) bc.getFille();
      pi.setDefautFille(details);
      pi.getFormu().setDefaut(bc);
    }

    pi.preparerDataFormu();
    pi.getFormu().setOrdre(new String[]{"daty","idclient","remarque","margemoins","margeplus"});
    String[] order = {"idproduit","qtearticle", "qte","pu","margemoins","margeplus","remarque", "daty","heure"};
    pi.getFormufle().setColOrdre(order);

    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.ReservationDetails";
    String butApresPost = "reservation/reservation-fiche.jsp";
    String colonneMere = "idmere";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

    String titre = "Enregistrement de r&eacute;servation";
    String apres = "apresMultiple.jsp";
    String acte = "insert";
    if(request.getParameter("acte")!=null){
      titre = "Remplacement r&eacute;servation";
      apres = "reservation/apresRemplacement.jsp";
      acte = "replacement";
      butApresPost = "vente/vente-fiche.jsp";
    }
%>
<div class="content-wrapper">
  <h1><%= titre %></h1>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=<%=apres%>" method="post" >
      <%
        out.println(pi.getFormu().getHtmlInsert());
      %>
      <div class="col-md-12" >
        <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
      </div>
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="<%= acte %>">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
      <input name="nomtable" type="hidden" id="nomtable" value="RESERVATIONDETAILS">
    </form>
  </div>
</div>
<script>
(function () {
  function getChildren(prefix) {
    return Array.from(document.querySelectorAll(
      'input[id^="'+prefix+'_"], input[name^="'+prefix+'_"],' +
      'select[id^="'+prefix+'_"], select[name^="'+prefix+'_"],' +
      'textarea[id^="'+prefix+'_"], textarea[name^="'+prefix+'_"]'
    ));
  }

  function setupSync(prefix) {
    const main = document.getElementById(prefix) || document.querySelector('[name="'+prefix+'"]');
    if (!main) {
      console.warn('Champ ma�tre introuvable pour:', prefix);
      return;
    }

    const apply = () => {
      const val = main.value;
      getChildren(prefix).forEach(el => {
        if (el !== main) el.value = val;
      });
    };

    main.addEventListener('input', apply);
    main.addEventListener('change', apply);

    apply();

    const observer = new MutationObserver(() => apply());
    observer.observe(document.body, { childList: true, subtree: true });
  }

  document.addEventListener('DOMContentLoaded', function () {
    setupSync('margemoins');
    setupSync('margeplus');
  });
})();


function calculerMontant() {
    var totalTTC = 0;

    $('input[id^="qtearticle_"]').each(function() {
        var id = $(this).attr('id');
        var index = id.split("_")[1];

        var qte = parseFloat($(this).val());
        var pu = parseFloat($("#pu_" + index).val());

        if (!isNaN(qte) && !isNaN(pu)) {
            var montantHT = qte * pu;
            var montantTTC = montantHT;

            totalTTC += montantTTC;
        }
    });
    $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }).format(totalTTC));
}
</script>



 <script>
  <% if(client != null ) { %>
  document.getElementById('idclientlibelle').value = '<%=client.getNom()%>';
  <% } %>

  async function chargerProduits(ids) {
    // Exemple d'IDs à envoyer

    // Construire la query string : ?ids=1&ids=2&ids=3
    const params = new URLSearchParams();
    ids.forEach(id => params.append("ids", id));

    // Appel à la servlet
    await fetch("<%=request.getContextPath()%>/api/ProduitServlet?" + params.toString())
            .then(response => {
              if (!response.ok) throw new Error("Erreur serveur " + response.status);
              return response.json();
            })
            .then(data => {
              console.log("Résultat JSON :", data);
              for (let i = 0; i < data.length; i++) {
                document.getElementById('idproduit_'+i+"libelle").value = data[i];
              }
            })
            .catch(err => {
              console.error("Erreur AJAX :", err);
            });
  }

  async function affNomProduit (){
    const loader = document.getElementById("loader");

    loader.style.display = "flex";

    try {
      var listChamp = document.querySelectorAll('input[id^="qte_"]');
      let ids = [];
      for (let i = 0; i < listChamp.length; i++) {
        let idProduit = document.getElementById('idproduit_'+i).value;
        if (idProduit!=null && idProduit!=='' ){
          ids.push(idProduit);
        }
      }
      await chargerProduits(ids);
    } catch (err) {
      console.error("Erreur updateFille :", err);
    } finally {
      loader.style.display = "none";
    }

  }

  function updateDate (dateMere){
    var listChamp = document.querySelectorAll('input[id^="qte_"]');
    for (let i = 0; i < listChamp.length; i++) {
        document.getElementById('daty_'+i).value = dateMere.value;
    }
  }
  document.addEventListener('DOMContentLoaded', function () {
    updateDate(document.getElementById('daty'));
    affNomProduit();
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
