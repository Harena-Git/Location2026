<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DmdAchatFille" %>

<%
    try{
        DmdAchatFille t = new DmdAchatFille();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idproduit","designation","quantite", "pu", "tva"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idmere='"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String[] colonneLien = {"idproduit"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"Id produit","D&eacute;signation","Quantit&eacute;", "Prix unitaire", "TVA"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouv&eacute;e</h4></center><%
    }

%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>