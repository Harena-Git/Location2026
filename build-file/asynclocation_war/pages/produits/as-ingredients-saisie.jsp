<%-- 
    Document   : as-produits-saisie
    Created on : 1 d�c. 2016, 10:39:11
    Author     : Joe
--%>
<%@page import="produits.Ingredients"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%@ page import="utils.ConstanteLocation" %>
<%@ page import="produits.CategorieIngredient" %>
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Ingredients  a = new Ingredients();
    a.setNomTable("V_INGREDIENTS_VIDE");
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    affichage.Champ[] liste = new affichage.Champ[2];
    
    TypeObjet op = new TypeObjet();
    op.setNomTable("as_unite");
    liste[0] = new Liste("unite", op, "VAL", "id");

    if(request.getParameter("id")!=null){
        pi.getFormu().getChamp("idVoiture").setDefaut(request.getParameter("id"));
    }
    
    CategorieIngredient catIngr = new CategorieIngredient();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieIngredient", catIngr, "VAL", "id");
//    liste[1].setDefaut("CAT003");
//   String[] lsnom={"Oui","Non"};
//   String[] lsval={"1","0"};
//   liste[2] = new Liste("compose", lsnom,lsval );
//    String[] aff = {"Simple", "Premium"};
//    String[] val = {"Simple", "Premium"};
//    liste[2] = new Liste("classification", aff, val);

//    TypeObjet mag = new TypeObjet();
//    mag.setNomTable("MAGASIN");
//    liste[3] = new Liste("idmagasin", mag, "VAL", "id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idmagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("idmagasin").setVisible(false);
    pi.getFormu().getChamp("quantite").setVisible(false);
    pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
//    pi.getFormu().getChamp("quantiteparpack").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("durre").setLibelle("Dimension");
    pi.getFormu().getChamp("quantiteparpack").setVisible(false);
    pi.getFormu().getChamp("quantiteparpack").setDefaut("0");
	pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("photo").setVisible(false);
    pi.getFormu().getChamp("classification").setVisible(false);
    pi.getFormu().getChamp("compose").setLibelle("Est compos&eacute;");
    pi.getFormu().getChamp("compose").setVisible(false);
    pi.getFormu().getChamp("categorieIngredient").setLibelle("Cat&eacute;gorie");
//    pi.getFormu().getChamp("categorieIngredient").setVisible(false);
//    pi.getFormu().getChamp("categorieIngredient").setDefaut("CAT003");
    pi.getFormu().getChamp("idfournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("idfournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","FOURNISSEUR");
    pi.getFormu().getChamp("idfournisseur").setVisible(false);
    pi.getFormu().getChamp("tva").setVisible(false);
    pi.getFormu().getChamp("idmodele").setVisible(false);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idmodele").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_M");
        pi.getFormu().getChamp("idmodele").setLibelle("Modele");
    pi.getFormu().getChamp("qtelimite").setLibelle("Quantit&eacute; limite");
    pi.getFormu().getChamp("qtelimite").setVisible(false);
    pi.getFormu().getChamp("pv").setLibelle("Prix de vente");
    pi.getFormu().getChamp("libellevente").setVisible(false);
    pi.getFormu().getChamp("compte_vente").setLibelle("Compte de vente");
    pi.getFormu().getChamp("typeStock").setLibelle("Type de Stock");
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("calorie").setVisible(false);
        pi.getFormu().getChamp("actif").setVisible(false);
        pi.getFormu().getChamp("reste").setVisible(false);
        pi.getFormu().getChamp("image").setVisible(false);
    pi.getFormu().getChamp("seuil").setVisible(false);
    pi.getFormu().getChamp("filepath").setVisible(false);
     pi.getFormu().getChamp("idVoiture").setVisible(false);
        pi.getFormu().getChamp("idVoiture").setLibelle("Voiture");
        pi.getFormu().getChamp("idVoiture").setAutre("readOnly");
        if(request.getParameter("acte")==null){
            pi.getFormu().getChamp("quantiteparpack").setDefaut("1");
            pi.getFormu().getChamp("seuil").setDefaut("100");
            pi.getFormu().getChamp("typeStock").setDefaut("CMUP");
            pi.getFormu().getChamp("typeStock").setVisible(false);
            pi.getFormu().getChamp("compte_vente").setDefaut(ConstanteLocation.comptevente);
            pi.getFormu().getChamp("compte_vente").setVisible(false);
            pi.getFormu().getChamp("compte_achat").setLibelle("Compte d'achat");
            pi.getFormu().getChamp("compte_achat").setDefaut(ConstanteLocation.compteachat);
            pi.getFormu().getChamp("compte_achat").setVisible(false);
            pi.getFormu().getChamp("reference").setDefaut("QU01");
            pi.getFormu().getChamp("reference").setVisible(false);
        }

    String[] ordre = {"daty", "libelle", "unite", "durre"};
    pi.getFormu().setOrdre(ordre);

    pi.preparerDataFormu();
    String titre="Saisie d'un produit";
    if(request.getParameter("acte")!=null){
        titre="Modification d'un Produit";
    }
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp">
    <input name="classe" type="hidden" id="classe" value="produits.Ingredients">
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