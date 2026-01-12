
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utilisateurstation.UtilisateurStation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>

<% try{
  ReservationLib bc = new ReservationLib();
  bc.setNomTable("reservation_etatlogistiquelib");
  String listeCrt[] = {};
  String listeInt[] = {};
  String libEntete[] = {"id", "idclientlib","daty","remarque","etatlogistiquelib"};
  String libEnteteAffiche[] = {"id","Client","Date de r&eacute;servation","remarque","&Eacute;tat Logistique"};
  PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("reservation/reservation-liste.jsp");
  String[] colSomme = { "montant" };

  String daty = request.getParameter("daty");

  String awhere = "";
  String titre = "Liste des r&eacute;servations";
  if (daty!=null){
    awhere = " and DATY = TO_DATE('"+daty+"','DD/MM/YYYY')";
    titre+= "du "+daty;
  }

  pr.setAWhere(awhere);
  pr.setTitre(titre);
//  pr.creerObjetPage(libEntete, colSomme);
  pr.creerObjetPage(libEntete);

  Map<String,String> lienTab=new HashMap();
  lienTab.put("modifier",pr.getLien() + "?but=reservation/reservation-modif.jsp");
  lienTab.put("Voir fiche",pr.getLien() + "?but=reservation/reservation-fiche.jsp");
  pr.getTableau().setLienClicDroite(lienTab);

  //Definition des lienTableau et des colonnes de lien
  String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
  String colonneLien[] = {"id"};
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  pr.getTableau().setLibelleAffiche(libEnteteAffiche);
  pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");
  //pr.getTableau().setModalOnClick(true);
%>
<div class="content-wrapper">
  <section class="content-header">
    <h1><%= pr.getTitre() %></h1>
  </section>
  <section class="content">
<%--    <%--%>
<%--      out.println(pr.getTableauRecap().getHtml());%>--%>
<%--    <br>--%>
    <%
      out.println(pr.getTableau().getHtml());
      out.println(pr.getBasPage());
    %>
  </section>
</div>
<%
  }catch(Exception e){

    e.printStackTrace();
  }
%>
