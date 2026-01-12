<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 11:44
  To change this template use File | Settings | File Templates.
--%>

<%@page import="magasin.Magasin"%>
<%@page import="vente.*"%>
<%@page import="user.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="client.Client" %>
<%@ page import="proforma.*" %>
<%@ page import="vente.dmdprix.DmdPrix" %>
<%@ page import="utils.ConstanteLocation" %>

<%
    try{
        String titre = "Saisie Proforma";
        String apres = "apresMultiple.jsp";
        String acte = "insert";
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        PageInsertMultiple pi=null;
        Proforma mere = new Proforma();
        mere.setNomTable("PROFORMA_INSERT");
        ProformaDetailsLib fille = new ProformaDetailsLib();
        fille.setNomTable("PROFORMADETAILS_CPLIMAGE");
        int nombreLigne = 30;
        pi = new PageInsertMultiple(mere,fille,request, nombreLigne,u);
        Proforma prerempli = null;
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        //pi.getFormu().getChamp("idorigine").setLibelle("ID Origine");
        pi.getFormu().getChamp("tva").setVisible(false);
        pi.getFormu().getChamp("numproforma").setVisible(false);

        pi.getFormu().getChamp("idorigine").setVisible(false);
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("dateprevres").setLibelle("Date de d&eacute;but de reservation");
        pi.getFormu().getChamp("remise").setLibelle("Remise (En%)");
        pi.getFormu().getChamp("caution").setLibelle("Caution (En%)");
        pi.getFormu().getChamp("tva").setLibelle("Tva (En%)");
        pi.getFormu().getChamp("tva").setDefaut("0");
        pi.getFormu().getChamp("lieulocation").setLibelle("Lieu de location");
        pi.getFormu().getChamp("idReservation").setVisible(false);
        pi.getFormu().getChamp("numproforma").setVisible(false);
        pi.getFormu().getChamp("echeance").setVisible(false);
        pi.getFormu().getChamp("reglement").setVisible(false);
        pi.getFormu().getChamp("estPrevu").setVisible(false);
        if (request.getParameter("acte") != null && !request.getParameter("acte").equalsIgnoreCase("update")){
            pi.getFormu().getChamp("caution").setDefaut("50");
        }
        pi.getFormu().getChamp("dateprevres").setAutre(" onchange=\"majDaty(this)\" ");

        if(request.getParameter("idDmd")!=null && !request.getParameter("idDmd").isEmpty()){
            String idDmd = request.getParameter("idDmd");
            DmdPrix demandePrix = new DmdPrix();
            prerempli = (Proforma) demandePrix.genererProforma(idDmd, null);

        }
        ProformaDetails[] detFille = null;
        if(request.getParameter("id")!=null && !request.getParameter("id").isEmpty() && !request.getParameter("acte").equalsIgnoreCase("update")){
            Proforma pro = new Proforma();
            pro.setId(request.getParameter("id"));
            prerempli = (Proforma) pro.getProforma(null);
            if(prerempli!=null){
                ProformaDetails [] temp = (ProformaDetails[]) prerempli.getFilleProforma();
                detFille = new ProformaDetails[temp.length-1];
                for (int i = 0; i < temp.length; i++) {
                    if(temp[i].getIdProduit().compareToIgnoreCase(ConstanteLocation.id_produit_caution)!=0){
                        detFille[i] = temp[i];
                    }
                }
                prerempli.setIdOrigine(request.getParameter("id"));
            }
        }

        String idDevis = request.getParameter("idDevis");
       /*if(idDevis != null && !idDevis.isEmpty()){
            Devis devis = new Devis();
            devis.setId(idDevis);
            prerempli = (Proforma) devis.genererProforma(idDevis, null);
        }*/

//        Liste[] liste = new Liste[1];
//        Magasin m = new Magasin();
//        m.setNomTable("magasin");
//        liste[0] = new Liste("idMagasin",m,"val","id");
//        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idmagasinlib").setLibelle("Magasin");
        pi.getFormu().getChamp("idmagasinlib").setDefaut("Ankorahotra");
        pi.getFormu().getChamp("idmagasinlib").setAutre("readonly");
        pi.getFormu().getChamp("idMagasin").setDefaut("PNT000086");
        pi.getFormu().getChamp("idMagasin").setVisible(false);

        pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("iddemandeprixfille_0").setLibelle("Demande de prix");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("dimension_0").setLibelle("Dimension");
        //pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        //pi.getFormufle().getChamp("remise_0").setLibelle("Remise");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute; (en Jour)");
        pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("nombre_0").setLibelle("Quantit&eacute; (Article)");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (en %)");
        pi.getFormufle().getChamp("datedebut_0").setLibelle("Date de d&eacute;but");
        pi.getFormufle().getChamp("margemoins_0").setLibelle("Marge moins (R&eacute;cuperation)");
        pi.getFormufle().getChamp("margeplus_0").setLibelle("Marge plus (Retour)");
        pi.getFormufle().getChamp("image_0").setLibelle("Image");
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("margemoins").setVisible(false);
        pi.getFormufle().getChampMulitple("margeplus").setVisible(false);
        pi.getFormufle().getChampMulitple("dimension").setAutre("readOnly");

        //pi.getFormufle().getChampMulitple("remise").setVisible(false);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_MIMAGE","pu;compte_vente;libelle;tva;unite;image;durre","pu;compte;designation;tva;unite;image;dimension");
        affichage.Champ.setAutreHidden(pi.getFormufle().getChampFille("idProduit"), "onchange='reloadPage(event)'");
        for (int i = 0; i < pi.getNombreLigne(); i++) {
            pi.getFormufle().getChamp("id_"+i).setAutre("readonly");
            //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_LIB","id;puVente;desce","id;pu;designation");
            pi.getFormufle().getChamp("iddemandeprixfille_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            if (request.getParameter("acte") == null){
                pi.getFormufle().getChamp("margemoins_"+i).setDefaut("1");
                pi.getFormufle().getChamp("margeplus_"+i).setDefaut("1");
                pi.getFormufle().getChamp("nombre_"+i).setDefaut("1");
                pi.getFormufle().getChamp("qte_"+i).setDefaut("1");
            }
            //pi.getFormufle().getChamp("iddevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("tva_"+i).setAutre("readonly");
        }
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idDemandePrixFille"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idProforma"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idOrigine"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("puAchat"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("puVente"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("puRevient"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("tauxdechange"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("compte"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("tva"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("remise"),false);

        if(prerempli !=null && request.getParameter("idDmd")!=null && !request.getParameter("idDmd").isEmpty() && (acte == null || !acte.equalsIgnoreCase("update"))){
            String idDmd = request.getParameter("idDmd");

            pi.getFormu().setDefaut(prerempli);
//            pi.setDefautFille(prerempli.getFille("PROFORMA_DETAILS", null, ""));
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
            pi.getFormu().getChamp("datyPrevu").setDefaut(Utilitaire.dateDuJour());
            detFille = new DmdPrix().genererProformaDetails(idDmd, null);
            pi.setDefautFille(detFille);

        }else if(prerempli !=null && request.getParameter("id")!=null && !request.getParameter("id").isEmpty() && (acte == null || !acte.equalsIgnoreCase("update"))){
            pi.getFormu().setDefaut(prerempli);
//            pi.setDefautFille(prerempli.getFille("PROFORMA_DETAILS", null, ""));
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
            pi.getFormu().getChamp("datyPrevu").setDefaut(Utilitaire.dateDuJour());

            pi.setDefautFille(detFille);

        }
        String[] colOrdre = {"idproduit","designation","dimension","tva","nombre", "qte", "margemoins", "margeplus", "pu","remise","unite", "iddemandeprixfille", "compte","datedebut", "image"};
        pi.getFormufle().setColOrdre(colOrdre);

        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "proforma.Proforma";
        String classeFille = "proforma.ProformaDetails";
        String butApresPost = "vente/proforma/proforma-fiche.jsp";
        String colonneMere = "idProforma";

        String[] ordre = {"daty"};
        pi.getFormu().setOrdre(ordre);

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

        if(request.getParameter("acte")!=null){
            titre = "Modification Proforma";
            apres = "vente/proforma/apresModifier.jsp";
            acte = "modifier";
            butApresPost = "vente/proforma/proforma-fiche.jsp";
        }

%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <form class='container' action="<%=pi.getLien()%>?but=<%=apres%>" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="<%= acte %>">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>


</div>


<script>
(function() {
    function formatWithSpaces(value) {
        if (value === null || value === undefined || value === "") return "";

        // Convertir la valeur en chaîne et normaliser
        let str = String(value).replace(/\s/g, '').replace(',', '.');

        // Convertir en nombre flottant
        let num = parseFloat(str);
        if (isNaN(num)) return "";

        // Séparer la partie entière et la partie décimale
        let [intPart, decPart] = num.toString().split(".");

        // Ajouter les espaces comme séparateur de milliers
        const formattedInt = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, " ");

        // Si la partie décimale est absente ou égale à 0 → ne pas l'afficher
        if (!decPart || parseInt(decPart) === 0) {
            return formattedInt;
        }

        // Sinon, afficher la virgule et la partie décimale
        return `${formattedInt},${decPart}`;
    }


    function toRaw(value) {
    return String(value || '').replace(/\s/g, '').replace(',', '.');
  }

    function valeurChangee(mutations) {
        mutations.forEach(mutation => {
            if (mutation.type === 'attributes' && mutation.attributeName === 'value') {
                console.log("La valeur du hidden a changé :", mutation.target.value);
                const idClientlibelle = document.getElementById("idClientlibelle");
                localStorage.setItem('idCLient', mutation.target.value);
                localStorage.setItem('idClientlibelle', idClientlibelle.value);
                console.log(localStorage)
            }
        });
    }

    const observer = new MutationObserver(valeurChangee);

    const config = { attributes: true, attributeFilter: ['value'] };

    const hiddenElement = document.getElementById("idClient");
    observer.observe(hiddenElement, config);


    // Charger les valeurs du localStorage au chargement de la page
    window.onload = function() {
        if (localStorage.getItem("idCLient") !== null) {
            document.getElementById("idClientlibelle").value = localStorage.getItem("idClientlibelle");
            document.getElementById("idClient").value = localStorage.getItem("idCLient");
        }
        // Parcourir tous les éléments qui suivent un modèle d'ID
        let elements = document.querySelectorAll("[id^='idProduit']"); // Sélectionne tous les éléments dont l'ID commence par 'idClient'
        elements.forEach(element => {
            const id = element.id; // Récupère l'ID de l'élément
            const storedValue = localStorage.getItem(id); // Cherche la valeur correspondante dans le localStorage
            if (storedValue !== null) {
                element.value = storedValue; // Assigner la valeur sauvegardée à l'input
                document.getElementById(id+"libelle").value = storedValue;
                console.log(`Valeur récupérée pour ${id} depuis localStorage :`, storedValue);
            }
        });
    };

// Fonction pour gérer les changements de valeur
    function valeurChangeeP(mutations) {
        mutations.forEach(mutation => {
            if (mutation.type === 'attributes' && mutation.attributeName === 'value') {
                const inputElement = mutation.target;
                const id = inputElement.id; // Récupère l'ID de l'élément
                const newValue = inputElement.value;
                //const libelle = document.getElementById(id+"libelle");
                //console.log(libelle);
                //console.log(`La valeur du input ${id} a changé :`, newValue+libelle.value);

                // Enregistrer la nouvelle valeur dans localStorage
                localStorage.setItem(id, newValue);
            }
        });
    }

// Créer un MutationObserver pour observer les changements sur tous les éléments
    const observerP = new MutationObserver(valeurChangeeP);

// Paramètres d'observation
    const configP = { attributes: true, attributeFilter: ['value'] };

// Sélectionner tous les éléments avec un ID qui commence par 'idClient'
    let elementsP = document.querySelectorAll("[id^='idProduit']"); // Sélectionner tous les éléments dont l'ID commence par 'idClient'
    elementsP.forEach(element => {
        observerP.observe(element, configP); // Observer chaque élément
    });

  function applyFormat() {
    document.querySelectorAll('input[name^="pu_"]').forEach(inp => {
      if (!inp.dataset.bound) {
        inp.dataset.bound = "1";
        inp.style.textAlign = "right";

        inp.addEventListener('input', () => {
          const raw = toRaw(inp.value);
          inp.value = formatWithSpaces(raw);
        });

        inp.form?.addEventListener('submit', () => {
          document.querySelectorAll('input[name^="pu_"]').forEach(p => {
            p.value = toRaw(p.value);
          });
        });
      }

      const cur = inp.value.trim();

        console.log({cur})
      if (cur && cur !== formatWithSpaces(cur)) {
          console.log(formatWithSpaces(cur))
        inp.value = formatWithSpaces(cur);
      }
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    applyFormat();
    setInterval(applyFormat, 300);
  });
})();
</script>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>


<script>
    function majDaty(datyInput) {
        const valeur = datyInput.value;
        document.querySelectorAll('input[name^="datedebut"]').forEach(input => {
            input.value = valeur;
        });
    }
</script>



