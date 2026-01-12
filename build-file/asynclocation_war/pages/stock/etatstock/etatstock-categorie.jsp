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
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stock.EtatStockModele" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="stock.EtatStockCategorie" %>

<% try{
    EtatStockCategorie t = new EtatStockCategorie();
    t.setNomTable("V_ETATSTOCK_CATEG");
    String listeCrt[] = {"id","idMagasin","idTypeProduit"};
    String listeInt[] = {};
    String libEntete[] = {"id","idTypeProduitLib","idMagasin","idMagasinLib","entree","sortie","reste"};
    String libEnteteAffiche[] = {"id","Cat&eacute;gorie","ID Magasin","Magasin","entr&eacute;e","sortie","reste"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    // pr.setAWhere("AND IDPOINT='"+ConstanteStation.getFichierCentre()+"'");
    pr.setTitre("&Eacute;tat de stock par cat&eacute;gorie");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-categorie.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[2];
    Magasin m = new Magasin();
    m.setNomTable("magasin");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    TypeObjet catIngr = new TypeObjet();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    dropDowns[1] = new Liste("idTypeProduit", catIngr, "VAL", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("idTypeProduit").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String daty1 = request.getParameter("daty1");
    String daty2 = request.getParameter("daty2");
    String idMagasin = request.getParameter("idMagasin");
    //Definition des lienTableau et des colonnes de lien
    String lienFille = "stock/etatstock/inc/etatstock-details.jsp";
    lienFille += "&id=";
    pr.getTableau().setLienFille(lienFille);

    //Definition des libelles à afficher
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
<script>
    function rajoutLien(){
        let lignes = Array.from(document.getElementsByTagName("tr"));
        for (let tr of lignes) {
            if (tr.getAttribute("style") === "height:45px;") {
                const tds = tr.querySelectorAll("td");
                const btnPlus = tds[0].querySelector("button");
                if (btnPlus != null) {
                    const magasin = tds[2];
                    let lienFille = btnPlus.getAttribute("id").split("&");
                    btnPlus.setAttribute("id", lienFille[0] + "&idMag=" + magasin.textContent.trim() + "&" + lienFille[1]);
                }
            }
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        rajoutLien();
    });
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



