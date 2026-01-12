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
        ReservationVerifDetailsLib t = new ReservationVerifDetailsLib();
        t.setNomTable("RESERVATION_VERIF_DETAILS_LIB");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","idreservationdetails","libelleproduit","jour_retard","etat_materiel","retenue","dateretour","observation","montant","pu"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idreservationverif='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Id","R&eacute;servation D&eacute;tails","Produit","Jour de Retard","&Eacute;tat mat&eacute;riel","Retenue","Date de retour","Observation","Montant","Prix Unitaire"};
        String lienTableau[] = {};
        String colonneLien[] = {};
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


