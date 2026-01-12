<%@page import="utils.ConstanteStation"%>
<%@page import="affichage.*"%>
<%@page import="caisse.MvtCaisse"%>
<%@page import="caisse.Caisse"%>
<%@page import="user.*"%>
<%@page import="bean.*"%>
<%@page import="proforma.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%


    try{

        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        MvtCaisse mouvement = new MvtCaisse();
        String idProforma = request.getParameter("idProforma");
        MvtCaisse mvtCaisse = new MvtCaisse();
        if (idProforma != null && !idProforma.equalsIgnoreCase("")) {
            ProformaLib pr = new ProformaLib();
            pr.setId(idProforma);
            mvtCaisse =  pr.genererMvtCaisseEntree(null);
        }
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);


        affichage.Champ[] liste = new affichage.Champ[1];
//        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        Caisse c = new Caisse();
        //c.setIdPoint(ConstanteStation.getFichierCentre());
        liste[0] = new Liste("idCaisse",c,"val","id");
        TypeObjet tpmdp=new TypeObjet();
//        tpmdp.setNomTable("modepaiement");
//        liste[1] = new Liste("idmodepaiement",tpmdp,"val","id");

        pageInsert.getFormu().changerEnChamp(liste);
        pageInsert.getFormu().getChamp("designation").setDefaut("Paiement du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("idDevise").setAutre("readonly");
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("taux").setVisible(false);
        pageInsert.getFormu().getChamp("idmodepaiement").setLibelle("Mode de paiement");
        pageInsert.getFormu().getChamp("idmodepaiement").setVisible(false);
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setVisible(false);
        pageInsert.getFormu().getChamp("idTiers").setPageAppelComplete("client.Client","id","Client");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelInsert("client/client-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageInsert.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageInsert.getFormu().getChamp("credit").setLibelle("Montant");
        pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        pageInsert.getFormu().getChamp("compte").setDefaut("530000");
        pageInsert.getFormu().getChamp("compte").setVisible(false);
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("idProforma").setLibelle("ID Proforma");
        pageInsert.getFormu().getChamp("idProforma").setAutre("readonly");
        if (mvtCaisse != null)
        {
            pageInsert.getFormu().setDefaut(mvtCaisse);
            pageInsert.getFormu().getChamp("idTiers").setVisible(false);
            pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
            pageInsert.getFormu().getChamp("idDevise").setVisible(false);
            pageInsert.getFormu().getChamp("idPrevision").setVisible(false);
        }
        pageInsert.getFormu().setOrdre(new String[]{"daty"});
        pageInsert.getFormu().getChamp("daty").setDefaut(utilitaire.Utilitaire.dateDuJour());
        String classe = "caisse.MvtCaisse";
        String nomTable = "MOUVEMENTCAISSE";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();

%>

    <div class="content-wrapper">
        <h1 align="center">Saisie du mouvement de caisse entr&eacute;e</h1>
        <form action="<%=pageInsert.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
            <%
                out.println(pageInsert.getFormu().getHtmlInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classe %>">
            <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
        </form>
    </div>
<script>
    // Fonction pour formater le nombre avec séparateur de milliers
    function formaterMontant(nombre) {
        // Enlever tous les espaces existants
        let valeur = nombre.toString().replace(/\s/g, '');

        // Séparer partie entière et décimale
        let parties = valeur.split('.');
        let partieEntiere = parties[0];
        let partieDecimale = parties[1];

        // Ajouter le séparateur d'espace tous les 3 chiffres
        partieEntiere = partieEntiere.replace(/\B(?=(\d{3})+(?!\d))/g, ' ');

        // Recombiner
        return partieEntiere + (partieDecimale ? '.' + partieDecimale : '');
    }

    // Fonction pour nettoyer le montant (enlever les espaces)
    function nettoyerMontant(valeur) {
        return valeur.replace(/\s/g, '');
    }

    // Attendre que le DOM soit chargé
    document.addEventListener('DOMContentLoaded', function() {
        // Récupérer le champ credit (Montant)
        let champCredit = document.querySelector('input[name="credit"]');

        if (champCredit) {
            // Formater la valeur initiale si elle existe
            if (champCredit.value && champCredit.value !== '') {
                champCredit.value = formaterMontant(champCredit.value);
            }

            // Formater lors de la saisie
            champCredit.addEventListener('input', function(e) {
                let cursorPosition = e.target.selectionStart;
                let ancienneValeur = e.target.value;
                let valeurNettoyee = nettoyerMontant(e.target.value);

                // Vérifier que c'est un nombre valide
                if (valeurNettoyee === '' || !isNaN(valeurNettoyee)) {
                    let nouvelleValeur = valeurNettoyee !== '' ? formaterMontant(valeurNettoyee) : '';
                    e.target.value = nouvelleValeur;

                    // Ajuster la position du curseur
                    let diff = nouvelleValeur.length - ancienneValeur.length;
                    e.target.setSelectionRange(cursorPosition + diff, cursorPosition + diff);
                }
            });

            // Nettoyer avant la soumission du formulaire
            champCredit.form.addEventListener('submit', function(e) {
                champCredit.value = nettoyerMontant(champCredit.value);
            });
        }
    });
let btn = Array.from(document.getElementsByTagName("button"))
               .find(b => b.textContent.trim() === "Enregistrer");

if (btn) btn.textContent = "Enregistrer et valider";
</script>
<%

    }catch(Exception e){

        e.printStackTrace();
    }

%>
