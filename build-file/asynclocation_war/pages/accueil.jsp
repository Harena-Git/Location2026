<%-- 
    Document   : acceuil.jsp
    Created on : 30 mars 2023, 17:23:45
    Author     : Ny Anjara Mamisoa
--%>
<%--
    Document   : acceuil.jsp
    Created on : 30 mars 2023, 17:23:45
    Author     : Ny Anjara Mamisoa
--%>
<style>
    .card-wrapper {
        display: flex;
        justify-content: start;
        gap: 24px;
        flex-wrap: wrap;
        margin-top: 32px;
        padding: 0 16px;
    }
    .card-choix-service {
        display: flex;
        flex-direction: column;
        align-items: baseline;
        padding: 16px !important;
        border-radius: 16px;
        color: #ffffff;
        width:calc(20% - 20px);
    }
    @media (max-width: 1200px) {
        .card-choix-service {
            width: calc(25% - 16px);
        }
        .card-wrapper {
            gap: 16px;
        }
    }
    @media (max-width: 900px) {
        .card-choix-service {
            width: calc(33% - 6px);
        }
        .card-wrapper {
            gap: 11px;
        }
    }
    @media (max-width: 576px) {
        .card-choix-service {
            width: calc(50% - 6px);
        }
    }
    .bleu-fonce {
        background:rgb(11, 50, 76);
    }
    .vert {
        background:rgb(34, 206, 126);
    }
    .vert-clair {
        background:rgb(245, 255, 187);
    }
    .img-card-service {
        width: 40%;
        margin: 0 auto;
        margin-bottom: 12%;
    }
    .card-title-service {
        font-size: 2rem;
        line-height: 2rem;
        height: 4rem;
        margin-bottom: 16px;
        font-weight: bold;
    }

    .desc-card-choix-service {
        font-size: 1.8rem;
        font-weight: 100;
        line-height: 1.8rem;
    }
    .card-choix-service:hover {
        .important-text,desc-card-choix-service {
            color: white;
        }
    }
    .title-service {
        font-size: 5rem;
        font-weight: bold;
        max-width: 80%;
        line-height: 5rem;
        font-weight: 600;
    }
    .desc-service {
        font-size: 2rem;
        line-height: 2rem;
        font-weight: 100;
        margin-top: 16px;
    }
    .row {
        margin: 0;
    }
    a:hover {
        text-decoration: none;
        color: #ffffff;
    }
    .violet {
        background: #5e60ce;
    }
    .violet:hover {
        background: #3d348b;
    }

    .bleu {
        background: #4895ef;
    }
    .bleu:hover {
        background: #1d4ed8;
    }

    .jaune {
        background: #fbbf24;
    }
    .jaune:hover {
        background: #f59e0b;
    }

    .rose {
        background: #f472b6;
    }
    .rose:hover {
        background: #be185d;
    }

    .vert {
        background: #14b8a6;
    }
    .vert:hover {
        background: #0f766e;
    }

    .marron {
        background: #a16207;
    }
    .marron:hover {
        background: #713f12;
    }

    .rouge {
        background: #ef4444;
    }
    .rouge:hover {
        background: #991b1b;
    }

    .gris {
        background: #9ca3af;
    }
    .gris:hover {
        background: #4b5563;
    }
    .coral {
        background: #f87171;
    }
    .coral:hover {
        background: #dc2626;
    }




</style>

<div class="content-wrapper">

    <div class="row">
        <div class="col-md-12">
            <h1 class="title-service">Bienvenue sur votre espace de gestion</h1>
            <p class="desc-service">Pilotez vos locations de meubles en toute simplicit&eacute;. G&eacute;rez vos clients, contrats, livraisons et paiements en quelques clics.</p>
        </div>
        <div class="col-md-12 card-wrapper">

            <a href="module.jsp?but=reservation/reservation-liste.jsp&currentMenu=ELM001104006" class="card-choix-service col-md-4 rose">
                <img src="${pageContext.request.contextPath}/assets/img/order-delivery.png" class="img-card-service"/>
                <p class="card-title-service"><span class="important-text">Reservation</span></p>
                <p class="desc-card-choix-service">Voir la liste de reservations des Clients.</p>
            </a>

            <a href="module.jsp?but=caisse/etatcaisse/etatcaisse-liste.jsp&currentMenu=MENUDYN0011" class="card-choix-service col-md-4 vert">
                <img src="${pageContext.request.contextPath}/assets/img/caisse.png" class="img-card-service"/>
                <p class="card-title-service"><span class="important-text">Caisse</span></p>
                <p class="desc-card-choix-service">Consultez les &eacute;tats de caisse et suivez les flux financiers.</p>
            </a>
            <a href="module.jsp?but=vente/vente-liste.jsp&currentMenu=MNDN000000007" class="card-choix-service col-md-4 rouge">
                <img src="${pageContext.request.contextPath}/assets/img/recette.png" class="img-card-service"/>
                <p class="card-title-service"><span class="important-text">Recettes</span></p>
                <p class="desc-card-choix-service">Suivez les recettes li&eacute;es aux activit&eacute;s de la clinique.</p>
            </a>
            <a href="module.jsp?but=stock/etatstock/etatstock-liste.jsp&amp;currentMenu=MNDN0000000171" class="card-choix-service col-md-4 violet">
                <img src="${pageContext.request.contextPath}/assets/img/stock.png" class="img-card-service"/>
                <p class="card-title-service"><span class="important-text">&Eacute;tat de Stock</span></p>
                <p class="desc-card-choix-service">Consultez en temps r&eacute;el les quantit&eacute;s disponibles dans vos diff&eacute;rents d&eacute;p&ocirc;ts.</p>
            </a>
            <a href="module.jsp?but=facturefournisseur/facturefournisseur-liste.jsp&currentMenu=MNDN000000015" class="card-choix-service col-md-4 bleu">
                <img src="${pageContext.request.contextPath}/assets/img/cart.png" class="img-card-service"/>
                <p class="card-title-service"><span class="important-text">D&eacute;penses</span></p>
                <p class="desc-card-choix-service">Acc&eacute;dez aux donn&eacute;es de d&eacute;penses.</p>
            </a>
        </div>
    </div>
</div>



