
<%@page import="user.*" %>
<%@page import="bean.*" %>
<%@page import="utilitaire.*" %>
<%@page import="affichage.*" %>
<%@ page import="stock.MvtStockLib" %>


<%
    try {
        MvtStockLib stock = new MvtStockLib();
        stock.setNomTable("mvtstocklib");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","designation","idMagasinlib","idTypeMvStocklib","daty"};
        PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if (request.getParameter("id") != null) {
            pr.setAWhere(" and IDTRANSFERT='" + request.getParameter("id") + "'");
        }
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

%>

<div class="box-body">
    <%  String libEnteteAffiche[] = {"Id","D&eacute;signation","Magasin","Type mouvement de stock","Date"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getTableau().getData();
        System.err.println("=============="+pr.getTableau().getData().length);
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donne trouvee</h4></center><%
        }


        %>
</div>
<%    } catch (Exception e) {
        e.printStackTrace();
    }%>