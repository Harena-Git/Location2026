<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-21
  Time: 15:42
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Voiture" %>
<%
    try{
        Voiture a = new Voiture();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        //Variables de navigation
        String classe = "produits.Voiture";
        String butApresPost = "produits/voiture-fiche.jsp";
        String nomTable = "VOITURE";
        //Generer les affichages

        pi.getFormu().getChamp("charge_per_kilometre").setLibelle("Charges par Kilom&egrave;tre");
        pi.getFormu().getChamp("valeur_actuelle").setLibelle("Valeur Actuelle");
        pi.getFormu().getChamp("kilometrage_actuel").setLibelle("Kilometrage Actuel");
        pi.getFormu().getChamp("priorite").setDefaut("1000");
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Cr&eacute;ation voiture </h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>


