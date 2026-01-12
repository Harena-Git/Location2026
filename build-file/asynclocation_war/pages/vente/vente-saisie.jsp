<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>


<%@page import="caisse.Caisse"%>
<%@page import="vente.InsertionVente"%>
<%@page import="vente.VenteDetails"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="produits.*"%>
<%@page import="reservation.*"%>
<%@ page import="oracle.net.aso.i" %>
<%@ page import="vente.BonDeCommande" %>
<%@ page import="vente.Vente" %>

<%
    try {
        UserEJB u = null;
        BonDeCommande bc = new BonDeCommande();
        u = (UserEJB) session.getValue("u");
        InsertionVente mere = new InsertionVente();
        VenteDetails fille = new VenteDetails();
        fille.setNomTable("vente_details_saisie");
        int nombreLigne = 30;
        ReservationLib resas = null;
        if (request.getParameter("id") != null && !request.getParameter("id").equalsIgnoreCase(""))
        {
            resas = (ReservationLib) new ReservationLib().getById(request.getParameter("id"),null,null);
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        Vente vente = null;
        VenteDetails[] ventesDetails = null;
        if(request.getParameter("idBC") != null ){
            bc.setId(request.getParameter("idBC"));
            vente = bc.genereFacture(null);
            ventesDetails = vente.getVenteDetails();
        }

        String idresa = request.getParameter("id");

        Reservation resa = new Reservation();
        if (idresa != null && !idresa.equalsIgnoreCase(""))
        {
            resa.setId(idresa);
            ventesDetails = resa.genereVenteDetails("CHECKINAVECCHEKOUT",null);
        }

        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[1];
        liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
        /*
        liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[1].setDefaut("AR");
        liste[2] = new Liste("estPrevu");
        liste[2].makeListeOuiNon();
        */

        
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setLibelle("R&eacute;servation");
        pi.getFormu().getChamp("idMagasin").setLibelle("Site");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("estPrevu").setVisible(false);
        pi.getFormu().getChamp("datyPrevu").setLibelle("Date pr&eacute;visionnelle d'encaissement");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setDefaut("AR");
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        pi.getFormu().getChamp("idReservation").setDefaut(request.getParameter("id"));
        pi.getFormu().getChamp("idReservation").setVisible(false);
        pi.getFormu().getChamp("caution").setLibelle("Caution (en %)");
        if (resas != null) {
            pi.getFormu().getChamp("idOrigine").setDefaut(resas.getId());
            pi.getFormu().getChamp("idOrigine").setAutre("readonly");
            pi.getFormu().getChamp("idReservation").setDefaut(resas.getId());
            pi.getFormu().getChamp("idClient").setDefaut(resas.getIdclient());
            pi.getFormu().getChamp("designation").setDefaut(resas.getRemarque());
        }
        else {
            pi.getFormu().getChamp("idOrigine").setPageAppelComplete("reservation.Reservation","id","reservation");
        }
        pi.getFormu().setOrdre(new String[]{"daty"});
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB_MGA","puVente;puAchat;taux;val;compte;compte","pu;puAchat;tauxDeChange;designation;compte;comptelibelle");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_M","pv;compte_vente;libelle;tva","pu;compte;designation;tva");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idDevise"),"AR");

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("datereservation_0").setLibelle("Date de r&eacute;servation");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("remise");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        pi.getFormufle().getChamp("nombre_0").setLibelle("Nombre");
        
        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);

        for(int i=0;i<pi.getNombreLigne();i++){
            pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
        }
        if(vente!=null) {
            pi.getFormu().setDefaut(vente);
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.formatterDaty(vente.getDaty()));
            pi.getFormu().getChamp("datyPrevu").setDefaut(Utilitaire.formatterDaty(vente.getDatyPrevu()));
        }
        if(ventesDetails != null && ventesDetails.length>0){
            System.err.println("======"+ventesDetails.length);
            pi.setDefautFille(ventesDetails);
            for (int i =0;i< ventesDetails.length; i++){
                pi.getFormufle().getChamp("datereservation_"+i).setDefaut(Utilitaire.formatterDaty(ventesDetails[i].getDatereservation()));
            }
        }
        pi.preparerDataFormu();


        String[] order = {"idProduit", "designation", "compte", "qte", "pu","nombre", "remise", "tva" ,"tauxDeChange","datereservation"};
        pi.getFormufle().setColOrdre(order);

        //Variables de navigation
        String classeMere = "vente.InsertionVente";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "vente/vente-fiche.jsp";
        String colonneMere = "idVente";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Enregistrement de la facture client</h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12" >
                <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
            </div>
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="Vente_Details">
        </form>
    </div>
