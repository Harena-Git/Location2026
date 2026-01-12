<%-- 
    Document   : as-produits-saisie
    Created on : 1 d�c. 2016, 10:39:11
    Author     : Joe
--%>
<%@page import="produits.Ingredients"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Ingredients  a = new Ingredients();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    affichage.Champ[] liste = new affichage.Champ[3];
    
    TypeObjet op = new TypeObjet();
    op.setNomTable("as_unite");
    liste[0] = new Liste("unite", op, "VAL", "id");
    
    TypeObjet catIngr = new TypeObjet();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieingredient", catIngr, "VAL", "id");
    String[] lsnom={"Oui","Non"};
     String[] lsval={"1","0"};
   liste[2] = new Liste("compose", lsnom,lsval );
    
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("quantiteparpack").setLibelle("Quantit&eacute; par pack");
	pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("quantiteparpack").setDefaut("1");
	pi.getFormu().getChamp("seuil").setDefaut("100");
    pi.getFormu().getChamp("photo").setVisible(false);
    pi.getFormu().getChamp("compose").setLibelle("Est compos&eacute;");
    pi.getFormu().getChamp("categorieingredient").setLibelle("Cat&eacute;gorie d'ingr&eacute;dient");
    pi.getFormu().getChamp("idfournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("qtelimite").setLibelle("Quantit&eacute; limite");
    pi.getFormu().getChamp("pv").setLibelle("Prix de vente");
    pi.getFormu().getChamp("libellevente").setVisible(false);
    pi.getFormu().getChamp("compte_vente").setLibelle("Compte de vente");
    pi.getFormu().getChamp("compte_achat").setLibelle("Compte d'achat");
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Enregistrer ingredient</h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-saisie.jsp">
    <input name="classe" type="hidden" id="classe" value="produits.Ingredients">
    </form>
</div>