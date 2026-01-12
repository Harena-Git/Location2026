
<%@page import="proforma.*"%>
<%@ page import="affichage.*" %>

<%
  try {
    ProformaAchatDetail  t = new ProformaAchatDetail ();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "designation", "qte","pu"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (request.getParameter("id") != null) {
      pr.setAWhere(" and idmere ='" + request.getParameter("id") + "'");
    }

    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=achat/proforma/proforma-fille-fiche.jsp", pr.getLien() + "?but=devis/devis-fiche.jsp"};
    String colonneLien[] = {"id"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
  <%  String libEnteteAffiche[] = {"Id", "Designation","Quantit&eacute;", "Prix unitaire"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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

