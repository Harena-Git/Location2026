<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="user.UserEJB"%>
<%@ page import="vente.dmdprix.DmdPrix" %>
<%@ page import="vente.dmdprix.DmdPrixFille" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (UserEJB) session.getValue("u");
        String classeMere = "vente.dmdprix.DmdPrix",
                classeFille = "vente.dmdprix.DmdPrixFille",
                titre = "Saisie Demande de Prix",
                redirection = "vente/dmdprix/dmdprix-fiche.jsp";
        String colonneMere = "idMere";
        int taille = 10;

        DmdPrix mere = new DmdPrix();
        mere.setNomTable("DMDPRIX");
        DmdPrixFille fille = new DmdPrixFille();
        fille.setNomTable("DMDPRIXFILLE");
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("client").setPageAppelComplete("client.Client","id","CLIENT", "", "");
        pi.getFormu().getChamp("client").setPageAppelInsert("client/client-saisie.jsp","client;idClientlibelle","id;nom");

        pi.getFormufle().getChamp("produit_0").setLibelle("Article");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("desce_0").setLibelle("D&eacute;scription");
        pi.getFormufle().getChamp("idPersonne_0").setLibelle("Personne");
        pi.getFormufle().getChampMulitple("idPersonne").setVisible(false);
        //for(int i=0; i<taille; i++){
            //pi.getFormufle().getChamp("desce_" + i).setType("editor");
            //pi.getFormufle().getChamp("idPersonne_" + i).setVisible(false);
        //}

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produit"), "produits.Ingredients", "id", "ST_INGREDIENTSAUTOVENTE_M", "", "");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampMulitple("produit").getListeChamp(), "produits/as-ingredients-saisie.jsp","id;val");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idPersonne").getListeChamp(), "vente.personne.Personne", "id", "PERSONNE", "", "");
        //affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampMulitple("idPersonne").getListeChamp(), "annexe/personne/personne-saisie.jsp","id;nom");
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);

        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div style="text-align: center;">
            <h2>Détails demande de prix</h2>
        </div>
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());

        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="classefille" value="DMDPRIXFILLE">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="10">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>