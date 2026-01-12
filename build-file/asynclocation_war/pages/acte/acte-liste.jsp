

<%@page import="produits.ActeLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{ 
    ActeLib t = new ActeLib();
    String[] etatVal = {"ACTE_LIB", "ACTE_LIB_C", "ACTE_LIB_V","ACTE_LIB_NONFACT","ACTE_LIB_FACT","ACTE_LIB_A"};
    String[] etatAff = {"Tous", "Cr&eacute;e(s)", "Vis&eacute;e(s)", "Non Facture&eacute;e(s)","Facture&eacute;e(s)","Annul&eacute;e(s)"};

    t.setNomTable(etatVal[0]);
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        t.setNomTable(request.getParameter("etat"));
    }

    String listeCrt[] = {"idclientlib", "daty", "idreservation","libelleproduit","montant"};
    String listeInt[] = {"daty","montant"};
    String libEntete[] = {"id", "libelle","idreservation","daty","libelleproduit","qte","pu","montant","idclientlib","etatlib", "chambre"};
    String libEnteteAffiche[] = {"id", "d&eacute;signation","r&eacute;servation","date","services","quantit&eacute;","prix unitaire","montant","client","&eacute;tat", "Chambre"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des services faits");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("acte/acte-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("idreservation").setLibelle("R&eacuteservation");
    pr.getFormu().getChamp("libelleproduit").setLibelle("Services");
    String[] colSomme = { "montant" };
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=acte/acte-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=acte/acte-fiche.jsp", pr.getLien() + "?but=caisse/caisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    String[] attributLien = {"id", "id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
function changerDesignation() {
    document.depense.submit();
}
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="depense" id="depense">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    Etat : 
                    <select name="etat" class="champ" id="etat" onchange="changerDesignation()" >
                        <%for(int i=0; i<etatVal.length; i++){
                            String selected = etatVal[i].equalsIgnoreCase(t.getNomTable()) ? "selected" : "";
                        %>
                        <option value="<%=etatVal[i]%>" <%=selected%>><%=etatAff[i]%></option>
                        <%}%>
                    </select>
                </div>
                <div class="col-md-4"></div>
            </div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



