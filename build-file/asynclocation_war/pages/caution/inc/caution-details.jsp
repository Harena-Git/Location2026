<%@ page import="caution.CautionDetailsLib" %>
<%@ page import="affichage.PageRecherche" %><%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-27
  Time: 10:51
  To change this template use File | Settings | File Templates.
--%>
<%
    try{
        CautionDetailsLib t = new CautionDetailsLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","idreservationdetails","produit","montantreservation","pct_applique","montant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idcaution='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Id","ID R&eacute;servation D&eacute;tails","Produit","Montant de r&eacute;servation","Taux Appliqu&eacute;","Caution"};
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


