
<%@page import="historique.MapUtilisateur"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="bean.CGenUtil"%>
<%@page import="mg.cnaps.notification.NotificationLibelle"%>
<%@page import="affichage.PageRecherche"%>

<% 
    try{
    UserEJB u = (UserEJB) session.getAttribute("u");
    MapUtilisateur mu = u.getUser();
    NotificationLibelle notif = new NotificationLibelle();
    notif.setNomTable("historiquenotif");
    
    String listeCrt[] = {"id", "message",  "daty","ecartdate"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "message", "daty", "ecartdate","ref","lien_html", "etatlib"};
    PageRecherche pr = new PageRecherche(notif, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setAWhere(" and receiver='" + mu.getTuppleID() + "' order by daty desc");
    pr.setNpp(10);
    pr.setTitre("Liste des notifications");
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.setApres("notification/notification-liste.jsp");
    String[] colSomme = null;
    
    pr.creerObjetPage(libEntete, colSomme);
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1>Notifications</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=notification/notification-liste.jsp" method="post" name="notification" id="notification">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%  
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"ID",  "Message", "Date", "heures", "reference","lien", "statut"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>
<script>
    const baseLien = '<%= pr.getLien() %>';
    const links = document.querySelectorAll("table a");
    links.forEach(link => {
        const currentHref = link.getAttribute("href");
        const newHref = currentHref.replace("XX", baseLien);
        link.setAttribute("href", newHref);
    });
</script>
<%
    }catch(Exception e) { e.printStackTrace();}
%>

