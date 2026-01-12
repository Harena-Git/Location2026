<%@page import="affichage.*"%>
<%@page import="caisse.MvtCaisse"%>
<%@page import="caisse.Caisse"%>
<%@page import="caisse.Devise"%>
<%@page import="user.*"%>
<%@ page import="bean.TypeObjet" %>

<%


    try{

        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        MvtCaisse mouvement = new MvtCaisse();
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);

        Liste[] listes = new Liste[3];
        listes[0] = new Liste("idCaisse", new Caisse(),"val", "id");
        listes[1] = new Liste("idDevise", new Devise(),"val", "id");
        TypeObjet tpmdp=new TypeObjet();
        tpmdp.setNomTable("modepaiement");
        listes[2] = new Liste("idmodepaiement",tpmdp,"val","id");

        pageInsert.getFormu().changerEnChamp(listes);
        pageInsert.getFormu().getChamp("designation").setDefaut("Sortie du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("credit").setVisible(false);
        pageInsert.getFormu().getChamp("idproforma").setVisible(false);
        pageInsert.getFormu().getChamp("compte").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
        pageInsert.getFormu().getChamp("idmodepaiement").setLibelle("Mode de paiement");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelComplete("client.Client","id","Client");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelInsert("client/client-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageInsert.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");

        pageInsert.getFormu().setOrdre(new String[]{"daty"});

        String classe = "caisse.MvtCaisse";
        String nomTable = "MOUVEMENTCAISSE";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();

%>

    <div class="content-wrapper">
        <h1 align="center">Saisie du mouvement de caisse sortie</h1>
        <form action="<%=pageInsert.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
            <%
                out.println(pageInsert.getFormu().getHtmlInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classe %>">
            <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
        </form>
    </div>

<%

    }catch(Exception e){

        e.printStackTrace();
    }

%>