</div>



<script>
(function() {
    function formatWithSpaces(value) {
        if (value === null || value === undefined || value === "") return "";

        // Convertir la valeur en chaîne et normaliser
        let str = String(value).replace(/\s/g, '').replace(',', '.');

        // Convertir en nombre flottant
        let num = parseFloat(str);
        if (isNaN(num)) return "";

        // Séparer la partie entière et la partie décimale
        let [intPart, decPart] = num.toString().split(".");

        // Ajouter les espaces comme séparateur de milliers
        const formattedInt = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, " ");

        // Si la partie décimale est absente ou égale à 0 → ne pas l'afficher
        if (!decPart || parseInt(decPart) === 0) {
            return formattedInt;
        }

        // Sinon, afficher la virgule et la partie décimale
        return `${formattedInt},${decPart}`;
    }


    function toRaw(value) {
    return String(value || '').replace(/\s/g, '').replace(',', '.');
  }

  function applyFormat() {
    document.querySelectorAll('input[name^="pu_"]').forEach(inp => {
      if (!inp.dataset.bound) {
        inp.dataset.bound = "1";
        inp.style.textAlign = "right";

        inp.addEventListener('input', () => {
          const raw = toRaw(inp.value);
          inp.value = formatWithSpaces(raw);
        });

        inp.form?.addEventListener('submit', () => {
          document.querySelectorAll('input[name^="pu_"]').forEach(p => {
            p.value = toRaw(p.value);
          });
        });
      }

      const cur = inp.value.trim();

        console.log({cur})
      if (cur && cur !== formatWithSpaces(cur)) {
          console.log(formatWithSpaces(cur))
        inp.value = formatWithSpaces(cur);
      }
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    applyFormat();
    setInterval(applyFormat, 300);
  });
})();
</script>

<script>
    function calculerMontant(indice, source) {
        var totalTTC = 0;

        $('input[id^="qte_"]').each(function() {
            var id = $(this).attr('id');
            var index = id.split("_")[1];

            var qte = parseFloat($(this).val());
            var pu = parseFloat($("#pu_" + index).val());
            var tva = parseFloat($("#tva_" + index).val());

            if (!isNaN(qte) && !isNaN(pu)) {
                var montantHT = qte * pu;
                var montantTTC = montantHT;

                if (!isNaN(tva)) {
                    montantTTC += montantHT * (tva / 100);
                }

                totalTTC += montantTTC;
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(totalTTC));
    }

    //
    function deviseModification() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "produit_lib_mga",
                    },
                    "USD": {
                        "table": "produit_lib_usd"
                    },
                    "EUR": {
                        "table": "produit_lib_euro"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "annexe.ProduitLib", "true","puVente;puAchat;taux;val;compte");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'puAchat_'+iL,'tauxDeChange_'+iL,'designation_'+iL, 'compte_'+iL];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#idProduit_"+iL+"libelle").off('keydown');
                $("#idProduit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#idProduit_"+iL+"libelle").off('input');
                $("#idProduit_"+iL+"libelle").on('input', function() {
                    $("#idProduit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#idProduit_"+iL+"searchBtn").off('click');
                $("#idProduit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#idProduit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#idProduit_"+iL+"libelle").val());
                });
            });
        }
    }
    <% if(request.getParameter("id") != null) { %>
    document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('idClientlibelle').value = '<%=resas.getIdclientlib()%>';
    });


        const valeurs = [
        <% if (ventesDetails != null) {
            for (int i = 0; i < ventesDetails.length; i++) { %>
        {
            Produit: "<%= ventesDetails[i].getDesignation() %>"
        } <%= (i < ventesDetails.length - 1) ? "," : "" %>
        <% }
        } %>
        ];
        window.addEventListener('DOMContentLoaded', function() {
            for (let i = 0; i < valeurs.length; i++) {
                const produitInput = document.getElementById('idProduit_' + i +'libelle');
                if (produitInput){
                    produitInput.value = valeurs[i].Produit;
                    calculerMontant(i);
                }
            }
        }
        );
<% } %>
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

