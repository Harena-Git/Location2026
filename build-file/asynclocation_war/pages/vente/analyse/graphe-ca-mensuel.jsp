<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 27/11/2025
  Time: 15:07
  To change this template use File | Settings | File Templates.
--%>
<%@page import="vente.CaJournalier"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.Map" %>
<%@page import="affichage.*"%>

<% try{
    CaJournalier f = new CaJournalier();
    f.setNomTable("CA_MENSUEL");
    String listeCrt[] = {"annee","mois"};
    String listeInt[] = {"mois"};
    String libEntete[] = {"annee","moislib","montant"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Chiffre d'affaire mensuel");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/analyse/graphe-ca-mensuel.jsp");
    affichage.Champ[] liste = new affichage.Champ[2];
    Liste listeMois = new Liste("mois1");
    listeMois.makeListeMois();
    liste[0] = listeMois;

    Liste listeMois2 = new Liste("mois2");
    listeMois2.makeListeMois();
    liste[1] = listeMois2;

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("mois1").setLibelle("mois min");
    pr.getFormu().getChamp("mois2").setLibelle("mois max");
    pr.getFormu().getChamp("annee").setLibelle("ann&eacute;e");
    pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);
    String libEnteteAffiche[] = {"Ann&eacute;e","Mois","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>

        <%
            }catch(Exception e){

                e.printStackTrace();
            }
        %>

        <%
            String anneeGrapheParam = request.getParameter("anneeGraphe");
            String moisGrapheParam = request.getParameter("moisGraphe");

            int anneeGraphe = (anneeGrapheParam != null && !anneeGrapheParam.isEmpty())
                    ? Integer.parseInt(anneeGrapheParam)
                    : Integer.parseInt(Utilitaire.getAnneeEnCours());
            int moisGraphe = (moisGrapheParam != null && !moisGrapheParam.isEmpty())
                    ? Integer.parseInt(moisGrapheParam)
                    : 0;

            Map<String, Double> caMensuel = vente.GrapheCaJournalier.getDataChartCaMensuel(anneeGraphe);
        %>


        <%
            String[] moisNoms = new java.text.DateFormatSymbols(java.util.Locale.FRENCH).getMonths();
            String moisNom = (moisGraphe > 0) ? moisNoms[moisGraphe - 1] : "";
        %>

        <div class="cardradius">
            <form method="get" action="<%= session.getAttribute("lien") %>">
                <input type="hidden" name="but" value="vente/ca/camensuel.jsp">
                <div class="d-flex" style="align-items: end;gap: 8px">
                    <div class="col-md-2 nopadding">
                        <label for="anneeGraphe" class="form-label">Ann&eacute;e</label>
                        <input type="number" id="anneeGraphe" name="anneeGraphe" class="form-control"
                               value="<%= (request.getParameter("anneeGraphe") != null && !request.getParameter("anneeGraphe").isEmpty())
                            ? request.getParameter("anneeGraphe")
                            : Utilitaire.getAnneeEnCours() %>">
                    </div>

                    <div class="col-md-2 nopadding d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100 btn-small">Appliquer</button>
                    </div>
                </div>
            </form>
            <div class="card-body">
                <canvas id="c_ca_journalier"></canvas>
                <h5 class="card-title text-center">
                    CA mensuel
                    <% if (moisGraphe > 0) { %>
                    (<%= moisNom %> <%= anneeGraphe %>)
                    <% } else { %>
                    (Ann&eacute;e <%= anneeGraphe %>)
                    <% } %>
                </h5>
            </div>
        </div>

        <%
            affichage.Graphe g = new affichage.Graphe(new Map[]{caMensuel}, "CA",
                    new String[]{""}, new String[]{""}, "c_ca_journalier", "");
            g.setTypeGraphe("bar");
            out.println(g.getHtml("ctx_caj"));
        %>

    </section>
</div>
