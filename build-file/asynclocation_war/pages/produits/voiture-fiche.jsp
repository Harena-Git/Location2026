<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-21
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="produits.Voiture" %>

<%
    try{
    //Information sur les navigations via la page
    String lien = (String) session.getValue("lien");
    String pageModif = "produits/voiture-modif.jsp";
    String classe = "produits.Voiture";
    String pageListe = "produits/voiture-liste.jsp";
    String pageActuel = "produits/voiture-fiche.jsp";

    //Information sur la fiche
    Voiture t = new Voiture();
    t.setNomTable("VoitureLibelleMontant");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    t = (Voiture) pc.getBase();
    String id=request.getParameter("id");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("charge_per_kilometre").setLibelle("Charges par kilom&egrave;tre");
    pc.getChampByName("valeur_actuelle").setLibelle("Valeur Actuelle");
    pc.getChampByName("kilometrage_actuel").setLibelle("Kilometrage acquisition");
    pc.getChampByName("estEnPanne").setLibelle("Est en panne");
    pc.getChampByName("categorie").setVisible(false);
        pc.getChampByName("categorieLibelle").setLibelle("Categorie");
    pc.getChampByName("estEnPanne").setValeurDirect(t.getEstFonctionnel());
    pc.getChampByName("montantResa").setLibelle("Montant Reservation Valide");
    pc.getChampByName("etatGenerale").setLibelle("Etat generale / 10");

    pc.setTitre("Fiche Voiture");

    //Initialisation de l'objet onglet
    Map<String, String> map = new HashMap<String, String>();
    map.put("tarif-voiture", "");
    map.put("reservation-visee", "");
    map.put("historique-resa", "");
    map.put("charge-liee", "");
    String tab = "tarif-voiture";
    if(request.getParameter("tab")!=null){
        tab = request.getParameter("tab");
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";


%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=consulte/page-fiche-simple.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-success pull-left"  href="<%= lien + "?but=location/voiture/saisie-charge-voiture.jsp"+"&id=" + id%>" style="margin-right: 10px">Saisie Charge</a>
                            <a class="btn btn-success pull-left"  href="<%= lien + "?but=produits/as-ingredients-saisie.jsp"+"&id=" + id%>" style="margin-right: 10px">Saisir Tarif</a>
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=#&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("tarif-voiture")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=tarif-voiture">Tarif(s)</a></li>
                    <li class="<%=map.get("reservation-visee")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=reservation-visee">R&eacute;servation en cours</a></li>
                    <li class="<%=map.get("historique-resa")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=historique-resa">Historique R&eacute;servation </a></li>
                    <li class="<%=map.get("charge-liee")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=charge-liee">Charges li&eacute;&eacute;s </a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="id" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

</div>


<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

