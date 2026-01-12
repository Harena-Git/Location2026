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
<%@ page import="reservation.ReservationLib" %>


<%
    try{
        ReservationLib t = new ReservationLib();
        t.setNomTable("RESERVATIONLIB_SANSCHECKIN");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idclientlib", "montantTva","montantTTC","paye","resteAPayer"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idVoiture='"+request.getParameter("id")+"' and etat = 11 ");
        }
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"id", "Client", "montant Tva","montant TTC","payer","reste &agrave; Payer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        ReservationLib[] liste=(ReservationLib[]) pr.getTableau().getData();
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