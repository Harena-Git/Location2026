<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="mg.cnaps.notification.NotificationLibelle"%>
<%@page import="user.UserEJB"%>

<%
    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getValue("lien");

    TypeObjet log_dir = new TypeObjet();
    log_dir.setNomTable("LOG_DIRECTION");
    TypeObjet[] directions = (TypeObjet[]) u.getData(log_dir, null, null, null, "");

    PageConsulte pc = new PageConsulte(new NotificationLibelle(), request, (user.UserEJB) session.getValue("u"));
    NotificationLibelle val = (NotificationLibelle) pc.getBase();
%>
<% if (val != null) {%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Transfert notification</h1>
    </section>
    <section class="content">
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6">
                <div class="box box-primary box-solid">
                    <form action="<%=lien%>?but=notification/apresnotif.jsp" id="transfert" name="transfert" method="post" data-parsley-validate="" novalidate="">
                        <div class="box-body">
                            <table class="table table-bordered" id="tablePiece">
                                <tbody>
                                    <tr>
                                        <th><label for="idpers" tabindex="1">Personnel :</label></th>
                                        <td>
                                            <input id="idpers" class="form-control" type="textbox" tabindex="1" name="idpers" data-parsley-id="1">
                                        </td>
                                        <td>
                                            <input class="submit" type="button" value="..."  name="choix"
                                                   onclick="pagePopUp('choix/logPersonnelChoix.jsp?champReturn=idpers&apresLienPageAppel=')">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="service" tabindex="2">Service :</label></th>
                                        <td>
                                            <input id="service" class="form-control" type="textbox" tabindex="2" name="service" data-parsley-id="2">
                                        </td>
                                        <td>
                                            <input class="submit" type="button" value="..."  name="choix"
                                                   onclick="pagePopUp('choix/serviceChoix.jsp?champReturn=service&apresLienPageAppel=')">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="direction" tabindex="3">Direction :</label></th>
                                        <td>
                                            <select id="direction" name="direction" class="form-control" tabindex="3" data-parsley-id="3">
                                                <option value=""></option>
                                                <%
                                                    if (directions != null) {
                                                        for (int i = 0; i < directions.length; i++) {%>
                                                <option value="<%=directions[i].getId()%>" <% if (val.getId().equalsIgnoreCase(directions[i].getId())) { %>selected="" <% }%> >
                                                    <%=directions[i].getVal()%>
                                                </option>            
                                                <% }
                                                    }%>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="objet" tabindex="4">Objet :</label></th>
                                        <td>
                                            <input id="objet" class="form-control" readonly="readonly" value="<%=val.getObjet()%>"
                                                   type="textbox" tabindex="4" name="objet" data-parsley-id="4">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="message" tabindex="5">Message :</label></th>
                                        <td>
                                            <textarea readonly="readonly" id="message" class="form-control" style="resize: none;" name="message" data-parsley-id="5"><%=((val.getMessage()!=null)?val.getMessage().trim() : "")%></textarea>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="box-footer">
                            <div class="col-xs-12">
                                <input name="acte" type="hidden" id="nature" value="update">
                                <input name="bute" type="hidden" id="bute" value="notification/notification-liste.jsp">
                                <input name="idNotification" type="hidden" value="<%=request.getParameter("id") %>">
                                <input name="classe" type="hidden" id="classe" value="mg.cnaps.notification.NotificationMessage">
                                <button class="btn btn-success pull-right" tabindex="111" style="margin-right: 25px;" id="submittransfere" name="submittransfere" type="button">Valider</button>
                                <button class="btn btn-default pull-right" tabindex="112" style="margin-right: 15px;" name="Submit2" type="reset">Réinitialiser</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>
<% }%>

<script type="text/javascript">
    $(function () {
        $("#submittransfere").click(function(){
            if($("#idpers").val() === "" && $("#service").val() === "" && $("#direction").val() === ""){
                alert("Veuillez choisir au moins un des champs : personnel, service ou direction");
            } else{
                $("#transfert").submit();
            }
        });
    });
</script>