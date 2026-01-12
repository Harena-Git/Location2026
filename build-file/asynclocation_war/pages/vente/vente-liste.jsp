<%--
    Document   : vente-liste
    Created on : 25 mars 2024, 09:57:03
    Author     : Angela
--%>

<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>

<% try{
    VenteLib bc = new VenteLib();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(e)", "Vis&eacute;(e)", "Annul&eacute;(e)"};

    String[] paiementVal = {"","1","0","-1"};
    String[] paiementAff = {"Tous","Pay&eacute;e(s)", "Impay&eacute;e(s)","Pay&eacute;e en totalit&eacute;"};
    bc.setNomTable("VENTE_CPL");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));





    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("VENTE_CPL");
    }
    String[] listeCrt = {"id", "designation","idClientLib","daty","datyprevu","montantpaye","montantreste"};
    String[] listeInt = {"daty","datyprevu","montantpaye","montantreste"};
    String[] libEntete = {"id", "designation","idClientLib","idDevise","daty", "montanttotal","montantpaye", "montantreste","montantRemise","etatlib","datyprevu", "etatlogistiquelib"};
    String[] libEnteteAffiche = {"id", "D&eacute;signation","Client","devise","Date", "Montant","Montant Pay&eacute;","Montant restant", "Montant remise","&Eacute;tat","&Eacute;ch&eacute;ance", "&Eacute;tat Logistique"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }
    if(request.getParameter("paiement")!=null && request.getParameter("paiement").compareToIgnoreCase("")!=0) {
        if(request.getParameter("paiement").compareToIgnoreCase("0")==0){
            pr.setAWhere(pr.getAWhere()+" and montantpaye=0");
        } else if(request.getParameter("paiement").compareToIgnoreCase("1")==0){
            pr.setAWhere(pr.getAWhere()+" and montantpaye>0");
        }else if(request.getParameter("paiement").compareToIgnoreCase("-1")==0){
            pr.setAWhere(pr.getAWhere()+" and montantreste=0");
        }
    }
    pr.setTitre("Liste Des Factures");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/vente-liste.jsp");
    String[] colSomme = {"montantpaye", "montantreste" };
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));

//    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC Min");
//    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC Max");
    pr.getFormu().getChamp("montantpaye1").setLibelle("Montant pay&eacute; Min");
    pr.getFormu().getChamp("montantpaye2").setLibelle("Montant pay&eacute; Max");
    pr.getFormu().getChamp("montantreste1").setLibelle("Montant Restant Min");
    pr.getFormu().getChamp("montantreste2").setLibelle("Montant Restant Max");
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    pr.getFormu().getChamp("datyprevu1").setLibelle("&Eacute;ch&eacute;ance Min");
    pr.getFormu().getChamp("datyprevu2").setLibelle("&Eacute;ch&eacute;ance Max");

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/vente-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?&classe=vente.Vente&but=apresTarif.jsp&bute=vente/vente-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Livrer",pr.getLien() + "?but=bondelivraison-client/apresLivraisonFacture.jsp&bute=vente/encaissement-modif.jsp" + pr.getFormu().getChamp("id").getValeur()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] enteteRecap = {"","","Somme du montant pay&eacute;","Somme du montant restant"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
    pr.getFormu().setAnotherButton("<a id=\"export-btn\" class=\"btn btn-secondary btn-small\" href=\"#\">\n" +
            "                    Exporter en pdf <i class=\"fa fa-download\"></i>\n" +
            "                </a>\n" +
            "                <a id=\"export-btn-details\" class=\"btn btn-primary btn-small pull-left\" href=\"#\">\n" +
            "                    Exporter en pdf avec d&eacute;tails <i class=\"fa fa-download\"></i>\n" +
            "                </a>");
%>
<script>
     function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row m-0 mb-5">
                <div class="input-container">
                    <div class="form-input">
                        <label class="input-label" for="etat" >&Eacute;tat :</label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                                <%
                                    for( int i = 0; i < etatAff.length; i++ ){ %>
                                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                                        <% } else { %>
                                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                                        <% } %>
                                <%    }
                                %>
                        </select>
                    </div>
                    <div class="form-input">
                        <label for="paiement" class="input-label">Paiement :</label>
                        <select name="paiement" class="champ form-control" id="paiement" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < paiementAff.length; i++ ){ %>
                            <% if(request.getParameter("paiement") !=null && request.getParameter("paiement").compareToIgnoreCase(paiementVal[i]) == 0) {%>
                            <option value="<%= paiementVal[i] %>" selected> <%= paiementAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= paiementVal[i] %>"> <%= paiementAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                </div>
            </div>

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
           
        <%
            out.println(pr.getTableau().getHtml());
        %>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function exportPDF() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=vente_liste"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)


        var exportButton = document.getElementById("export-btn");
        exportButton.href = exportUrl;
    }
    function exportPDFAvecDetails() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;


        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=vente_liste_mere_fille"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)


        var exportButton = document.getElementById("export-btn-details");
        exportButton.href = exportUrl;
    }
    function exportExcel() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=vente_liste"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)


        var exportButton = document.getElementById("export-btn-excel");
        exportButton.href = exportUrl;
    }
     function exportReportingJournalier() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;
        var idModePaiementValue = document.getElementById("idmodepaiement").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=reporting_journalier"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)
            + "&idmodepaiement=" + encodeURIComponent(idModePaiementValue);


        var exportButton = document.getElementById("reporting-journalier");
        exportButton.href = exportUrl;
    }

    document.getElementById("export-btn").addEventListener("click", exportPDF);
    document.getElementById("export-btn-details").addEventListener("click", exportPDFAvecDetails);
    document.getElementById("export-btn-excel").addEventListener("click", exportExcel);
    document.getElementById("reporting-journalier").addEventListener("click", exportReportingJournalier);
</script>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




