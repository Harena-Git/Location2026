<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="javax.ejb.ConcurrentAccessTimeoutException"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.*" %>

<%
    try {

        String but = "index.jsp";
        String lien = "module.jsp";
        String lienContenu = "index.jsp";
        String menu = "elements/menu/";
        String langue = "";
        if (request.getParameter("langue") != null) {
            session.setAttribute("langue", (String) request.getParameter("langue"));
        }
        langue = (String) session.getAttribute("langue");
%>
<%@include file="security-login.jsp"%>
<%    if (session.getAttribute("lien") != null) {
        lien = (String) session.getAttribute("lien");
    }
    if (request.getParameter("idmenu") != null) {
        session.setAttribute("lien", lien);
        session.setAttribute("menu", (String) request.getParameter("idmenu"));
    }
    if ((request.getParameter("but") != null) && session.getAttribute("u") != null) {
        but = request.getParameter("but");
    } else {%>
<script language="JavaScript">
    alert("Veuillez vous connecter pour acceder a ce contenu");
    document.location.replace("${pageContext.request.contextPath}/index.jsp");
</script>
<% }
%>

<!DOCTYPE html>
<html>
    <head>
        <!--<meta charset="UTF-8">-->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-15">
        <title>ERP-Prospection</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <jsp:include page='elements/css.jsp'/>
        <script src="${pageContext.request.contextPath}/dist/js/chart.js"></script>
        <script src="${pageContext.request.contextPath}/dist/js/chartjs-plugin-datalabels@2.js"></script>
<%--        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>--%>
<%--        <script src="https://printjs-4de6.kxcdn.com/print.min.js"></script>--%>
<%--        <link rel="stylesheet" href="https://printjs-4de6.kxcdn.com/print.min.css">--%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/dom-to-image/2.6.0/dom-to-image.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
    </head>
    <body class="skin-yellow-light sidebar-mini">
        <!-- Loader  -->
        <div id="loader" style="display: none;" class="loading-state">
            <div class="loading"></div>
        </div>

        <!-- Site wrapper -->
        <div class="wrapper" style="max-width:none !important;">
            <!-- Header -->
            <jsp:include page='elements/header.jsp'/>
            <!-- =============================================== -->
            <!-- chatbot -->
            <jsp:include page='chatbot/chat.jsp'/>
            <!-- Menu Gauche -->
            <jsp:include page='elements/menu/module.jsp'/>
            <!-- =============================================== -->
            <!-- Content -->
            <% try {%>
            <div id="butjsp"> <jsp:include page="<%=but%>"/></div>
            <% } catch (Exception e) {%>
            <script language="JavaScript"> alert('<%=e.getMessage().toUpperCase()%>');
                history.back();</script>
                <%
                    }
                %>
            <!-- =============================================== -->
            <!-- Footer -->
            <jsp:include page='elements/footer.jsp'/>
            <!-- =============================================== -->
            <!-- Panel -->
<%--            <jsp:include page='elements/panel.jsp'/>--%>
            <!-- =============================================== -->
        </div>
        <!-- ./wrapper -->
        <jsp:include page='elements/js.jsp'/>
        <script>
            <%
                UserEJB user = (UserEJB) request.getSession().getAttribute("u");
            %>
            runWScommunication('<%=user.getUser().getTuppleID()%>');
        </script>
        <script src="${pageContext.request.contextPath}/apjplugins/champcalcul.js" defer></script>      
        <script src="${pageContext.request.contextPath}/apjplugins/champdate.js" defer></script>      
        <script src="${pageContext.request.contextPath}/apjplugins/champautocomplete.js" defer></script>
        <script src="${pageContext.request.contextPath}/apjplugins/addLine.js" defer></script>
        <script src="${pageContext.request.contextPath}/apjplugins/moreAction.js" defer></script>
        <script language="JavaScript">

        </script>
    </body>
    <script>
        $(document).ready(function () {
            // RETIRER data-toggle="offcanvas" via JS
            $('.sidebar-toggle').removeAttr('data-toggle');

            // Restaurer l'état du menu au chargement
            var savedState = localStorage.getItem('menuCollapse');
            if (savedState === 'true') {
                $('body').addClass('sidebar-collapse');
                $('.treeview-menu').hide();
            } else if (savedState === null) {
                // Première visite : menu OUVERT par défaut
                localStorage.setItem('menuCollapse', 'false');
                $('body').removeClass('sidebar-collapse');
            }

            // Nettoyer TOUS les handlers et créer le nôtre
            $('.sidebar-toggle').off().on('click', function(e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                var isCollapsed = $('body').hasClass('sidebar-collapse');
                if (isCollapsed) {
                    // OUVRIR la sidebar
                    localStorage.setItem('menuCollapse', 'false');
                    $('body').removeClass('sidebar-collapse');
                } else {
                    // FERMER la sidebar
                    localStorage.setItem('menuCollapse', 'true');
                    $('body').addClass('sidebar-collapse');
                    $('.treeview-menu').slideUp(300);
                }
            });

            // NOUVELLE FONCTION : Ouvrir le menu quand on clique sur un lien dans la sidebar
            $('.sidebar a').on('click', function() {
                var isCollapsed = $('body').hasClass('sidebar-collapse');
                if (isCollapsed) {
                    localStorage.setItem('menuCollapse', 'false');
                    $('body').removeClass('sidebar-collapse');
                }
            });
        });
    </script>
    <script type="text/javascript">
        $(function() {
            // Define the fix function
            function fixContentWrapperHeight() {
                var $wrapper = $('.content-wrapper');

                // 1. Fix the "Cut Off" content (Clear Floats)
                // This forces the wrapper to stretch around floated columns (col-md-*)
                if (!$wrapper.hasClass('clearfix')) {
                    $wrapper.addClass('clearfix');
                }

                // 2. Calculate available screen space
                var windowH = $(window).height();
                var headerH = $('.main-header').outerHeight() || 0;
                var minH = windowH - headerH;

                // 3. Apply styles
                $wrapper.css({
                    'min-height': minH + 'px', // Ensure it fills at least the screen
                    'height': 'auto',          // Allow it to grow infinitely with content
                    'overflow': 'visible'      // Ensure no content is hidden
                });
            }

            // Run immediately
            fixContentWrapperHeight();

            // Run on window resize
            $(window).resize(fixContentWrapperHeight);

            // Run repeatedly to catch Charts rendering and AJAX loading
            setInterval(fixContentWrapperHeight, 200);
        });
    </script>
</html>
<%
    } catch (ConcurrentAccessTimeoutException e) {
        out.println("<script language='JavaScript'> document.location.replace('/cnaps-war/');</script>");
    }
%>