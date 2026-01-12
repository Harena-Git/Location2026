<%@page import="vente.VenteLib"%>
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
        String pageModif = "vente/vente-modif.jsp";
        String classe = "vente.Vente";
        String pageActuel = "vente/vente-fiche.jsp";

        //Information sur la fiche
        VenteLib dp = new VenteLib();
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        dp = (VenteLib) pc.getBase();
        request.setAttribute("vente", dp);
        String id = request.getParameter("id");
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("designation").setLibelle("D&eacute;signation");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("idMagasin").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("etat");
        pc.getChampByName("idDevise").setLibelle("Devise");
        pc.getChampByName("idMagasinLib").setLibelle("Magasin");
        pc.getChampByName("idClient").setVisible(false);
        pc.getChampByName("idClientLib").setLibelle("Client");
        pc.getChampByName("montanttotal").setLibelle("Montant HTVA");
        pc.getChampByName("montanttva").setLibelle("Montant TVA");
        pc.getChampByName("montantttc").setLibelle("Montant TTC");
        pc.getChampByName("montantTtcAr").setLibelle("Montant TTC en Ariary");
        pc.getChampByName("Montantpaye").setLibelle("Montant Pay&eacute;");
        pc.getChampByName("Montantreste").setLibelle("Reste &agrave; payer");
        pc.getChampByName("Tauxdechange").setLibelle("Taux de change");
        pc.getChampByName("montantRevient").setLibelle("Montant Revient");
        pc.getChampByName("margeBrute").setLibelle("Marge Brute");
        pc.setTitre("Details Facture Client");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("vente-details", "");
        map.put("encaissement-vise-liste", "");
        map.put("livraison-detail", "");
        map.put("liste-prevision", "");
        if(dp.getEtat() >= ConstanteEtat.getEtatValider()) {
            map.put("mvtcaisse-details", "");
            map.put("ecriture-detail", "");
            map.put("avoirfc-details", "");
        }
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "vente-details";
        }
        map.put("avoir-details", "");
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
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
                            <% if (dp.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-warning pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=vente/vente-fiche.jsp&classe=" + classe%>"><button class="btn btn-danger" style="margin-right: 10px">Annuler</button></a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/vente-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <% }%>
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=pertegain/pertegainimprevue-saisie.jsp&idorigine=" + id%> " style="margin-right: 10px">G&eacute;n&eacute;rer Perte/Gain</a>
                            <% }%>
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOrigine=" + request.getParameter("id") + "&montant="+dp.getMontantreste()+"&devise=" + dp.getIdDevise()+"&tiers="+dp.getIdClient()+"&taux="+dp.getTauxdechange() %> " style="margin-right: 10px">Encaisser</a>
                            <% }%>
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison-client/apresLivraisonFacture.jsp&id=" + request.getParameter("id") + "&bute=vente/encaissement-modif.jsp&classe=" + classe%> " style="margin-right: 10px">Livrer</a>
                            <% }%>
                            <% if (dp.getEtat() > 11) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/bondelivraison-client/facturer-livraison.jsp&idVente=" + request.getParameter("id")%>" style="margin-right: 10px">Attacher BL</a>
                            <% } %>
                             <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=avoir/apres-generation-avoir.jsp&idvente="+dp.getId()+"&classe=" + classe%> " style="margin-right: 10px">G&eacute;n&eacute;rer avoir</a>

                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/planPaiement-saisie.jsp&idvt="+id+"&classe=vente.Vente&table="+dp.getNomTable()+"&bute="+pageActuel%>" style="margin-right: 10px">Plan de Paiement</a>
                            <% }%>
                            <a class="btn btn-warning pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer</a>
                            

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
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("vente-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=vente-details">D&eacute;tail(s)</a></li>
                    <li class="<%=map.get("ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=ecriture-detail">Ecritures</a></li>
                          <li class="<%=map.get("livraison-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=livraison-details">Livraison Details</a></li>
                        <li class="<%=map.get("liste-prevision")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%=id%>&tab=liste-prevision">Plan de paiements</a></li>
                        <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                    
                    <li class="<%=map.get("pertegainimprevue-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=pertegainimprevue-details">Gain(s) ou perte(s)</a></li>
                    <li class="<%=map.get("encaissement-vise-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=encaissement-vise-liste">Paiement(s)</a></li>
                    <li class="<%=map.get("avoirfc-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=avoirfc-details">Avoir(s)</a></li>    
                    <% }%>
                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
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
        padding: 0 30px 0 30px; !important;
    }
</style>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
