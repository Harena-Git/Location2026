<%--
  Created by IntelliJ IDEA.
  User: Valiah Karen
  Date: 27/08/2025
  Time: 16:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="caution.CautionDetailsLib" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="caution.ReservationVerificationLib" %>
<%@ page import="caution.ReservationVerifDetailsLib" %><%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-27
  Time: 10:51
  To change this template use File | Settings | File Templates.
--%>
<%
  try{
    ReservationVerificationLib t = new ReservationVerificationLib();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","daty","observation","idclientlib","etat"};
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
    String libEnteteAffiche[] ={"Id","Date","Observation","Client","&Eacute;tat"};
    String lienTableau[] = {pr.getLien() + "?but=caution/reservationverif-fiche.jsp"};
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



