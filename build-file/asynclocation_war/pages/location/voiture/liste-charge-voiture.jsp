

<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="location.ChargeVoitureLib" %>

<% try{
    ChargeVoitureLib bc = new ChargeVoitureLib();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e"};
    bc.setNomTable("CHARGEVOITURE_LIB");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));


    String listeCrt[] = {"id", "idvoiturelib","designation","daty","kilometrage","montant"};
    String listeInt[] = {"daty","montant","kilometrage"};
    String libEntete[] = {"id", "idvoiturelib","designation","idfournisseurlib","idproduitlib","quantite","pu","montant","kilometrage", "etatlib"};
    String libEnteteAffiche[] = {"id", "Voiture","D&eacute;signation","Fournisseur","Produit","Quantit&eacute;","Prix Unitaire","Montant","kilometrage","Etat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }
    pr.setTitre("Liste des Charges ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("location/voiture/liste-charge-voiture.jsp");
    String[] colSomme = {"montant"};
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idvoiturelib").setLibelle("Voiture");

    pr.getFormu().getChamp("kilometrage1").setLibelle("kilometrage Min");
    pr.getFormu().getChamp("kilometrage2").setLibelle("kilometrage Min");

    pr.getFormu().getChamp("montant1").setLibelle("montant Min");
    pr.getFormu().getChamp("montant2").setLibelle("montant Min");

    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=location/voiture/modif-charge-voiture.jsp");
    lienTab.put("Valider",pr.getLien() + "?&classe=location.ChargeVoiture&but=apresTarif.jsp&bute=location/voiture/fiche-charge-voiture.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=location/voiture/fiche-charge-voiture.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
//    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
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
            <div class="row col-md-12">
                <div class="col-md-2"></div>
                <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-6">
                            Etat :
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
                    </div>
                    </br>
                </div>
                <div class="col-md-2"></div>
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




