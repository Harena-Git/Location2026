<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="historique.MapUtilisateur"%>

<%@page import="java.util.List"%>

<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.FactureFournisseur" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="caisse.MvtCaisseCaution" %>
<%@ page import="caution.Caution" %>
<%@ page import="caution.CautionLib" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utils.ConstanteLocation" %>
<%@ page import="caution.ReservationVerifDetailsLib" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String typeBoutton;
    String champReturn;
    String action = null;
%>
<%
    Connection c = null;
    boolean estOuvert = false;
    try {
        nomtable = request.getParameter("nomtable");
        typeBoutton = request.getParameter("type");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        action = request.getParameter("action");
        String classe = request.getParameter("classe");
        ClassMAPTable t = null;
        String rajoutLie = "";
        if(c==null)
        {
            c=new UtilDB().GetConn();
            estOuvert = true;
        }
        String id = "";
        if (acte.compareToIgnoreCase("insert") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            PageInsert p = new PageInsert(t, request);
            MvtCaisseCaution f = (MvtCaisseCaution) p.getObjectAvecValeur();
            f.setNomTable(nomtable);
            Caution cau = new Caution();
            cau.setId(f.getIdOrigine());
            CautionLib cl =  (CautionLib) new CautionLib().getById(f.getIdOrigine(), "CautionLib", null);
            if(f.getType_mvt().compareToIgnoreCase("regler")==0){
                MvtCaisseCaution remb = f.clone();
                remb.setDesignation("Paiement remboursement du caution "+f.getIdOrigine());
                remb.setType_mvt(ConstanteLocation.type_remboursement);
                remb.setDebit(cl.getMontantgrp());
                remb.setCredit(0);
                remb.setIdOrigine(cl.getId());
                id = remb.createObject(u.getUser().getTuppleID(),c).getTuppleID();

                MvtCaisseCaution retenue = f.clone();
                retenue.setDesignation("Paiement retenue du caution "+f.getIdOrigine());
                retenue.setType_mvt(ConstanteLocation.type_retenue);
                retenue.setIdOrigine(cl.getId());


                ReservationLib res = cl.getReservationAvecVerif(null);
                double montantRetenue = res.getMontantRetenue(cl);
                double credit = montantRetenue;
                double debit = cl.getMontantgrp()-montantRetenue;
                //double credit= 0;
                //for(ReservationVerifDetailsLib r:res.getVerification()){
                //    credit += (r.getMontantretenue()*r.getRetenue())/100;
                //}
                retenue.setDebit(0);
                if(credit>0){
                    retenue.setCredit(credit);
                    id = retenue.createObject(u.getUser().getTuppleID(),c).getTuppleID();
                }
                rajoutLie = rajoutLie + "&id=" + id;
            }else if(f.getType_mvt().compareToIgnoreCase("encaisser")==0){
                MvtCaisseCaution encaisser = f.clone();
                encaisser.setDesignation("Paiement encaisser du caution "+f.getIdOrigine());
                encaisser.setType_mvt(ConstanteLocation.type_encaissement);
                encaisser.setDebit(0);
                encaisser.setCredit(cl.getMontantgrp());
                encaisser.setIdOrigine(cl.getId());
                id = encaisser.createObject(u.getUser().getTuppleID(),c).getTuppleID();
                rajoutLie = rajoutLie + "&id=" + id;
            }
        }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>");</script>
<%

} catch(ValidationException validation){
%>
<script language="JavaScript">
    var result=confirm("<%= validation.getMessageavalider()%>");
    if (result) {
        document.location.replace("<%=lien%>?but=apresTarif.jsp&id=<%=Utilitaire.champNull(request.getParameter("id"))%>&bute=<%=bute%>&acte=validerFF&classe=facture.FactureFournisseur");
    } else {
        history.back();
    }
</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    }finally {
        if(estOuvert==true && c!=null) c.close();
    }
%>
</html>






