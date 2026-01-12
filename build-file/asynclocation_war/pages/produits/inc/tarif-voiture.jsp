<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-21
  Time: 15:54
  To change this template use File | Settings | File Templates.
--%>


<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="annexe.ProduitLib" %>


<%
  try{
    ProduitLib t = new ProduitLib();
    t.setNomTable("PRODUIT_LIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "val", "desce","idCategorieLib","idUniteLib","puVente"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
      pr.setAWhere(" and idVoiture='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] = {"ID", "D&eacute;signation","Description","Cat&eacute;gorie","Unit&eacute;","Prix de vente"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=annexe/produit/produit-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    ProduitLib[] liste=(ProduitLib[]) pr.getTableau().getData();
    System.out.println(liste.length);
    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
    }else
    {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }


%>
</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>