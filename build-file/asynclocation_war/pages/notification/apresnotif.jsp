<%-- 
    Document   : apresNotif
    Created on : 19 avr. 2022, 10:25:01
    Author     : Madalitso
--%>
<%@page import="utils.Notification"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="affichage.*" %>
<html>
    <%!
        UserEJB u = null;
        String acte = null;
        String lien = null;
        String bute;
        String nomtable;
        Timestamp dateDebut=null, dateFin=null;
    %>
    <%
        try {
            nomtable = request.getParameter("nomtable");
            lien = (String) session.getValue("lien");
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
            bute = request.getParameter("bute");
            Object temp = null;
            String classe = request.getParameter("classe");
            String val = "";
            String id = request.getParameter("id");                 

        if (acte.compareToIgnoreCase("vu") == 0) {     // VU NOTIF
            Notification notif = new Notification();
            System.out.println("--------------notification vu--------------------");
            notif.setValChamp(notif.getAttributIDName(), request.getParameter("id"));
            notif.setNomTable(nomtable);
            ClassMAPTable o = notif.vu(u, null);
            temp = notif;
            val = o.getTuppleID();%>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=request.getParameter("ref")%>");</script>
            <%
        }

        if (acte.compareToIgnoreCase("toutvu") == 0) {     // TOUT VU NOTIF
            System.out.println("tonga atoooooo1");
            Notification notif = new Notification();
            System.out.println("tonga atoooooo2");
            notif.setNomTable("notification2");
            String where = " and receiver = '%s' and etat = 1";
System.out.println("tonga atoooooo3");
            where = String.format(where, (new Integer(u.getUser().getRefuser())).toString());
            Notification[]mesnotifs = (Notification[])CGenUtil.rechercher(notif, null, null, where);
            notif.vu(u, null, mesnotifs);
System.out.println("tonga atoooooo4");
            %>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&receiver=<%=u.getUser().getRefuser()%>");</script>
            <%
        }
            %>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=Utilitaire.champNull(id)%>");</script>
            <%
        } catch (Exception e) {
            e.printStackTrace();
            %>

            <script language="JavaScript"> 
                alert("<%=e.getMessage()%>");
                history.back();
            </script>
    <% return;}%>
</html>