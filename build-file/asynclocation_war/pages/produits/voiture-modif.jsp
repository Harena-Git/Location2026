<%--
    Document   : as-commande-modif.jsp
    Created on : 29 d�c. 2025, 09:17
    Author     : Jocelyn
--%>
<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@ page import="produits.Voiture" %>


<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        Voiture a = new Voiture();
        PageUpdate pi = new PageUpdate(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        UserEJB u = (UserEJB) session.getAttribute("u");

        affichage.Champ[] liste = new affichage.Champ[2];

        TypeObjet op = new TypeObjet();
        op.setNomTable("VOITURE");
        pi.getFormu().getChamp("id").setVisible(false);
        pi.preparerDataFormu();

%>
<div class="content-wrapper">
    <h1 class="box-title">Modification Voiture</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="acte" value="update">
        <input name="bute" type="hidden" id="bute" value="produits/voiture-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="produits.Voiture">
    </form>
</div>

<%} catch(Exception ex){
    ex.printStackTrace();
}%>