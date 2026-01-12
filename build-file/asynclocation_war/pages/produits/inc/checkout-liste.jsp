<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="reservation.CheckOutLib" %>

<% try{
    CheckOutLib t = new CheckOutLib();
    t.setNomTable("CHECKOUTLIB_CLIENT");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","refproduit","produitlibelle", "image", "client", "daty","etat_materiel_lib", "responsable"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and IDPRODUIT='"+request.getParameter("id")+"' ORDER BY DATY DESC");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteAffiche = {"id","R&eacute;f&eacute;rence produit", "Article", "Image", "Client", "Date","&Eacute;tat mat&eacute;riel", "Responsable"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<div>
        <% if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else
        {
    %><center><h4>Aucune donne trouvee</h4></center><%
    } %>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



