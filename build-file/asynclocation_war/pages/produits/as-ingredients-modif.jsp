<%-- 
    Document   : as-commande-modif.jsp
    Created on : 29 d�c. 2016, 19:50:47
    Author     : Joe
--%>
<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@page import="produits.Ingredients"%>
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Ingredients  a = new Ingredients();
    PageUpdate pi = new PageUpdate(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    UserEJB u = (UserEJB) session.getAttribute("u");

    affichage.Champ[] liste = new affichage.Champ[2];

    TypeObjet op = new TypeObjet();
    op.setNomTable("as_unite");
    liste[0] = new Liste("unite", op, "VAL", "id");
    TypeObjet op1 = new TypeObjet();
    op1.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieIngredient", op1, "val", "id");
//    String[] aff = {"Simple", "Premium"};
//    String[] val = {"Simple", "Premium"};
//    liste[2] = new Liste("classification", aff, val);
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
//        pi.getFormu().getChamp("pu").setVisible(false);
        pi.getFormu().getChamp("photo").setVisible(false);
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("quantiteParPack").setLibelle("Quantit&eacute;");
        pi.getFormu().getChamp("compose").setVisible(false);
        pi.getFormu().getChamp("categorieIngredient").setLibelle("Cat&eacute;gorie");
        pi.getFormu().getChamp("idfournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("durre").setLibelle("Dimension");
        pi.getFormu().getChamp("idfournisseur").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("qteLimite").setVisible(false);
        pi.getFormu().getChamp("libelleVente").setVisible(false);
        pi.getFormu().getChamp("compte_vente").setLibelle("Compte de vente");
        pi.getFormu().getChamp("compte_achat").setLibelle("Compte d'achat");
        pi.getFormu().getChamp("compte_vente").setVisible(false);
        pi.getFormu().getChamp("compte_achat").setVisible(false);
        pi.getFormu().getChamp("seuil").setVisible(false);
        pi.getFormu().getChamp("id").setVisible(false);
        pi.getFormu().getChamp("calorie").setVisible(false);
        pi.getFormu().getChamp("pv").setLibelle("Prix de vente");
        //pi.getFormu().getChamp("reference").setVisible(false);
        pi.getFormu().getChamp("filepath").setVisible(false);
        pi.getFormu().getChamp("idVoiture").setVisible(false);
        pi.getFormu().getChamp("idmodele").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_M");
        pi.getFormu().getChamp("idmodele").setLibelle("Modele");
        pi.getFormu().getChamp("reste").setVisible(false);
        pi.getFormu().getChamp("image").setVisible(false);
        pi.getFormu().getChamp("typeStock").setVisible(false);
        pi.getFormu().getChamp("actif").setVisible(false);
        pi.getFormu().getChamp("idmodele").setVisible(false);
        pi.getFormu().getChamp("classification").setVisible(false);

        pi.preparerDataFormu();
    
%>
<div class="content-wrapper">
    <h1 class="box-title">Modification Produit</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="acte" value="update">
        <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="produits.Ingredients">
    </form>
</div>

<%} catch(Exception ex){
    ex.printStackTrace();
}%>