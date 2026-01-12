<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="reservation.EquipeResp" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "reservation.EquipeResp",
            nomtable = "equiperesp",
            apres = "reservation/reservation-fiche.jsp";

        EquipeResp o = new EquipeResp();
        PageInsert pi = new PageInsert(o, request, u);
        pi.setTitre("Ajout d'une &eacute;quipe responsable");
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("equiperesp").setLibelle("&Eacute;quipe Responsable");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idreservation").setLibelle("Reservation");
        pi.getFormu().getChamp("idreservation").setAutre("readonly");

        String idresa = request.getParameter("idresa");
        if (idresa!=null){
            pi.getFormu().getChamp("idreservation").setDefaut(idresa);
        }
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=pi.getTitre()%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>
<% }%>
