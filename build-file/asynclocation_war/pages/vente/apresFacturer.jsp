

<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="vente.Vente"%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="reservation.Reservation" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
  try{
    UserEJB u = (UserEJB)session.getAttribute("u");
    String lien = (String)session.getAttribute("lien");
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String type = request.getParameter("type");
    String nomtable=request.getParameter("nomtable");
    String id = request.getParameter("id");

    Vente v = null;
    Reservation r = new Reservation();
    r.setId(id);
    if(r.getId()!=null && !r.getId().isEmpty()){
      v = r.genererVente(u.getUser().getTuppleID(),null);
    }
    if (v == null) {
      throw new Exception("Erreur pour la creation de facture");
    }

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>?id=<%=v.getId()%>");</script>
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