

<%@page import="caisse.CaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="affichage.Liste" %>
<%@ page import="caisse.TypeCaisse" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="caisse.CategorieCaisse" %>

<% try{ 
    CaisseCpl t = new CaisseCpl();
    String listeCrt[] = {"id", "val","desce","idTypeCaisseLib","idCategorieCaisseLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val","desce","idTypeCaisseLib","idCategorieCaisseLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des caisses");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/caisse-liste.jsp");
    Liste[] listes = new Liste[2];
    listes[0] = new Liste("idTypeCaisselib", new TypeCaisse(),"val", "id");
    listes[1] = new Liste("idCategorieCaisseLib", new CategorieCaisse(),"val", "id");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    pr.getFormu().getChamp("idTypeCaisseLib").setLibelle("Type");
    pr.getFormu().getChamp("idCategorieCaisseLib").setLibelle("Categorie");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/caisse-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/caisse-fiche.jsp", pr.getLien() + "?but=caisse/caisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    String[] attributLien = {"id", "id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "D&eacute;signation", "Description","Type de caisse","Cat&eacute;gorie"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
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



