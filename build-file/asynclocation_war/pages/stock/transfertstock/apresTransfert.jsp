<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="historique.MapUtilisateur"%>

<%@page import="java.util.List"%>

<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="affichage.*" %>
<%@ page import="stock.TransfertStock" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
//        String nomtable = null;
//        String typeBoutton;
//        String champReturn;
//        String action = null;
%>
<%

    try {
//            nomtable = request.getParameter("nomtable");
//            typeBoutton = request.getParameter("type");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
//            action = request.getParameter("action");
        String id = request.getParameter("id");
//            champReturn = request.getParameter("champReturn");


        if (acte.compareToIgnoreCase("receptionner") == 0) {
            TransfertStock.receptionner(u.getUser().getTuppleID(), id);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%
    }

}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    }
%>
</html>



