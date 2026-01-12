<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="reservation.*" %>
<%
  try {
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    CheckInLib fille = new CheckInLib();
    fille.setNomTable("CHECKINFORMU_BL");

    ReservationDetailsCheck[] res = null;
    String idreservation = request.getParameter("idresa");
    boolean erreur = false;
    if(idreservation!=null){
        mere.setId(idreservation);
        ReservationLib t = new ReservationLib();
        t.setNomTable("RESERVATION_LIB_MIN_DATYF");
        ReservationLib [] liste = (ReservationLib []) CGenUtil.rechercher(t,null,null,null," AND ID='"+idreservation+"'");
        System.err.println("====================>"+liste.length);
        if(liste.length>0){
            if(liste[0].getResteAPayer()>0){
                erreur = true;
            }
        }
        res = mere.getListeSansCheckIn("RESTSANSCIGROUPLIB_SANS",null);
    }
    int nombreLigne = res.length;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    String butApresPost = "reservation/reservation-fiche.jsp&tab=inc/liste-checkin";



    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("idclient").setVisible(false);
    pi.getFormufle().getChamp("idproduit_0").setLibelle("Produits");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pv;image","pu;image");
    affichage.Liste[] liste = new Liste[1];
    Magasin cat= new Magasin();
    liste[0] = new Liste("idmagasin", cat, "val", "id");
    //TypeObjet type= new TypeObjet();
    //type.setNomTable("typelivraison");
    //liste[1] = new Liste("idtypelivraison", type, "val", "id");
    pi.getFormufle().changerEnChamp(liste);
    pi.getFormufle().getChamp("daty_0").setLibelle("Date de Livraison/R&eacute;cup&eacute;ration");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure de Livraison/R&eacute;cup&eacute;ration");
    pi.getFormufle().getChamp("idclientlib_0").setLibelle("Client");
    pi.getFormufle().getChamp("kilometrage_0").setLibelle("Kilometrage");
    pi.getFormufle().getChampMulitple("kilometrage").setVisible(false);
    pi.getFormufle().getChampMulitple("idclient").setVisible(false);
    pi.getFormufle().getChampMulitple("remarque").setVisible(false);
    pi.getFormufle().getChampMulitple("idtypelivraison").setVisible(false);
    pi.getFormufle().getChampMulitple("numBl").setVisible(false);
    pi.getFormufle().getChamp("reservation_0").setLibelle("R&eacute;servation detail");
    pi.getFormufle().getChamp("refproduit_0").setLibelle("R&eacutef&eacute;rence produit");
    pi.getFormufle().getChamp("idtypelivraison_0").setLibelle("Type");
    pi.getFormufle().getChamp("responsable_0").setLibelle("Responsable");
    pi.getFormufle().getChamp("image_0").setLibelle("Image");

    pi.getFormufle().getChamp("idmagasin_0").setLibelle("Lieu de stockage");
    pi.getFormufle().getChamp("qteUtil_0").setLibelle("Quantit&eacute; besoin");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");

//    affichage.Champ.setVisible(pi.getFormufle().getChampFille("qte"), false);
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("qte"), "1");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idClient"),"client.Client","id","Client");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("reservation"),false);
    int maxSeqBL = Utilitaire.getMaxSeq("GETSEQBONDELIVRAISON");
    for(int i = 0; i < nombreLigne; i++){
        pi.getFormufle().getChamp("refproduit_"+i).setAutre("readOnly");
        pi.getFormufle().getChamp("reservation_"+i).setAutre("readOnly");
        pi.getFormufle().getChamp("idclientlib_"+i).setAutre("readOnly");
//      pi.getFormufle().getChamp("daty_"+i).setAutre("readOnly");
//      pi.getFormufle().getChamp("heure_"+i).setAutre("readOnly");
//        pi.getFormufle().getChamp("qte_"+i).setAutre("readOnly");
        pi.getFormufle().getChamp("heure_"+i).setDefaut(utilitaire.Utilitaire.heureCouranteHM());
        pi.getFormufle().getChamp("numBl_"+i).setDefaut("BL"+maxSeqBL);
    }

      if(idreservation!=null&&res.length>0){
          SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
          butApresPost = "reservation/reservation-fiche.jsp&id="+idreservation+"&tab=inc/liste-checkin";
          for (int i = 0; i < res.length; i++){
              pi.getFormufle().getChamp("idproduit_"+i).setDefaut(res[i].getIdproduit());
              pi.getFormufle().getChamp("refproduit_"+i).setDefaut(res[i].getReferenceproduit());
              pi.getFormufle().getChamp("idClient_"+i).setDefaut(res[i].getIdclient());
              pi.getFormufle().getChamp("idclientlib_"+i).setDefaut(res[i].getIdclientlib());
              pi.getFormufle().getChamp("reservation_"+i).setDefaut(res[i].getId());
              pi.getFormufle().getChamp("qte_"+i).setDefaut(String.valueOf(res[i].getQtearticle()));
              pi.getFormufle().getChamp("daty_"+i).setDefaut(sdf.format(res[i].getDaty()));
              pi.getFormufle().getChamp("responsable_"+i).setDefaut(mere.getResponsable());
              pi.getFormufle().getChamp("responsable_"+i).setVisible(false);
              pi.getFormufle().getChamp("image_"+i).setDefaut(res[i].getImage());
              pi.getFormufle().getChamp("idtypelivraison_"+i).setDefaut(res[i].getType());
              pi.getFormufle().getChamp("qteUtil_"+i).setDefaut(res[i].getQteUtil()+"");
              pi.getFormufle().getChamp("qteUtil_"+i).setAutre("readonly");
              pi.getFormufle().getChamp("idmagasin_"+i).setDefaut(res[i].getMagasin());
              pi.getFormufle().getChamp("idmagasin_"+i).setAutre("onmousedown=\"return false;\"");
          }
    }
    
    pi.preparerDataFormu();
    String[] order = {"refproduit", "idproduit","image", "idclient","kilometrage","responsable", "daty","heure","idclientlib","qteUtil","qte","idmagasin","idtypelivraison","reservation"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.Check";
    String colonneMere = "reservation";
    //Preparer les affichages
    pi.getFormufle().makeHtmlInsertTableauIndex();
    pi.getFormufle().getBoutonsValiderAnnulerTabIndex();

%>
<div class="content-wrapper">
  <h1>Enregistrement de Livraison/R&eacute;cup&eacute;ration</h1>
  <% if(erreur){ %>
        <h2 style="color:red">La totalit&eacute; de la r&eacute;servation n'est pas encore pay&eacute;e.</h2>
    <% } %>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=check/apresMultipleCheckin.jsp" method="post" >
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
      <input name="idMere" type="hidden" id="idMere" value="<%= idreservation %>">
      <input name="nomtable" type="hidden" id="nomtable" value="CHECKIN">
    </form>
  </div>
</div>

<script>
    $(document).ready(function() {
        if(<%=erreur%>){
            alert("La totalite de la reservation n'est pas encore payee.");
        }
    });
    const valeurs = [
    <% if (res != null) {
      for (int i = 0; i < res.length; i++) { %>
    {
      Produit: "<%= res[i].getProduitlib() %>"
    } <%= (i < res.length - 1) ? "," : "" %>
      <% }
    } %>
    ];
    window.addEventListener('DOMContentLoaded', function() {
      for (let i = 0; i < valeurs.length; i++) {
        const produitInput = document.getElementById('idProduit_' + i +'libelle');
        if (produitInput) produitInput.value = valeurs[i].Produit;
      }
    }
  );

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('button[name="Submit2"]').innerText = 'Enregistrer et Valider';
    });
</script>

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>
