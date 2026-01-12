<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utilisateurstation.UtilisateurStation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="user.UserEJB" %>

<% try{
    UserEJB userEJB  = (user.UserEJB) session.getValue("u");
    ReservationLib bc = new ReservationLib();
    bc.setNomTable("RESERVATION_ETATLIB_F");
    String listeCrt[] = {"id", "idclientlib","daty","etatpayment", "etatlogistique"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idclientlib","daty", "remarque","etatpaymentlib", "etatlogistiquelib"};
    String libEnteteAffiche[] = {"id","Client","Date de r&eacute;servation","remarque","&Eacute;tat Payment", "Etat Logistique"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des r&eacute;servations ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/reservation-liste.jsp");
    String[] colSomme = { "montant" };
    Champ[] liste = new Champ[2];
    Liste listeEtat = new Liste("etatpayment");
    listeEtat.setLibelle("&Eacute;tat");
    String[] aff = {"TOUS","Accompte", "Pay&eacute; Totalit&eacute;"};
    String[] val = {"%", "17", "16"};
    listeEtat.ajouterValeur(val, aff);

    Liste listeEtatl = new Liste("etatlogistique");
    listeEtatl.setLibelle("&Eacute;tat logistique");
    listeEtat.setLibelle("&Eacute;tat payment");
    String[] affl = {"Tous","A Preparer", "Exp&eacute;di&eacute;(e)", "Boucl&eacute;(e)"};
    String[] vall = {"%", "12", "13", "14"};
    listeEtatl.ajouterValeur(vall, affl);
    liste[0] = listeEtat;
    liste[1] = listeEtatl;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("etatpayment").setLibelle("&Eacute;tat payment");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(UtilisateurStation.getDateDebutSemaine());
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(UtilisateurStation.getDateFinSemaine());
    pr.creerObjetPage(libEntete);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=reservation/reservation-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?classe=reservation.Reservation&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
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
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="reservation" id="reservation">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
