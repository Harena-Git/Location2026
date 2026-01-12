<%@ page import="caution.CautionDetailsLib" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="caution.CautionLib" %><%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-27
  Time: 10:51
  To change this template use File | Settings | File Templates.
--%>
<%
  try{
    CautionLib t = new CautionLib();
    String listeCrt[] = {};
    String listeInt[] = {};
//    String libEntete[] = {"id","pct_applique", "referencepaiement","daty","montantgrp"};
    String libEntete[] = {"id","pct_applique","daty","montantgrp","debit","credit"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
     pr.setAWhere(" and idreservation='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
  <%
//    String libEnteteAffiche[] =  {"id","Taux Appliqu&eacute;","R&eacute;f&eacute;rence Paiement","Date retour", "Montant"};
    String libEnteteAffiche[] =  {"id","Taux Appliqu&eacute;","Date retour", "Montant","Montant Retour","Montant Retenue"};
    String lienTableau[] = {pr.getLien() + "?but=caution/caution-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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


