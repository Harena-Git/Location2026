<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    VenteDetailsLib t = new VenteDetailsLib();
    t.setNomTable("VENTE_DETAILS_CPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "designation", "image", "qte","pu", "montantAvantRemise","montantRemise", "montant"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idVente='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;

    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id", "D&eacute;signation", "Image", "Quantit&eacute;","Prix unitaire","Montant avant remise","Montant Remise","Montant"};
//        pr.getTableau().setTailleImage("100");
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        VenteDetailsLib[] liste=(VenteDetailsLib[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant ToTal:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantAvantRemise")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Montant Remise:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantRemise")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Montant Final:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montant")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
        </table>
    </div>
    <%  }if(pr.getTableau().getHtml() == null)
         {
               %><center><h4>Aucune donne trouvee</h4></center><%
         }


    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>

