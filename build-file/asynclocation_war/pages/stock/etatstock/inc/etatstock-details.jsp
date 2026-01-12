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
<%@ page import="stock.EtatStockCategorieFille" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    EtatStockCategorieFille t = new EtatStockCategorieFille();
    t.setNomTable("V_ETATSTOCK_ING");
    String listeCrt[] = {"idMagasin","idTypeProduit","dateDernierMouvement"};
    String listeInt[] = {"dateDernierMouvement"};
    String libEntete[] = {"id","reference","idProduitLib","idTypeProduitLib","idMagasinLib","entree","sortie","reste","idUniteLib","image"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 4, libEntete, libEntete.length);

    pr.setTitre("&Eacute;tat de Stock");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste.jsp");


    // Initialisation Liste
    pr.getFormu().getChamp("dateDernierMouvement1").setDefaut("01/01/2001");
    String awhere = "";
    if (request.getParameter("id")!=null){
        awhere += " AND idTypeProduit='"+request.getParameter("id")+"'";
    }
    if (request.getParameter("idMag")!=null){
        pr.getFormu().getChamp("idMagasin").setDefaut(request.getParameter("idMag"));
    }
    pr.setAWhere(awhere);
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

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getTableau().getData();
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
