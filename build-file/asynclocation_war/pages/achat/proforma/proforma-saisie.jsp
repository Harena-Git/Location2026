<%@page import="magasin.Magasin"%>
<%@page import="user.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="proforma.*" %>
<%@ page import="faturefournisseur.DmdAchat" %>
<%@ page import="faturefournisseur.DmdAchatFille" %>

<%
    try{
        UserEJB u =  (UserEJB) session.getValue("u");
        ProformaAchat mere = new ProformaAchat();
        mere.setNomTable("PROFORMAACHAT");
        ProformaAchatDetail fille = new ProformaAchatDetail();
        fille.setNomTable("ProformaAchatDetail");
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        ProformaAchat prerempli = null;

        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idFournisseur;idFournisseurlibelle","id;nom");
        pi.getFormu().getChamp("idDmdAchat").setLibelle("Demande d'achat");
        pi.getFormu().getChamp("idDmdAchat").setPageAppelComplete("demandeachat.DmdAchat","id","DmdAchat");
        pi.getFormu().getChamp("idDmdAchat").setPageAppelInsert("achat/demande-achat-saisie.jsp","idDmdAchat;idDmdAchatlibelle","id;daty");

        if(request.getParameter("idDmd")!=null && !request.getParameter("idDmd").isEmpty()){
            String idDmd = request.getParameter("idDmd");
            DmdAchat demandeAchat = new DmdAchat();
            prerempli = (ProformaAchat) demandeAchat.genererProforma(idDmd, null);
        }


        pi.getFormufle().getChamp("idDmdAchatFille_0").setLibelle("Id demande d'achat fille");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");

        for (int i = 0; i < pi.getNombreLigne(); i++) {
            pi.getFormufle().getChamp("id_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDmdAchatFille_"+i).setAutre("readonly");
        }
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"),false);

        if(prerempli !=null){
            String idDmd = request.getParameter("idDmd");
            pi.getFormu().setDefaut(prerempli);
            if(idDmd != null && !idDmd.isEmpty()){
                DmdAchatFille demandeAchatFille = new DmdAchatFille();
                demandeAchatFille.setNomTable("DmdAchatFille");
                demandeAchatFille.setIdmere(idDmd);
                DmdAchatFille[] dmdFilles = (DmdAchatFille[]) new bean.CGenUtil().rechercher(demandeAchatFille, null, null, null, "");

                if(dmdFilles != null){
                    ProformaAchatDetail[] detFille = new ProformaAchatDetail[dmdFilles.length];
                    for(int i = 0; i < dmdFilles.length; i++){
                        detFille[i] = dmdFilles[i].genererProformaAchatDt();
                    }
                    pi.setDefautFille(detFille);
                }
            }
        }

        String[] colOrdre = {"designation", "qte", "pu", "idDmdAchatFille"};
        pi.getFormufle().setColOrdre(colOrdre);
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "proforma.ProformaAchat";
        String classeFille = "proforma.ProformaAchatDetail";
        String butApresPost = "achat/proforma/proforma-fiche.jsp";
        String colonneMere = "idMere";

        String[] ordre = {"daty"};
        pi.getFormu().setOrdre(ordre);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>


<div class="content-wrapper">
    <h1>Saisie Proforma d'achat</h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>