<%@ page import="caution.CautionLib" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="utilisateurstation.UtilisateurStation" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-26
  Time: 23:58
  To change this template use File | Settings | File Templates.
--%>
<% try{
    CautionLib bc = new CautionLib();
    String listeCrt[] = {"id","modepaiement","referencepaiement", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idreservation","modepaiement","pct_applique", "referencepaiement","daty","dateprevuerestitution","montantgrp"};
    String libEnteteAffiche[] = {"id","Reservation","Mode de paiement","Taux Appliqu&eacute;","Reference Paiement","Date", "Date pr&eacute;vue restitution", "Montant"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des cautions");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caution/caution-liste.jsp");
    String[] colSomme = { "montantgrp" };
    Champ[] liste = new Champ[1];
    Liste listeEtat = new Liste("etat");
    String[] aff = {"TOUS","CR&Eacute;E", "VIS&Eacute;E", "ANNUL&Eacute;E"};
    String[] val = {"%", "1", "11", "0"};
    listeEtat.ajouterValeur(val, aff);
    liste[0] = listeEtat;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("referencepaiement").setLibelle("Reference Paiement");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(UtilisateurStation.getDateDebutSemaine());
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(UtilisateurStation.getDateFinSemaine());
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caution/caution-saisie-multiple.jsp");
    lienTab.put("Valider",pr.getLien() + "?classe=caution.Caution&but=apresTarif.jsp&bute=caution/caution-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Voir fiche",pr.getLien() + "?but=caution/caution-fiche.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caution/caution-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("caution/inc/caution-details.jsp&id=");
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
