


<%@page import="mg.cnaps.compta.ComptaCompte"%>
<%@page import="magasin.Magasin"%>
<%@page import="caisse.Caisse"%>
<%@page import="caisse.CategorieCaisse"%>
<%@page import="caisse.TypeCaisse"%>
<%@page import="annexe.Point"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="affichage.Liste"%> 

<%
    try{
    String autreparsley = "data-parslsey-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "caisse.Caisse",
            nomtable = "caisse",
            apres = "caisse/caisse-fiche.jsp",
            titre = "Cr&eacute;ation d'une caisse";
    
    Caisse  caisse = new Caisse();
    PageInsert pi = new PageInsert(caisse, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("Etat").setVisible(false);
    Liste[] liste = new Liste[4];
        TypeCaisse type = new TypeCaisse();
        type.setNomTable("TYPECAISSE");
        liste[0] = new Liste("idTypeCaisse",type,"val","id");
        Magasin magasin = new Magasin();
        magasin.setNomTable("magasin");
        liste[1] = new Liste("idMagasin",magasin,"val","id");
        CategorieCaisse categ = new CategorieCaisse();
        categ.setNomTable("CategorieCaisse");
        liste[2] = new Liste("idCategorieCaisse",categ,"val","id");
        liste[3] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[3].setDefaut("AR");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idTypeCaisse").setLibelle("Type");
    pi.getFormu().getChamp("IdCategorieCaisse").setLibelle("Categorie");
    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("idDevise").setLibelle("Devise");
    pi.getFormu().getChamp("idPoint").setVisible(false);
    pi.getFormu().getChamp("compte").setDefaut("COC007913");
    pi.getFormu().getChamp("compte").setVisible(false);
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

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>