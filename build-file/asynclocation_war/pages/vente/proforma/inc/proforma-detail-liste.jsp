<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:10
  To change this template use File | Settings | File Templates.
--%>

<%@page import="proforma.*"%>
<%@ page import="affichage.*" %>


<%
  try {
    ProformaDetailsLib t = new ProformaDetailsLib();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idProduitlib","designation", "image", "nombre", "qte","datedebut", "pu","remisemontant","montanttotal"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (request.getParameter("id") != null) {
      pr.setAWhere(" and idProforma='" + request.getParameter("id") + "'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-detail-fiche.jsp", pr.getLien() + "?but=devis/devis-fiche.jsp"};
    String colonneLien[] = {"id"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setColonneLien(colonneLien);

%>

<div class="box-body">
  <%  String libEnteteAffiche[] = {"id", "Produit","D&eacute;signation", "Image", "Quantit&eacute; (Article)", "Quantit&eacute; (En Jour)","Date de d&eacute;but","Prix unitaire","Montant de la remise","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    //pr.getTableau().setTailleImage("100");
    pr.getTableau().getData();
    if (pr.getTableau().getHtml() != null) {
      out.println(pr.getTableau().getHtml());
    } else {
  %><center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center><%
  }


%>
</div>
<%    } catch (Exception e) {
  e.printStackTrace();
}%>

