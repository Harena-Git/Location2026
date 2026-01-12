<%@page import="vente.BonDeCommande"%>
<%@page import="user.UserEJB"%>
<%@ page import="proforma.Proforma" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String bute = "vente/vente-fiche.jsp";
        Proforma p = new Proforma();
        p.setId(request.getParameter("id"));
        Proforma proforma = (Proforma) p.validerObject(u.getUser().getTuppleID());
        String id = proforma.getReservationPF().getVente().getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    }
%>