<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>


<%
    try{
        ReservationDetailsLib t = new ReservationDetailsLib();
        t.setNomTable("RESERVATIONDETAILS_LIB_MARGE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"referenceproduit", "libelleproduit", "qtearticle","qte","daty","heure", "image"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Reference", "Produit", "Nombre","Nb jours","Date de Résérvation","Heure", "Image"};
        //pr.getTableau().setTailleImage("100");
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
