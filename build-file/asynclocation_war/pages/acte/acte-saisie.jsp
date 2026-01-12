
<%@page import="produits.Acte"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="affichage.Liste"%>
<%@ page import="reservation.Check" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="affichage.Champ" %>
<%@ page import="reservation.CheckInSansCheckOutCPL" %>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "produits.Acte",
            nomtable = "ACTE",
            apres = "acte/acte-fiche.jsp",
            titre = "Services faits";
    
    Acte  unite = new Acte();
    unite.setNomTable("Acte");
    PageInsert pi = new PageInsert(unite, request, u);
    pi.setLien((String) session.getValue("lien"));
    String idresa =request.getParameter("idresa");
    String idclient =request.getParameter("idclient");

    pi.getFormu().getChamp("idproduit").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTOService","pu;tva;libelle","pu;tva;libelle");
    pi.getFormu().getChamp("idproduit").setLibelle("Services");
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idclient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
    pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("pu").setAutre("onChange='calculerMontant()'");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("libelle").setDefaut("Location");
    pi.getFormu().getChamp("idreservation").setLibelle("Reservation");
    if(idresa!=null){
        pi.getFormu().getChamp("idreservation").setDefaut(idresa);
    }
        pi.getFormu().getChamp("qte").setDefaut("1");
//    pi.getFormu().getChamp("idreservation").setPageAppelComplete("reservation.Reservation","id","Reservation");
    //pi.getFormu().getChamp("idchambre").setLibelle("Chambre");
        String apresWh="";
        if(idresa!=null&&idresa.compareToIgnoreCase("")!=0)apresWh=" and idreservationmere='"+idresa+"'";
        pi.getFormu().getChamp("idreservation").setPageAppelCompleteAWhere("reservation.CheckInSansCheckOutCPL", "idproduit", "CHECKINSANSCHEKOUTCPL", "id", "idreservation",apresWh);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().setNbColonne(2);
    if(idresa!=null&&idclient!=null){
        pi.getFormu().getChamp("idclient").setDefaut(idclient);
        pi.getFormu().getChamp("idclient").setAutre("readonly");
//        pi.getFormu().getChamp("idreservation").setDefaut(checkin[0].getId());
//        pi.getFormu().getChamp("idreservation").setAutre("readonly");
    }
//    String[] ordre = {"idclient", "idproduit", "libelle", "daty", "pu", "qte", "idreservation", "tva"};
//    pi.getFormu().setColOrdre(ordre);
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
    function calculerMontant() {
        var val = 0;
            $('input[id^="qte_"]').each(function() {
                var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
                var montant = parseFloat($(this).val());
                if(!isNaN(quantite) && !isNaN(montant)){
                    var value =quantite * montant;
                    val += value;
                }
            });
            $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(val));
    }
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>