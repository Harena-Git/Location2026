<%@page import="mg.cnaps.notification.NotificationMessage"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    NotificationMessage art = new NotificationMessage();
    UserEJB u = (user.UserEJB) session.getValue("u");
    PageUpdate pi = new PageUpdate(art, request, (user.UserEJB) session.getValue("u"));
    
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("IDUSER_RECEVANT").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("lien").setVisible(false);
    pi.getFormu().getChamp("idobjet").setVisible(false);
    pi.getFormu().getChamp("id").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("direction").setVisible(false);
    pi.getFormu().getChamp("service").setVisible(false);
    pi.getFormu().getChamp("destinataire").setVisible(false);
    pi.getFormu().getChamp("iduser").setVisible(false);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <h1>Modification notification</h1>
                    <form action="<%=(String) session.getValue("lien")%>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" name="starticle">
                        <%
                            out.println(pi.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-primary pull-right" name="submit" type="submit">Valider</button>
                            </div>
                            <br><br> 
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="notification/notification-liste.jsp">
                        <input name="classe" type="hidden" id="classe" value="mg.cnaps.notification.NotificationMessage">
                        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
                        <input name="nomtable" type="hidden" id="nomtable" value="notification">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
