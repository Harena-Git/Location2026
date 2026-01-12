<%@page import="stock.TransfertStockCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="uploadbean.UploadService" %>
<%
    UserEJB u = (user.UserEJB)session.getValue("u");
try {
    String dossier = "op";
    TransfertStockCpl unite = new TransfertStockCpl();
    PageConsulte pc = new PageConsulte(unite, request, u);
    pc.setTitre("Fiche transfert de stock");
    unite =(TransfertStockCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idMagasinDepartlib").setLibelle("Magasin de d&eacute;part");
    pc.getChampByName("idMagasinDepart").setVisible(false);
    pc.getChampByName("idMagasinArrivelib").setLibelle("Magasin d'arriv&eacute;e");
    pc.getChampByName("idMagasinArrive").setVisible(false);
    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");

    String pageActuel = "stock/transfertstock/transfertstock-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "stock/transfertstock/transfertstock-saisie.jsp";
    String classe = "stock.TransfertStock";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("transfertstockdetails-liste", "");
    map.put("mvtstock-details", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "transfertstockdetails-liste";
    }
    map.put(tab, "active");
    tab ="inc/"+ tab + ".jsp";
            AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
        configuration.CynthiaConf.load();
        String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=stock/mvtstock-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
         <div class="col-md-6" >
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body ">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                        <% if(unite.getEtat()==1){ %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=stock/transfertstock/transfertstock-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=annexe/unite/unite-liste.jsp&classe="+classe %>">Supprimer</a>
                            <% } %>
                         <% if(unite.getEtat()>=11){ %>
                            <a class="btn btn-tertiary pull-right"  href="<%=(String) session.getValue("lien") + "?but=pageupload.jsp&id=" + id + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=stock/transfertstock/transfertstock-fiche.jsp&id=" + id%>" style="margin-right: 10px">Attacher Fichier</a>
                        <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("transfertstockdetails")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=transfertstockdetails-liste">Transfert détails</a></li>
                    <li class="<%=map.get("mvtstock-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=mvtstock-details">Mouvement de stock</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idTransfertStock" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>      
    
     <div class="row" style="margin: 0!important;">
        <%--        <div class="col-md-1"></div>--%>
        <div class="col-md-12 nopadding">
            <div class="box">
                <h2 class="box-title h520pxSemibold " style="margin-left: 20px;">Les fichiers attach&eacute;s</h2>
                <div class="box-body" style="padding: 0 20px 20px 20px;">
                    <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                        <thead>
                        <tr>
                            <th class="contenuetable"></th>
                            <th class="contenuetable">Libell&eacute;</th>
                            <th class="contenuetable">Fichier</th>
                            <th class="contenuetable">Telecharger</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%if (fichiers == null || fichiers.length == 0) { %>
                        <tr>
                            <td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td>
                        </tr>
                        <%} else {
                            for (AttacherFichier fichier : fichiers) {%>
                        <tr class="treegrid-1 treegrid-expanded">
                            <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                            <td><%=fichier.getChemin()%></td>
                            <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                            <td>
                                <!--                                    <form action="../UploadDownloadFileServlet" method="get">
                                            <input type="submit" value="download">
                                            <input type="hidden" name="fileName" value="<%=cdn + dossier + "/" + fichier.getChemin()%>">
                                        </form>-->
                                <a href="../FileManager2?parent=<%= "/"+dossier + "/" +fichier.getChemin()  %>" class="btn btn-success" >Telecharger</a>
                            </td>
                        </tr>
                        <%}
                        }%>

                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>