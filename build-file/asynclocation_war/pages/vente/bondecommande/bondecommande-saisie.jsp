<%-- 
    Document   : bondecommande-saisie
    Created on : 17 juil. 2024, 16:27:57
    Author     : micha
--%>


<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="vente.*"%>
<%@page import="bean.UnionIntraTable"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="java.util.Calendar"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@page import="annexe.Unite"%>
<%@ page import="proforma.Proforma" %>
<%@ page import="proforma.ProformaDetails" %>
<%@ page import="magasin.Magasin" %>

<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    BonDeCommande mere = new BonDeCommande();   
    BonDeCommandeFille fille = new BonDeCommandeFille();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("daty").setLibelle("Daty");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("designation").setLibelle("Designation");
    pi.getFormu().getChamp("idClient").setLibelle("Client");
    
    pi.getFormu().getChamp("reference").setLibelle("Reference");
    pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idProforma").setAutre("readonly");

        String idProforma = request.getParameter("idProforma");
        if (idProforma != null && !idProforma.trim().isEmpty()) {
            pi.getFormu().getChamp("idProforma").setDefaut(request.getParameter("idProforma"));
            Proforma proforma = new Proforma();
            proforma.setId(idProforma);
            BonDeCommande bc = proforma.createBonDeCommande();
            ProformaDetails[] details = proforma.getFilleProforma();
            if (details != null && details.length > 0) {
                BonDeCommandeFille[] lignes = new BonDeCommandeFille[details.length];
                for (int i = 0; i < details.length; i++) {
                    ProformaDetails detail = details[i];
                    lignes[i] = detail.createBonDeCommandeFille();
                }
                pi.setDefautFille(lignes);
            }
            pi.getFormu().setDefaut(bc);
        }


        pi.getFormu().getChamp("idProforma").setLibelle("Proforma");
    Liste[] liste = new Liste[3];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiement",mp,"val","id");
    liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
    liste[1].setDefaut("AR");
    liste[1].setLibelle("Devise");
    liste[1].setLibelle("Devise");
    Magasin magasin = new magasin.Magasin();
    magasin.setNomTable("MAGASIN2");
    liste[2] = new Liste("idMagasin",magasin,"val","id");
    liste[2].setLibelle("Magasin");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    //pi.getFormu().getChamp("fournisseur").setPageAppel("choix/fournisseur/fournisseur-choix.jsp","fournisseur;fournisseurlibelle");
    pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientLibelle","id;nom");
    

    //Nommage et visibilite 
        
    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("produit_" + i).setLibelle("Produit");
       // pi.getFormufle().getChamp("unite_" + i).setAutre("readonly");
    }

    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produit"),"annexe.ProduitLib","id","PRODUIT_LIB","","");


    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantite");
    pi.getFormufle().getChamp("pu_0").setLibelle("PU");
    pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
    pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("remise"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idDevise"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("montant"),false);
    pi.getFormufle().getChampMulitple("unite").setVisible(false);
    //Variables de navigation
    String classeMere = "vente.BonDeCommande";
    String classeFille = "vente.BonDeCommandeFille";
    String butApresPost = "vente/bondecommande/bondecommande-fiche.jsp";
    String colonneMere = "idbc";
    //Preparer les affichages
     pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
       
%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Saisie Bon de Commande</h1>
    <!--  -->
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

