<%@page import="produits.Acte"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Acte t =new Acte();
    PageUpdate pi = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
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
    pi.getFormu().getChamp("idreservation").setLibelle("Chambre");
    String apresWh=" and reservation='"+request.getParameter("id")+"'";
    pi.getFormu().getChamp("idreservation").setPageAppelCompleteAWhere("reservation.CheckInSansCheckOutCPL", "idproduit", "CHECKINSANSCHEKOUTCPL", "id", "idreservation",apresWh);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("id").setVisible(false);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().setNbColonne(2);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
       <div class="row">
              <div class="col-md-3"></div>
              <div class="col-md-6">
                     <div class="box-fiche">
                            <div class="box">
                                   <div class="box-title with-border">
                                        <h1>Modification acte</h1>
                                   </div>
                                   <div class="box-body">
                                        <form action="<%=(String) session.getValue("lien")%>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                                            <%
                                                out.println(pi.getFormu().getHtmlInsert());
                                            %>
                                            <div class="row">
                                                <div class="col-md-11">
                                                    <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                                                </div>
                                                <br><br> 
                                            </div>
                                            <input name="bute" type="hidden" id="bute" value="acte/acte-fiche.jsp"/>
                                            <input name="acte" type="hidden" id="acte" value="update">
                                            <input name="classe" type="hidden" id="classe" value="produits.Acte">
                                            <input name="nomtable" type="hidden" id="nomtable" value="ACTE">
                                        </form>
                                   </div>
                            </div>
                     </div>
              </div>
       </div>
</div>