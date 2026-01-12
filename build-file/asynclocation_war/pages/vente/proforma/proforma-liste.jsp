<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="proforma.*" %>
<%@ page import="affichage.PageRecherche" %>
<%@page import="affichage.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%  try{

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    ProformaLib dmd = new ProformaLib();
    dmd.setNomTable("PROFORMA_CPL");
    String listCrt[] = {"id", "idMagasin", "idclientlib","daty"};
    String listInt[] = {"daty"};
    String libEntete[] = {"id", "daty", "idclientLib","idMagasinLib", "montantttc","montantPaye","montantreste","etatpaymentlib"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setTitre("Liste des proformas");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/proforma/proforma-liste.jsp");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");

    String[] colSomme = {"montantttc", "montantPaye", "montantreste"};
    pr.creerObjetPage(libEntete, colSomme);


    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    String libEnteteAffiche[] = {"id", "date", "Client","Magasin", "Montant","montant Pay&eacute;","Montant restant","&Eacute;tat Payment"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/proforma/inc/proforma-detail-liste.jsp&id=");
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
            String lib[] = {" ", "Nombre", "Somme montant", "Somme montant pay&eacute;", "Somme montant reste"};
            pr.getTableauRecap().setLibeEntete(lib);
            out.println(pr.getTableauRecap().getHtml());
        %>
            <%
                out.println(pr.getTableau().getHtml());
            %>

        <br>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


