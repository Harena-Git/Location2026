<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="location.ChargeVoiture" %>
<%@ page import="produits.Voiture" %>
<%
try {
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");

    String  mapping = "location.ChargeVoiture",
            nomtable = "ChargeVoiture",
            apres = "facturefournisseur/facturefournisseur-fiche.jsp",
            titre = "Saisie Charge Voiture";

    ChargeVoiture ch=new ChargeVoiture();
    PageInsert pi = new PageInsert(ch, request, u);
    pi.setLien((String) session.getValue("lien"));
    Voiture v = null;
    if (request.getParameter("id") != null && !request.getParameter("id").equals("")) {
        v = (Voiture) new Voiture().getById(request.getParameter("id"),"voiture",null);
        pi.getFormu().getChamp("idvoiture").setDefaut(v.getId());
    }
    pi.getFormu().getChamp("idvoiture").setLibelle("Voiture");
    pi.getFormu().getChamp("idvoiture").setPageAppelComplete("produits.Voiture","id","voiture","id;nom","idvoiture"); 
    pi.getFormu().getChamp("idproduit").setVisible(false);
    //pi.getFormu().getChamp("idproduit").setPageAppelComplete("produits.IngredientsLib","id","AS_INGREDIENTS_ACHAT","id;libelle","idproduit");
    //pi.getFormu().getChamp("idproduit").setPageAppelInsert("produit/produit-achat-saisie.jsp","id;libelle","idproduit");
    pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("quantite").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("idfournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("idfournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur","id;nom","idfournisseur");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("tva").setDefaut("20");
    
    pi.getFormu().getChamp("kilometrage").setLibelle("Kilom&eacute;trage");

    
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>
<script>
    window.addEventListener('DOMContentLoaded', function() {
        <%
        if(v!= null) {
        %>
        var valeurs = '<%=v.getNom()%>';
        <%
            }
        %>
        const produitInput = document.getElementById('idvoiturelibelle');
        produitInput.value = valeurs;
    });
</script>
<%
}catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>