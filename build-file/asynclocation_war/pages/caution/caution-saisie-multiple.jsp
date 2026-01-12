<%@ page import="user.UserEJB" %>
<%@ page import="caution.CautionDetails" %>
<%@ page import="caution.Caution" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-26
  Time: 21:20
  To change this template use File | Settings | File Templates.
--%>

<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Caution mere = new Caution();
        CautionDetails fille = new CautionDetails();
        int nombreLigne = 10;
        Caution defaut = null;
        String idresa = request.getParameter("id");

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);

        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[1];
        TypeObjet mode = new TypeObjet("modepaiement");
        liste[0] = new Liste("idmodepaiement",mode,"val","id");
        pi.getFormu().changerEnChamp(liste);

        if(idresa!=null && !idresa.equalsIgnoreCase("")){
            Caution cau = new Caution();
            cau.setIdreservation(idresa);
            defaut = cau.genererCaution(null);
        }

        pi.getFormu().getChamp("idreservation").setLibelle("R&eacute;servation");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("montantreservation").setVisible(false);
        pi.getFormu().getChamp("idreservation").setAutre("readonly");
        pi.getFormu().getChamp("idmodepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("referencepaiement").setLibelle("R&eacute;f&eacute;rence de paiement");
        pi.getFormu().getChamp("pct_applique").setLibelle("Taux appliqu&eacute;e");
        pi.getFormu().getChamp("pct_applique").setAutre("readonly");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("dateprevuerestitution").setLibelle("Date pr&eacute;vue de restitution");

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idingredient"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","libelle","designation");


        pi.getFormufle().getChamp("idreservationdetails_0").setLibelle("D&eacute;tails de location");
        pi.getFormufle().getChamp("idingredient_0").setLibelle("Produit");
        pi.getFormufle().getChamp("montantreservation_0").setLibelle("Montant de la location");
        pi.getFormufle().getChamp("pct_applique_0").setLibelle("Taux appliqu&eacute;");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idcaution").setVisible(false);

        if(defaut != null && defaut.getFille().length>0){
            pi.getFormu().setDefaut(defaut);
            pi.setDefautFille(defaut.getFille());
        }

        pi.preparerDataFormu();

        for(int i=0;i<pi.getNombreLigne();i++){
            pi.getFormufle().getChamp("idreservationdetails_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantreservation_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montant_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("pct_applique_"+i).setAutre("onChange='calculerMontant("+i+")'");
        }
        //String[] order = {"idProduit", "designation", "compte", "qte", "pu", "remise", "tva" ,"tauxDeChange","datereservation"};
        //pi.getFormufle().setColOrdre(order);

        //Variables de navigation
        String classeMere = "caution.Caution";
        String classeFille = "caution.CautionDetails";
        String butApresPost = "caution/caution-fiche.jsp";
        String colonneMere = "idcaution";
        //Preparer les affichages

        String[] ordre = {"daty"};
        pi.getFormu().setOrdre(ordre);

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Saisie des cautions</h1>
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
            <input name="nomtable" type="hidden" id="nomtable" value="CautionDetails">
        </form>
    </div>
</div>
<script>
    function calculerMontant(indice, source) {
        var totalTTC = 0;
        $('input[id^="pct_applique_"]').each(function() {
            var id = $(this).attr('id');
            var index = id.split("_")[2];
            var pct_applique = parseFloat($(this).val());
            var montantreservation = parseFloat($("#montantreservation_" + index).val());
            if (!isNaN(pct_applique) && !isNaN(montantreservation)) {
                var montantHT = (pct_applique * montantreservation)/100;
                totalTTC += montantHT;
                $("#montant_"+index).val(montantHT);
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


