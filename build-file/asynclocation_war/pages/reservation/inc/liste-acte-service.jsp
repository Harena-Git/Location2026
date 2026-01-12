<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.ActeLib" %>
<%@ page import="produits.Acte" %>
<%@ page import="reservation.Reservation" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.AdminGen"%>
<%@page import="bean.CGenUtil"%>
<%
    try{
        ActeLib t = new ActeLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "libelle","daty","qte","pu","montant","charge","marge"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
             pr.setAWhere(" and idreservation='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        Reservation resa=new Reservation();
        resa.setId(request.getParameter("id"));
        Acte[] listeA=resa.getActeAvecSimulation("ACTE_LIB",null);
        pr.getTableau().setData(listeA);
        pr.getTableau().transformerDataString();
        int nombreLigne = pr.getTableau().getData().length;

%>
<div class="box-body">
    <%
    String libEnteteAffiche[] = {"id", "d&eacute;signation","date","quantit&eacute;","prix unitaire","montant","charge","marge"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
    <table style="width: 20%"class="table">
    <tr>
    <td><b>Montant HT:</b></td>
    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeA,"montantCalc")) %></b></td>
</tr>
    </table>
</div>
    <%}if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donnee trouvee</h4></center><%
    }
  
  %>
  </div>
  <%
    } catch (Exception e) {
      e.printStackTrace();
    }%>