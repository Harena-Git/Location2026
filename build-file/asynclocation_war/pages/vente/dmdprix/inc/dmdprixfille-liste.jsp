<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.dmdprix.DmdPrixFilleLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
  try{
    DmdPrixFilleLib t = new DmdPrixFilleLib();
    t.setNomTable("DMDPRIXFILLELIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","produitLib","desce","remarque", "image"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
      pr.setAWhere(" and idMere='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienVisa=pr.getLien() + "?but=apresTarif.jsp&bute=vente/dmdprix-fiche.jsp&acte=valider";
    String lienDevis = pr.getLien() + "?but=vente/devis/devis-saisie.jsp";
    Map<String,String> lienTab=new HashMap();
//    lienTab.put("valider",lienVisa);
    lienTab.put("Devis", lienDevis);
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=vente/dmdprix/dmdprixfille-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"Id", "Produit","D&eacute;scription","Remarque", "Image"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setTailleImage("100");
    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
    }else
    {
  %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
  }
%>
</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
