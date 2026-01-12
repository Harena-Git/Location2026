<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.Check" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.CheckInLib" %>


<%
  try{
      CheckInLib t = new CheckInLib();
    t.setNomTable("checkinlibelle");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","refproduit","produitLibelle", "image","qte","daty","heure","etatlib", "responsable", "idtypelivraisonlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setAWhere(" and idReservationMere='"+request.getParameter("id")+"'");
  }
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
//    lienTab.put("Modifier",pr.getLien() + "?but=check/checkin-modif.jsp");

   lienTab.put("Valider", pr.getLien()
    + "?classe=reservation.Check"
    + "&but=apresTarif.jsp"
    + "&bute=reservation/reservation-fiche.jsp?id=" + request.getParameter("id")
    + "&tab=inc/liste-checkin"
    + "&acte=valider");

//    lienTab.put("Annuler",pr.getLien() + "?but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkin&classe=reservation.Check&acte=annuler");
//    lienTab.put("CheckOut",pr.getLien() + "?but=check/checkout-saisie.jsp&idresa=" + request.getParameter("id")+"");
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().setModalOnClick(true);

    //Reservation resa=new Reservation();
    //resa.setId(request.getParameter("id"));
    //pr.getTableau().setData(resa.getListeCheckIn("CHECKINLIBELLE",null));
    //pr.getTableau().transformerDataString();
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID", "R&eacute;ference","Produit", "Image", "Quantit&eacute;","Date de d&eacute;but","Heure","&Eacute;tat" ,"Responsable", "Type"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=check/checkin-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    Check[] liste=(Check[]) pr.getTableau().getData();
    String lien = "";
    if(liste.length>0){
      lien = pr.getLien()+"?but=stock/mvtstock-saisie.jsp?idresCheckin="+liste[0].getIdReservationMere();
    }
    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
    }if(pr.getTableau().getHtml() == null)
  {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
