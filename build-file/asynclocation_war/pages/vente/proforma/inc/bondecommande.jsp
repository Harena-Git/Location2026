
<%@page import="proforma.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="vente.BonDeCommandeCpl"%>
<%@ page import="reservation.ReservationLib" %>

<%
  try {
    ReservationLib t = new ReservationLib();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idclientlib","daty","remarque","etatlib", "montantttc", "revient", "marge"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (request.getParameter("id") != null) {
      pr.setAWhere(" and idorigine='" + request.getParameter("id") + "'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");

%>

<div class="box-body">
  <%  String libEnteteAffiche[] = {"id","Client","Date de r&eacute;servation","remarque","&Eacute;tat","Montant TTC", "Prix de revient", "Marge"};
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

