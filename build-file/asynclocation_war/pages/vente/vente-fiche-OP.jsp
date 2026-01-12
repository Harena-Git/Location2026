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
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>


<%
    try {
        //Information sur les navigations via la page
        boolean isOnePage = request.getParameter("isOnePage") != null && request.getParameter("isOnePage").equals("1");
        String lien = (String) session.getValue("lien");
        String pageModif = "vente/vente-modif.jsp";
        String classe = "vente.Vente";
        String pageActuel = "vente/vente-fiche-OP.jsp";
        String butApresPost = "vente/vente-fiche-OP.jsp";
        String butOnePageApresPost = "vente/vente-fiche-OP.jsp";

        //Information sur la fiche
        VenteLib dp = new VenteLib();
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        dp = (VenteLib) pc.getBase();
        request.setAttribute("vente", dp);
        String id = request.getParameter("id");
        pc.setOnePage(true);
        pc.setLien(lien);
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
        List<Button> buttons = new ArrayList<>();
        if (dp.getEtat() < ConstanteEtat.getEtatValider()) {
            buttons.add(new Button(lien + "?but=" + pageModif,"&id=" + id,"Modifier","btn btn-warning",null,butOnePageApresPost));
            buttons.add(new Button(lien + "?but=apresTarif.jsp","&id=" + id + "&acte=annuler&classe=" + classe,"Annuler","btn btn-danger",butApresPost,butOnePageApresPost));
            buttons.add(new Button(lien + "?but=apresTarif.jsp", "&acte=valider&id=" + id + "&classe=" + classe, "Viser", "btn btn-success", butApresPost, butOnePageApresPost));
        }
        if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {
            buttons.add(new Button(lien + "?but=pertegain/pertegainimprevue-saisie.jsp","&idorigine=" + id,"Générer Perte/Gain","btn btn-primary",null,butOnePageApresPost));
            buttons.add(new Button(lien + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp","&idOrigine=" + id + "&montant=" + dp.getMontantreste() + "&devise=" + dp.getIdDevise() + "&tiers=" + dp.getIdClient() + "&taux=" + dp.getTauxdechange(),"Encaisser","btn btn-success",null,butOnePageApresPost));
            buttons.add(new Button(lien + "?but=bondelivraison-client/apresLivraisonFacture.jsp","&id=" + id + "&classe=" + classe,"Livrer","btn btn-success","vente/encaissement-modif.jsp", butOnePageApresPost));
            buttons.add(new Button(lien + "?but=avoir/apres-generation-avoir.jsp","&idvente=" + dp.getId() + "&classe=" + classe,"Générer avoir","btn btn-success",null,butOnePageApresPost));
            buttons.add(new Button(lien + "?but=vente/planPaiement-saisie.jsp","&idvt=" + id + "&classe=vente.Vente&table=" + dp.getNomTable() + "&bute=" + pageActuel,"Plan de Paiement","btn btn-success",null,butOnePageApresPost));
        }
        if (dp.getEtat() > 11) {
            buttons.add(new Button(lien + "?but=vente/bondelivraison-client/facturer-livraison.jsp","&idVente=" + id,"Attacher BL","btn btn-success",null,butOnePageApresPost));
        }
        buttons.add(new Button(request.getContextPath()+"/ExportPDF?action=fiche_vente","&id=" + id,"Imprimer","btn btn-warning",null,null));
//        buttons.add(new Button(lien + "?but=pageupload.jsp", "&id=" + id + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + id + "&nomprj=" + pc.getChampByName("designation").getValeur(), "Attacher Fichier", "btn btn-info", null, null));
        pc.setButtons(buttons);
        if (dp.getEtat() < ConstanteEtat.getEtatValider()) {
            pc.getButton("Annuler").setOnePage(true);
            pc.getButton("Viser").setOnePage(true);
        }

        List<OngletOP> onglets = new ArrayList<>();
        onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=vente-details", "D&eacute;tail(s)", map.get("vente-details"), butApresPost));
        onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=ecriture-detail", "Ecritures", map.get("ecriture-detail"), butApresPost));
        onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=livraison-details", "Livraison Details", map.get("livraison-details"),butApresPost));
        onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=liste-prevision", "Plan de paiements", map.get("liste-prevision"), butApresPost));
        if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {
            onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=pertegainimprevue-details", "Gain(s) ou perte(s)", map.get("pertegainimprevue-details"), butApresPost));
            onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=encaissement-vise-liste", "Paiement(s)", map.get("encaissement-vise-liste"), butApresPost));
            onglets.add(new OngletOP(lien + "?0=0", "&id=" + id + "&tab=avoirfc-details", "Avoir(s)", map.get("avoirfc-details"), butApresPost));
        }
        pc.setOnglets(onglets);

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
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <%= pc.getOngletsHtml() %>
                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

    <%=pc.getHtmlAttacherFichier()%>
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