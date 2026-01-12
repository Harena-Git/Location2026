<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="stock.TypeMvtStock"%>
<%@page import="stock.MvtStockFille"%>
<%@page import="stock.MvtStock"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@page import="magasin.Magasin"%>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        String classeMere = "stock.MvtStock",
               classeFille = "stock.MvtStockFille",
               titre = "Modification mouvement de stock",
			   redirection = "stock/mvtstock-fiche.jsp";
        String colonneMere = "idMvtStock";

        MvtStock mere = new MvtStock();
        mere.setNomTable("MVTSTOCK");
        MvtStockFille fille = new MvtStockFille();
        fille.setNomTable("MVTSTOCKFILLE");

        fille.setIdMvtStock(request.getParameter("id"));

        MvtStockFille[] details = (MvtStockFille[]) CGenUtil.rechercher(fille, null, null, "");

        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request,u, details.length);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[1];
        TypeMvtStock typemvt = new TypeMvtStock();
        liste[0] = new Liste("idTypeMvStock",typemvt,"val","id");

        pi.getFormu().changerEnChamp(liste);
        Magasin cat= new Magasin();
		liste[0] = new Liste("idMagasin", cat, "val", "id");
		pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idVente").setVisible(false);
        pi.getFormu().getChamp("idTransfert").setVisible(false);
        pi.getFormu().getChamp("idTypeMvStock").setLibelle("Type de mouvement de stock");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idPoint").setVisible(false);
        pi.getFormu().getChamp("idobjet").setVisible(false);

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","","");


        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idMvtStock"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idTransfertDetail"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idVenteDetail"),false);

        pi.getFormufle().getChamp("Entree_0").setLibelle("Entr&eacute;e");
        pi.getFormufle().getChamp("Sortie_0").setLibelle("Sortie");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("reste_0").setLibelle("Reste");
        pi.getFormufle().getChamp("mvtSrc_0").setLibelle("Mouvement source");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMvtStock"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idTransfertDetail"),false);

        pi.getFormu().setOrdre(new String[]{"daty"});
        pi.preparerDataFormu();

%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();

            out.println(pi.getFormu().getHtmlInsert());

        %>
        <div style="text-align: center;">
            <h2>Modification du mouvement de stock</h2>
        </div>
        <%

            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormufle().getHtmlTableauInsert());

        %>
        <input name="acte" type="hidden" id="nature" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=details.length%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="nomtable" type="hidden" id="classefille" value="mvtstockfille">
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
