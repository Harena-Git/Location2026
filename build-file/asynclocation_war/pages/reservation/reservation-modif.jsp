<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="reservation.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try {
        //Variable de navigation
        String classeMere = "reservation.Reservation";
        String classeFille = "reservation.ReservationDetails";
        String butApresPost = "reservation/reservation-fiche.jsp";
        String colonneMere = "idmere";
        //Definition de l'affichage
        String id = request.getParameter("id");
        Reservation  mere = new Reservation();
        ReservationDetailsLib fille = new ReservationDetailsLib();
        fille.setIdmere(id);
        ReservationDetailsLib[] details = (ReservationDetailsLib[]) CGenUtil.rechercher(fille, null, null, "");
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), 2);

        ReservationLib resas = null;
        if (request.getParameter("id") != null && !request.getParameter("id").equalsIgnoreCase(""))
        {
            resas = (ReservationLib) new ReservationLib().getById(request.getParameter("id"),null,null);
        }
        //Information globale
        pi.setLien((String) session.getValue("lien"));

        //Modification affichage mère
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("daty").setLibelle("Date de r&eacute;servation");
        pi.getFormu().getChamp("idclient").setLibelle("Client");
        pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client","id","Client", "client/client-saisie.jsp","id;nom");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pv;idVoiture","pu;idVoiture");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");
        pi.getFormufle().getChamp("heure_0").setLibelle("Heure");
        pi.getFormufle().getChamp("id_0").setLibelle("ID");
        pi.getFormufle().getChamp("idmere_0").setLibelle("Reservation Mere");
        pi.getFormufle().getChamp("idvoiture_0").setLibelle("Voiture");
        pi.getFormufle().getChamp("distanceestimation_0").setLibelle("Estimation Distance");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"), false);
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idvoiture"),"readonly");
        String[] order = {"idproduit", "idvoiture","pu", "qte","distanceestimation", "remarque", "daty","heure"};
        pi.getFormufle().setColOrdre(order);
      
        //Preparer affichage
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1>Modification R&eacute;servation </h1>
    <form action="<%=(String) session.getValue("lien")%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <%
                    out.println(pi.getFormu().getHtmlInsert());
                %>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>
            </div>
        </div>
        <input name="acte" type="hidden" id="acte" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=pi.getNombreLigne()%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
</div>
<script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('idclientlibelle').value = '<%=resas.getIdclientlib()%>';
        });

        const valeurs = [
            <% if (details != null) {
                for (int i = 0; i < details.length; i++) { %>
            {
                Produit: "<%= details[i].getLibelleproduit() %>",
                Voiture: "<%= details[i].getIdVoitureLib() %>"
            }<%= (i < details.length - 1) ? "," : "" %>
            <% }
            } %>
        ];
        window.addEventListener('DOMContentLoaded', function() {
                for (let i = 0; i < valeurs.length; i++) {
                    const produitInput = document.getElementById('idproduit_' + i +'libelle');
                    const voitureInput = document.getElementById('idVoiture_' + i + 'libelle');
                    if (produitInput){
                        produitInput.value = valeurs[i].Produit;
                    }
                    if (voitureInput) {
                        voitureInput.value = valeurs[i].Voiture;
                    }
                }
            }
        );
</script>
<%
    }catch(Exception e)
    {
        System.out.println(e.getMessage());
        e.printStackTrace();
    }
%>