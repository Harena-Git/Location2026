<%@page import="proforma.ProformaAchatDetail"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier"%>
<%@page import="configuration.*"%>
<%@page import="uploadbean.*"%>

<%
    try {
        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        String classe = "proforma.ProformaAchatDetail";
        String pageActuel = "achat/proforma/proforma-fille-fiche.jsp";

        //Information sur la fiche
        ProformaAchatDetail dp = new ProformaAchatDetail();
        ProformaAchatDetail base = new ProformaAchatDetail();

        dp.setNomTable("PROFORMAACHATDETAIL");
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        String id = request.getParameter("id");
        pc.setTitre("Fiche des d&eacute tails du proforma");
        pc.getChampByName("id").setLibelle("id");
        pc.getChampByName("idMere").setLibelle("id Mere");
        pc.getChampByName("IdDmdAchatFille").setLibelle("Id Demande AchatFille");
        pc.getChampByName("designation").setLibelle("Designation");
        pc.getChampByName("qte").setLibelle("Quantit&eacute;");
        pc.getChampByName("pu").setLibelle("Prix unitaire");


       

        AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
        configuration.CynthiaConf.load();
        String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
        String projectName = pc.getChampByName("designation").getValeur()
                    .replace("'","_")                
                    .replace("/","_")
                    .replace("-","_")
                    .replace(":", "_")
                    .replace("*", "_")
                    .replace(" ", "_");
        String dossierTemp = "vente/files/"+projectName;
        String dossier = dossierTemp;

        base = (ProformaAchatDetail) pc.getBase();
        double vente = base.getQte() * base.getPu();
        double qte = base.getQte();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=vente/vente-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-info pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                            <br>        
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="row">
<%--        <div class="col-md-1"></div>--%>
            <div class="col-md-12 bottom-vente-fiche">
                <div class="box">
                    <h2 class="box-title" style="margin-left: 10px;">Les fichiers attach&eacute;s</h2>
                    <div class="box-body" style="padding: 0 20px 20px 20px;">
                        <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                            <thead>
                                <tr>
                                    <th style="background-color: #2c3d91;color: white;"></th>
                                    <th style="background-color: #2c3d91;color: white;">Libell&eacute;</th>
                                    <th style="background-color: #2c3d91;color: white;">Fichier</th>
                                    <th style="background-color: #2c3d91;color: white;">Date d`upload</th>
                                    <th style="background-color: #2c3d91;color: white;">Telecharger</th>
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
                                    <td><%=fichier.getDaty()%></td>
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
<style>
    .bottom-vente-fiche {
        padding: 0 30px 0 30px;
    }
</style>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
