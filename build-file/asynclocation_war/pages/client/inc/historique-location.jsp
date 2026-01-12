<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-22
  Time: 14:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>


<%
    try{
        ReservationLib t = new ReservationLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idclientlib","daty","remarque","etatlib", "montant"};
        String libEnteteAffiche[] = {"id","Client","Date de r&eacute;servation","remarque","Etat","Montant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idClient='"+request.getParameter("id")+"' and daty<'"+Utilitaire.formatterDaty(Utilitaire.dateDuJourSql())+"'");
        }

        String[] colSomme = {"montant"};
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        ReservationLib[] liste=(ReservationLib[]) pr.getTableau().getData();
        if(liste != null && liste.length > 0){
            Map<String,String> lienTab=new HashMap<>();
            lienTab.put("modifier",pr.getLien() + "?but=reservation/reservation-modif.jsp");
            lienTab.put("Valider",pr.getLien() + "?classe=reservation.Reservation&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&acte=valider");
            lienTab.put("Voir fiche",pr.getLien() + "?but=reservation/reservation-fiche.jsp");
            pr.getTableau().setLienClicDroite(lienTab);

            pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");

            String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setLien(lienTableau);

            out.println(pr.getTableauRecap().getHtml());
            %>
                <br/>
            <%
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
