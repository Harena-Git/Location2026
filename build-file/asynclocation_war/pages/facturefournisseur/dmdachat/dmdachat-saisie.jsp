<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="faturefournisseur.*"%>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        DmdAchat mere = new DmdAchat();
        DmdAchatFille fille = new DmdAchatFille();
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet typeMed= new TypeObjet();
        typeMed.setNomTable("BU");
        liste[0] = new Liste("idBu", typeMed, "val", "id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("idCommande").setLibelle("Commande");
        pi.getFormu().getChamp("idBu").setLibelle("BU");
        pi.getFormu().getChamp("idCommande").setPageAppelComplete("vente.BonDeCommande","id","BONDECOMMANDE_CLIENT");
        pi.getFormu().getChamp("fournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","fournisseur;fournisseurlibelle","id;nom");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","libelle;pu","designation;pu");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idproduit"),"annexe/produit/produit-saisie.jsp","id;val");

        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idmere").setVisible(false);

        pi.getFormufle().getChampMulitple("quantite").setAutre("onChange='calculerMontant()'");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("quantite"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tva"),"0");

        pi.preparerDataFormu();

        String classeMere = "faturefournisseur.DmdAchat";
        String classeFille = "faturefournisseur.DmdAchatFille";
        String butApresPost = "facturefournisseur/dmdachat/dmdachat-fiche.jsp";
        String colonneMere = "idmere";

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Nouvelle demande d'achat</h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12" >
                <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;">Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
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
            <input name="nomtable" type="hidden" id="nomtable" value="DMDACHATFILLE">
        </form>
    </div>
</div>
</div>
<script>
    function calculerMontant() {
        var val = 0;
        $('input[id^="quantite_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("quantite","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });
        $("#montanttotal").html(val.toFixed(2));
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

