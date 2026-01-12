<%@page import="mg.cnaps.notification.NotificationMessage"%>
<%@page import="user.UserEJB"%>
<%@page import="mg.cnaps.notification.NotificationLibelle"%>
<%@page import="bean.*"%>
<%@page import="affichage.*"%>
<%
    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getValue("lien");
    NotificationLibelle ov = new NotificationLibelle();
    PageConsulte pc = new PageConsulte(ov, request, (user.UserEJB) session.getValue("u"));//ou avec argument liste Libelle si besoin
    pc.setTitre("Notification");
    pc.getChampByName("lien").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("IDUSER_RECEVANT").setVisible(false);
    pc.getChampByName("IDUSER").setVisible(false);
    pc.getChampByName("idpers").setVisible(false);
    pc.getChampByName("idservice").setVisible(false);
    pc.getChampByName("iddirection").setVisible(false);
    pc.getChampByName("idobjet").setLibelle("R&eacutef&eacuterence");
    pc.getChampByName("service").setLibelle("Service destinaire");
    pc.getChampByName("direction").setLibelle("Direction destinataire");
    pc.getChampByName("classee").setLibelle("Classe");
    pc.getChampByName("priorite").setLibelle("Priorit&eacute;");
    NotificationLibelle[] lib = (NotificationLibelle[])CGenUtil.rechercher(new NotificationLibelle(), null, null, " and id = '"+request.getParameter("id")+"' ");
    if(lib.length!=0 && lib[0].getEtat()==1){
        u.lireNotification(request.getParameter("id"));
    }
    u.updateEtat(new NotificationMessage(), 2, request.getParameter("id"));
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=notification/notification-liste.jsp?"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            pc.getChampByName("idobjet").setLien(new PageConsulteLien(lien + "?but=" + pc.getChampByName("lien").getValeur(), ""));
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <!--
                            <%=request.getParameter("id")%>
                            <a class="btn btn-default pull-right"  href="<%=(String) session.getValue("lien") %>?but=notification/notification-saisie.jsp&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Répondre</a>
                            -->
                            <a class="btn btn-warning pull-right" href="<%=(String) session.getValue("lien") + "?but=notification/notification-modif.jsp&id=" + pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Modifier</a>
                                <a class="btn btn-danger pull-right"  href="<%=(String) session.getValue("lien") %>?but=notification/notification-transfere.jsp&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Transf&eacute;rer</a>
                           
                            <% if(pc.getChampByName("idobjet").getValeur().length()>3 && pc.getChampByName("idobjet").getValeur().substring(0, 3).compareToIgnoreCase("CER")==0){ %>
                            
                                <a href="<%=(String) session.getValue("lien")%>/../../Etats?action=bordereauTransmission&id=<%=request.getParameter("id")%>" class="btn btn-primary pull-right">Imprimer</a>  
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

