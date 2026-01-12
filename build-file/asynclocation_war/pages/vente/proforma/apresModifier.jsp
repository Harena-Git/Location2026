<%--
    Document   : apresMultiple
    Created on : Oct 19, 2018, 2:55:36 PM
    Author     : Jerry
--%>
<%@page import="constante.ConstanteEtat"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="proforma.ProformaDetails" %>
<%@ page import="proforma.Proforma" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String typeBoutton;
    String ben;
    String[] tId;
%>
<%
    try {
        ben = request.getParameter("nomtable");
        nomtable = request.getParameter("nomtable");
        typeBoutton = request.getParameter("type");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        Object temp = null;
        String[] rajoutLien = null;
        String classe = request.getParameter("classe");
        ClassMAPTable t = null;
        String tempRajout = request.getParameter("rajoutLien");
        String val = "";
        String id = request.getParameter("id");
        tId = request.getParameterValues("ids");

        String nombreLigneS = request.getParameter("nombreLigne");
        int nombreLigne = Utilitaire.stringToInt(nombreLigneS);

        ClassMAPTable classTemp = (ClassMAPTable) (Class.forName(classe).newInstance());
        if (acte.equalsIgnoreCase("insert") && request.getParameter(classTemp.getAttributIDName())!=null && !request.getParameter(classTemp.getAttributIDName()).isEmpty())
        {
            acte = "updateInsert";
        }

        String idmere = request.getParameter("idmere");
        String classefille = request.getParameter("classefille");
        ClassMAPTable mere = null;
        ClassMAPTable fille = null;
        String colonneMere = request.getParameter("colonneMere");
        String nombreDeLigne = request.getParameter("nombreLigne");
        int nbLine = Utilitaire.stringToInt(nombreDeLigne);


        String rajoutLie = "";
        if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
            rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
        }
        if (bute == null || bute.compareToIgnoreCase("") == 0) {
            bute = "pub/Pub.jsp";
        }

        if (classe == null || classe.compareToIgnoreCase("") == 0) {
            classe = "pub.Montant";
        }

        if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
            typeBoutton = "3"; //par defaut modifier
        }

        int type = Utilitaire.stringToInt(typeBoutton);

        if (acte != null && acte.compareToIgnoreCase("modifier") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageUpdateMultiple p = new PageUpdateMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable cmere = p.getObjectAvecValeur();
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
            ProformaDetails[] filles = new ProformaDetails[cfille.length];
            for (int i = 0; i < cfille.length; i++) {
                cfille[i].setNomTable(nomtable);
                filles[i] = (ProformaDetails) cfille[i];
            }
            Proforma tempo = (Proforma) cmere;
            idmere = tempo.modifier(u,null, filles);
            /*
            ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cfille);
            temp = (Object) o;
            if (temp != null) {
                val = temp.toString();
                idmere = o.getTuppleID();
            }
             */
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<% }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>&valeur=<%=val%>&id=<%=id%>");</script>
<%

} catch (Exception ex) {
    ex.printStackTrace();
%>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<%
        return;
    }%>
</html>



