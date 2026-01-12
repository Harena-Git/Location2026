<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.VenteLib" %>
<%@ page import="reservation.Reservation" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.AdminGen"%>
<%@page import="bean.CGenUtil"%>
<%
    try{

        VenteLib t = new VenteLib();
        t.setNomTable("VENTE_CPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "daty","designation","montantttc","remarque","etatLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
          pr.setAWhere(" and IDRESERVATION='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
        /*Reservation resa=new Reservation();
        resa.setId(request.getParameter("id"));
        pr.getTableau().setData(resa.getFactureClient("vente_cpl",null));
        pr.getTableau().transformerDataString();
        int nombreLigne = pr.getTableau().getData().length;*/
%>

<div class="box-body">
    <%
      String libEnteteAffiche[] = {"ID", "Date","D&eacute;signation","Montant","Remarque","&Eacute;tat"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
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
