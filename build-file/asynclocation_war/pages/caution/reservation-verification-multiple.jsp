<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>

<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="reservation.*"%>
<%@ page import="caution.ReservationVerification" %>
<%@ page import="caution.ReservationVerifDetails" %>

<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        ReservationVerification mere = new ReservationVerification();
        ReservationVerifDetails fille = new ReservationVerifDetails();
        int nombreLigne = 10;
        ReservationLib resas = null;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);

        String idresa = request.getParameter("id");
        ReservationVerifDetails[] ventesDetails = null;
        Reservation resa = new Reservation();
        if (idresa != null && !idresa.equalsIgnoreCase(""))
        {
            resa.setId(idresa);
            pi.getFormu().getChamp("idReservation").setDefaut(request.getParameter("id"));
            ventesDetails = resa.genererResaVerifDetails(null);
        }

        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("observation").setLibelle("Observation");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("idReservation").setAutre("readonly");
        pi.getFormu().getChamp("idReservation").setLibelle("R&eacute;servation");

        pi.getFormufle().getChamp("idreservationdetails_0").setLibelle("D&eacute;tails de r&eacute;servation");
        pi.getFormufle().getChamp("dateretour_0").setLibelle("Date de retour");
        pi.getFormufle().getChamp("jour_retard_0").setLibelle("Jour de retard");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");
        pi.getFormufle().getChamp("etat_materiel_0").setLibelle("&Eacute;tat du Mat&eacute;riel");
        pi.getFormufle().getChamp("observation_0").setLibelle("Observation");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("retenue_0").setLibelle("Retenue en %");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idreservationverif").setVisible(false);

        for(int i=0;i<pi.getNombreLigne();i++){
            pi.getFormufle().getChamp("jour_retard_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("idreservationdetails_"+i).setAutre("readonly");
        }
        String[]ordres={"designation", "idreservationdetails", "jour_retard", "etat_materiel", "observation", "retenue"};
        pi.getFormufle().setColOrdre(ordres);


        if(ventesDetails != null && ventesDetails.length>0){
            pi.setDefautFille(ventesDetails);
            for (int i =0;i< ventesDetails.length; i++){
                pi.getFormufle().getChamp("dateretour_"+i).setDefaut(Utilitaire.dateDuJour());
            }
        }
        pi.preparerDataFormu();
       // String[] order = {"idreservationdetails", "dateretour", "jour_retard", "etat_materiel", "observation"};
        //pi.getFormufle().setColOrdre(order);
        //Variables de navigation
        String classeMere = "caution.ReservationVerification";
        String classeFille = "caution.ReservationVerifDetails";
        String butApresPost = "caution/reservationverif-fiche.jsp";
        String colonneMere = "idreservationverif";

        String[] ordre = {"daty"};
        pi.getFormu().setOrdre(ordre);

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Saisie de v&eacute;rification de location</h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="RESERVATION_VERIF_DETAILS">
        </form>
    </div>
</div>
<script>
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

    /*
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
    }*/
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

