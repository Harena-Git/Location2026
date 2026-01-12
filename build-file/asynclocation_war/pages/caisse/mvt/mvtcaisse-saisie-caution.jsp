<%--
  Created by IntelliJ IDEA.
  User: madalitso
  Date: 2025-08-27
  Time: 15:57
  To change this template use File | Settings | File Templates.
--%>
<%@page import="utils.ConstanteStation"%>
<%@page import="affichage.*"%>
<%@page import="caisse.MvtCaisse"%>
<%@page import="caisse.Caisse"%>
<%@page import="user.*"%>
<%@ page import="caisse.MvtCaisseCaution" %>
<%@ page import="caution.Caution" %>
<%@ page import="caution.ReservationVerifDetailsLib" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="caution.CautionLib" %>

<%


    try{

        String idcaution = request.getParameter("idcaution");
        String idreservation = request.getParameter("idreservation");
        String type = request.getParameter("type");

        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        MvtCaisseCaution mouvement = new MvtCaisseCaution();
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);

        if(idcaution!=null && idreservation!=null && type!=null){

            CautionLib cau = new CautionLib();
            cau.setId(idcaution);
            cau.setIdreservation(idreservation);
            cau = (CautionLib) new CautionLib().getById(idcaution, "CAUTIONLIB", null);

            ReservationLib res = cau.getReservationAvecVerif(null);
            double montantRetenue = res.getMontantRetenue(cau);
            double credit = montantRetenue;
            double debit = cau.getMontantgrp()-montantRetenue;

//            for(ReservationVerifDetailsLib r:res.getVerification()){
//                credit += (r.getMontantretenue()*r.getRetenue())/100;
//                debit += r.getMontantretenue();
//            }
            if(type.compareToIgnoreCase("encaisser")==0){
                pageInsert.getFormu().getChamp("debit").setVisible(false);
                Caution caution = (Caution) new Caution().getById(idcaution, "CAUTION", null);
                double payer = (caution.getMontantreservation()*caution.getPct_applique())/100;
                pageInsert.getFormu().getChamp("credit").setDefaut(String.valueOf(payer));
            }else{
//                debit = debit - credit;
                pageInsert.getFormu().getChamp("debit").setDefaut(String.valueOf(debit));
                pageInsert.getFormu().getChamp("credit").setDefaut(String.valueOf(credit));
            }
            pageInsert.getFormu().getChamp("idTiers").setDefaut(res.getIdclient());
            pageInsert.getFormu().getChamp("type_mvt").setDefaut(type);
            pageInsert.getFormu().getChamp("idOrigine").setDefaut(idcaution);
        }

        affichage.Champ[] liste = new affichage.Champ[1];
//        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        Caisse c = new Caisse();
        //c.setIdPoint(ConstanteStation.getFichierCentre());
        liste[0] = new Liste("idCaisse",c,"val","id");

        pageInsert.getFormu().changerEnChamp(liste);
        pageInsert.getFormu().getChamp("designation").setDefaut("Paiement du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("idDevise").setVisible(false);
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("taux").setVisible(false);
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setAutre("readonly");
        pageInsert.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
        pageInsert.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
        pageInsert.getFormu().getChamp("credit").setAutre("readonly");
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelComplete("client.Client","id","Client");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelInsert("client/client-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageInsert.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("idPrevision").setVisible(false);
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        pageInsert.getFormu().getChamp("compte").setVisible(false);
        pageInsert.getFormu().getChamp("type_mvt").setVisible(false);
        pageInsert.getFormu().getChamp("idModePaiement").setVisible(false);
        pageInsert.getFormu().getChamp("idProforma").setVisible(false);

        String[] order= {"daty", "designation", "idCaisse", "idTiers"};
        pageInsert.getFormu().setOrdre(order);

        String classe = "caisse.MvtCaisseCaution";
        String nomTable = "MOUVEMENTCAISSE";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();

%>

<div class="content-wrapper">
    <h1 align="center">Saisie de mouvement de caisse</h1>
    <form action="<%=pageInsert.getLien()%>?but=caisse/mvt/apresMvtCaution.jsp" method="post"  data-parsley-validate>
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
