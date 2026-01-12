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
        t.setNomTable("HISTORIQUERESERVATIONVOITURE_1");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "daty","idclientlib", "montantTva","montantTTC","paye","resteAPayer"};
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
        String libEnteteAffiche[] = {"id","Date", "Client", "montant Tva","montant TTC","payer","reste &agrave; Payer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        ReservationLib[] liste=(ReservationLib[]) pr.getTableau().getData();
        System.out.println(liste.length);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>

%>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant Reste:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"resteAPayer")) %></b></td>
            </tr>
            <tr>
                <td><b>Montant TVA:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTva")) %></b></td>
            </tr>
            <tr>
                <td><b>Montant TTC:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %></b></td>
            </tr>
        </table>
    </div>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>