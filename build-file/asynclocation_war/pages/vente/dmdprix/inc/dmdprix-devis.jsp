<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.devis.DevisDmdPrix" %>

<%
    try{
        DevisDmdPrix t = new DevisDmdPrix();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","daty","produitLib","idPersonneLib","etatLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idMere='"+request.getParameter("id")+"'");
        }

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=vente/devis/devis-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        pr.getTableau().setLienFille("vente/devis/devisfille-liste.jsp&id=");
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Id", "Date", "Produit","Personne","Etat"};
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
