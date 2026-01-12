<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-22
  Time: 14:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.VenteLib" %>


<%
    try{
        VenteLib t = new VenteLib();
        t.setNomTable("VENTE_CPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "designation","idClientLib","idDevise","daty","montantRevient","montantpaye", "montantreste","etatlib"};
        String libEnteteAffiche[] = {"id", "D&eacute;signation","Client","devise","Date","montant Revient","Montant Pay&eacute;","Montant Restant","Etat"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idClient='"+request.getParameter("id")+"' ORDER BY DATY DESC");
        }

        String[] colSomme = {"montantpaye", "montantreste"};
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        VenteLib[] liste=(VenteLib[]) pr.getTableau().getData();
        if(liste != null && liste.length > 0){
            String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
            pr.getTableau().setLien(lienTableau);
            String colonneLien[] = {"id"};
            pr.getTableau().setColonneLien(colonneLien);

            Map<String,String> lienTab=new HashMap();
            lienTab.put("modifier",pr.getLien() + "?but=vente/vente-modif.jsp");
            lienTab.put("Valider",pr.getLien() + "?&classe=vente.Vente&but=apresTarif.jsp&bute=vente/vente-fiche.jsp&acte=valider");
            lienTab.put("Voir fiche",pr.getLien() + "?but=vente/vente-fiche.jsp");
            pr.getTableau().setLienClicDroite(lienTab);
            pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
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

