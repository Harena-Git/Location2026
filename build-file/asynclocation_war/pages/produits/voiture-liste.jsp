<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-21
  Time: 15:46
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="produits.Voiture" %>

<% try{
  Voiture t = new Voiture();
  t.setNomTable("VOITURELIBELLEMONTANT1");
  String listeCrt[] = {"nom", "numero","categorieLibelle"};
  String listeInt[] = {};
  String libEntete[] = {"id","nom", "numero","charge_per_kilometre","valeur_actuelle","montantResa","charge","marge","categorieLibelle","estFonctionnel", "priorite"};
  PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setTitre("Liste voiture");
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("produits/voiture-liste.jsp");
  pr.getFormu().getChamp("categorieLibelle").setLibelle("categorie");
  String[] colSomme = {"valeur_actuelle","charge","marge"};
  pr.creerObjetPage(libEntete, colSomme);
  //Definition des lienTableau et des colonnes de lien
  String lienTableau[] = {pr.getLien() + "?but=produits/voiture-fiche.jsp"};
  String colonneLien[] = {"id"};
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  //Definition des libelles à afficher
  String libEnteteAffiche[] = {"id","Nom", "Num&eacute;ro"," Charges par kilom&egrave;tre","Valeur Actuelle"," Montant Reservation","charge","marge","categorie","etat" ,"priorite"};
  pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
  <section class="content-header">
    <h1><%= pr.getTitre() %></h1>
  </section>
  <section class="content">
    <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
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
<%
  }catch(Exception e){

    e.printStackTrace();
  }
%>




