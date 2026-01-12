<%@page import="mg.cnaps.notification.NotificationMessageLibelle"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>

<%
    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getValue("lien");
    String id = request.getParameter("id");
    NotificationMessageLibelle not = new NotificationMessageLibelle();
    NotificationMessageLibelle[] notification = (NotificationMessageLibelle[])u.getData(not , null, null, null, " and id='"+id+"'");
%>
<div class="content-wrapper" style="min-height: 445px;">
    <h1 align="center">Message</h1>
    <form action="cms.jsp?but=apresTarif.jsp" method="post" name="notification" id="notification" data-parsley-validate="" novalidate="">
        <div class="row">
            <div class="col-md-6">
                <div class="box-insert">
                    <div class="box box-primary">
                        <div class="box-body">
                            <table class="table table-bordered">
                                <tbody>
                                    <tr>
                                        <th>
                                            <label for="Date" tabindex="1">Daty</label>
                                        </th>
                                        <td>
                                            <input name="daty" type="text" class="form-control" id="daty" value="<%= Utilitaire.dateDuJour()%>" datepicker/></td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <label for="Destinataire" tabindex="2">De:</label>
                                        </th>
                                        <td>
                                            <input name="destinatairelib" type="textbox" class="form-control" id="destinatairelib" value="<% if(notification.length!=0){out.print(notification[0].getExpediteur());}else out.print(""); %>">
                                            <input name="destinataire" type="hidden" class="form-control" id="destinataire" value="<% if(notification.length!=0){out.print(notification[0].getIdexpediteur());}else out.print(""); %>">
                                        </td>
                                        <td>
                                            <input name="choix" type="button" class="submit" onclick="pagePopUp('choix/utilisateurChoixLibelle.jsp?champReturn=destinataire;destinatairelib')" value="...">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <label for="Objet" tabindex="3">Objet:</label>
                                        </th>
                                        <td>
                                            <input name="objet" type="textbox" class="form-control" id="objet" value="<% if(notification.length!=0){out.print(notification[0].getObjet());}else out.print(""); %>">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <label for="Message" tabindex="5">Message</label>
                                        </th>
                                        <td>
                                            <textarea style="height:250px;" name="message" type="textbox" class="form-control" id="message" ></textarea>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="box-footer">
                            <div class="col-xs-12">
                                <button type="submit" name="Submit2" class="btn btn-success pull-right" style="margin-right: 25px;" tabindex="91">Valider</button> 
                                <button type="reset" name="Submit2" class="btn btn-default pull-right" style="margin-right: 15px;" tabindex="92">Réinitialiser</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="etat" type="hidden" id="etat" value="1">
        <input name="iduser" type="hidden" id="iduser" value="<%=u.getUser().getRefuser() %>">
        <input name="bute" type="hidden" id="bute" value="notification/notification-liste.jsp">
        <input name="classe" type="hidden" id="classe" value="mg.cnaps.notification.NotificationMessage">
    </form>
</div>
