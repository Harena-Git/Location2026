<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.BonDeCommandeCpl" %>

<%
    try{
        BonDeCommandeCpl t = new BonDeCommandeCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","daty","remarque","designation","modepaiementlib","idClientLib","reference","etatLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idDmdPrix='"+request.getParameter("id")+"'");
        }

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String [] colonneLien = {"id"};
        String[] attributLien = {"id"};
        String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);

%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Id", "Date","Remarque","D&eacute;signation","Mode de Paiement", "Client", "Reference", "Etat"};
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
