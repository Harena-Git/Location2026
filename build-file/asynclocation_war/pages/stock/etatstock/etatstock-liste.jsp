<%-- 
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page import="produits.CategorieIngredient"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="stock.PageRechercheEtatStock"%>
<%@page import="stock.EtatStock"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    EtatStock t = new EtatStock();
    t.setNomTable("V_ETATSTOCK_ING");
    String listeCrt[] = {"id","idProduitLib","idMagasin","idTypeProduit","dateDernierMouvement","reference","unite"};
    String listeInt[] = {"dateDernierMouvement"};
    String libEntete[] = {"id","reference","idProduitLib","idTypeProduitLib","idMagasinLib","entree","sortie","reste","idUniteLib","image"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 4, libEntete, libEntete.length);

    pr.setTitre("&Eacute;tat de Stock");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[3];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    TypeObjet unite = new TypeObjet();
    unite.setNomTable("AS_UNITE");
    dropDowns[1] = new Liste("unite", unite, "val", "id");

    TypeObjet catIngr = new TypeObjet();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    dropDowns[2] = new Liste("idTypeProduit", catIngr, "VAL", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("dateDernierMouvement1").setDefaut("01/01/2001");
    pr.getFormu().getChamp("dateDernierMouvement1").setVisible(false);
    pr.getFormu().getChamp("dateDernierMouvement1").setLibelle("-");
    pr.getFormu().getChamp("dateDernierMouvement2").setLibelle("Date");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("dateDernierMouvement2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idTypeProduit").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");

    //pr.getFormu().getChamp("idUnite").setLibelle("Unite");
    //pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    //pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"id","R&eacute;f&eacute;rence","Produit","Cat&eacute;gorie","Magasin","Entr&eacute;e","Sortie","Reste","Unit&eacute;","image"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



