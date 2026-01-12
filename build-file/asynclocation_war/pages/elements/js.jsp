<!-- jQuery 2.1.4 -->

<!--<script src="${pageContext.request.contextPath}/assets/js/socket.io/socket.io.js"></script>-->
<script src="${pageContext.request.contextPath}/assets/js/moment.min.js"></script>


<!-- jQuery UI 1.11.4 -->
<script src="${pageContext.request.contextPath}/dist/js/jquery-ui.min.js" type="text/javascript"></script>
<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script type="text/javascript">
    $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.2 JS -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/bootstrap/js/dataTables.bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/bootstrap/js/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/bootstrap/js/jquery.tablesorter.min.js" type="text/javascript"></script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
<!-- Morris.js charts -->
<!--<script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="${pageContext.request.contextPath}/plugins/morris/morris.min.js" type="text/javascript"></script>-->
<!-- Sparkline -->
<!--<script src="${pageContext.request.contextPath}/plugins/sparkline/jquery.sparkline.min.js" type="text/javascript"></script>-->
<!-- jvectormap -->
<!--<script src="${pageContext.request.contextPath}/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/plugins/jvectormap/jquery-jvectormap-world-mill-en.js" type="text/javascript"></script>-->
<!-- jQuery Knob Chart -->
<!--<script src="${pageContext.request.contextPath}/plugins/knob/jquery.knob.js" type="text/javascript"></script>-->
<!-- daterangepicker -->
<!--<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.2/moment.min.js" type="text/javascript"></script>-->
<script src="${pageContext.request.contextPath}/plugins/daterangepicker/daterangepicker.js" type="text/javascript"></script>
<!-- datepicker -->
<script src="${pageContext.request.contextPath}/plugins/datepicker/bootstrap-datepicker.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/plugins/timepicker/bootstrap-timepicker.min.js" type="text/javascript"></script>
<!-- Bootstrap WYSIHTML5 -->
<!--<script src="${pageContext.request.contextPath}/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js" type="text/javascript"></script>-->
<!-- Slimscroll -->
<script src="${pageContext.request.contextPath}/plugins/slimScroll/jquery.slimscroll.min.js" type="text/javascript"></script>
<!-- FastClick -->
<script src="${pageContext.request.contextPath}/plugins/fastclick/fastclick.min.js" type="text/javascript"></script>
<!-- ChartJS 1.0.1 -->
<script src="${pageContext.request.contextPath}/assets/js/Chart.min.js" type="text/javascript"></script>
<%--<script src="${pageContext.request.contextPath}/plugins/chartjs/Chart.min.js" type="text/javascript"></script>--%>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js" type="text/javascript"></script>
<!-- AdminLTE dashboard demo (This is only for demo purposes) -->
<!--<script src="${pageContext.request.contextPath}/dist/js/pages/dashboard.js" type="text/javascript"></script>-->
<!-- AdminLTE dashboard demo (This is only for demo purposes) -->
<!--<script src="${pageContext.request.contextPath}/dist/js/pages/dashboard2.js" type="text/javascript"></script>-->
<!-- AdminLTE for demo purposes -->
<!--<script src="${pageContext.request.contextPath}/dist/js/demo.js" type="text/javascript"></script>-->
<!-- Parsley -->
<script src="${pageContext.request.contextPath}/plugins/parsley/src/i18n/fr.js"></script>
<script src="${pageContext.request.contextPath}/plugins/parsley/dist/parsley.min.js"></script>
<script src="${pageContext.request.contextPath}/plugins/sparkline/jquery.sparkline.min.js"></script>
<script src="${pageContext.request.contextPath}/plugins/bootstrap-notify/bootstrap-notify.min.js"></script>
<!-- chatbot -->
<script src="${pageContext.request.contextPath}/apjplugins/chat.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.mCustomScrollbar.concat.min.js"></script>

<script type="text/javascript">
    window.ParsleyValidator.setLocale('fr');
    $('.datepicker').datepicker({
        format: 'dd/mm/yyyy'
    });
//    $(".timepicker").timepicker({
//        showInputs: false
//    });

    $(window).bind("load", function () {
//        getMessageDeploiement();
//        window.setInterval(getMessageDeploiement, 30000);
    });

    function sauvegarderValeurs() {
        const inputs = document.querySelectorAll("input");
        inputs.forEach(input => {
            if (input.type === "checkbox") {
                sessionStorage.setItem(input.id, input.checked ? "true" : "false");
            } else {
                sessionStorage.setItem(input.id, input.value);
            }
        });
    }
    function restaurerValeurs() {
        if (sessionStorage.getItem("reloadFromBlur") === "true") {
            const inputs = document.querySelectorAll("input");
            inputs.forEach(input => {
                const val = sessionStorage.getItem(input.id);
                if (val !== null) {
                    if (input.type === "checkbox") {
                        input.checked = (val === "true");
                    } else {
                        input.value = val;
                        const imgEl = document.getElementById(input.id + "_img");
                        if (imgEl && imgEl.tagName.toLowerCase() === "img") {
                            imgEl.src = imgEl.src + val;
                        }
                    }
                }
            });
            sessionStorage.removeItem("reloadFromBlur");
        }
    }
    function reloadPage() {
        sessionStorage.setItem("reloadFromBlur", "true");
        sauvegarderValeurs();
        window.location.reload();
    }
    window.addEventListener("load", restaurerValeurs);

    function getMessageDeploiement() {
        var text = 'ok';
        $.ajax({
            type: 'GET',
            url: '${pageContext.request.contextPath}/MessageDeploiement',
            contentType: 'application/json',
            data: {'mes': text},
            success: function (ma) {
                if (ma != null) {
                    var data = JSON.parse(ma);
                    if (data.message != null) {
                        alert(data.message);
                    }
                    if (data.erreur != null) {
                        alert(data.erreur);
                    }
                }

            },
            error: function (e) {
                //alert("Erreur Ajax");
            }

        });
    }
    function ouvrirModal(event,contentUrl,modalCible)
    {
        event.preventDefault();
        document.getElementById("loader").style.display = "flex";
        fetch(contentUrl)
            .then(response => response.text())
            .then(html => {
                var contentElement = document.getElementById(modalCible);
                if (contentElement) {
                    contentElement.innerHTML = html;
                    $('#linkModal .content-wrapper').removeClass('content-wrapper');
                } else {
                    console.error("Élément avec ID '" + modalCible + "' non trouvé.");
                    return;
                }
                var modalElement = $('#linkModal');
                if (modalElement.length) {
                    modalElement.modal('show');
                    modalElement.css({
                        'opacity':'1',
                        'padding': '35rem 0px 0px 0px'
                    });
                } else {
                    console.error("Modal avec ID 'linkModal' non trouvé.");
                }
            })
            .catch(error => {
                console.error("Erreur de chargement:", error);
                var contentElement = document.getElementById(modalCible);
                if (contentElement) {
                    contentElement.innerHTML = "Erreur de chargement du contenu.";
                }
                var modalElement = $('#linkModal');
                if (modalElement.length) {
                    modalElement.modal('show');
                }
            })
            .finally(() => {
                // ✅ Cacher le loader après chargement ou erreur
                document.getElementById("loader").style.display = "none";
            });
    }
    function closeModal() {
        var modalElement = $('#linkModal');
        if (modalElement.length) {
            modalElement.modal('hide');
        } else {
            console.error("Modal avec ID 'linkModal' non trouvé.");
        }
    }
    function toggleRow(button,lienFille) {
        // Trouver la ligne suivante qui contient les détails à afficher/masquer
        var nextRow = button.parentNode.parentNode.nextElementSibling;
        // Vérifier si cette ligne a la classe "collapse"
        if (nextRow.classList.contains("collapse")) {
            // Si elle est masquée, on l'affiche
            nextRow.classList.remove("collapse");
            button.textContent = "-"; // Changer le bouton en "-" quand déplié
            var detailsElement = nextRow.querySelector('div');
            //detailsElement.innerHTML="Bonjourrrrrrrrrrrr "+detailsElement.id;
            var url='${pageContext.request.contextPath}/pages/moduleLeger.jsp?but='+button.id+detailsElement.id;
            console.log(url);
            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erreur de chargement de la page');}
                    return response.text(); // On récupère le texte HTML
                })
                .then(html => {
                    detailsElement.classList.add('details_collapse');
                    detailsElement.innerHTML = html;
                });

        } else {
            // Si elle est affichée, on la cache
            nextRow.classList.add("collapse");
            button.textContent = "+"; // Changer le bouton en "+" quand replié
        }
    }
    function insertAj(event)
    {
        event.preventDefault();
        var formData = new FormData(event.target);
        var req="";
        document.getElementById("loader").style.display = "flex";
        formData.forEach((value, key) => {
            req=req+'&'+key+"="+ value;
        });
        $.ajax({
            type:'GET',
            url:'${pageContext.request.contextPath}/ApresTarif?'+req,
            contentType: 'application/json',
            data:null,
            success:function(ma){
                if(ma.status==='error'){
                    alert(ma.message);
                    document.getElementById("loader").style.display = "none";
                }
                else
                {
                    var myDiv = document.getElementById("butjsp");
                    console.log(myDiv);
                    fetch(ma.butApres)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Erreur de chargement de la page');}
                            return response.text(); // On récupère le texte HTML
                        })
                        .then(html => {
                            myDiv.innerHTML = html;
                            //reinitializeLibelleFields()
                            //initAutocompleteIngredients()
                        })
                        .catch(error => {
                        console.error(error);
                        alert('Erreur lors du chargement des données.');
                        })
                        .finally(() => {
                            // ✅ Cacher le loader après chargement ou erreur
                            document.getElementById("loader").style.display = "none";
                        });

                }
            },
            error:function(ma){
                console.log(ma)
                alert(ma.message);
                document.getElementById("loader").style.display = "none";
            }
        })
    }
    function insertAjING(event)
    {
        event.preventDefault();
        var formData = new FormData(event.target);
        var req="";
        document.getElementById("loader").style.display = "flex";
        formData.forEach((value, key) => {
            req=req+'&'+key+"="+ value;
        });
        $.ajax({
            type:'GET',
            url:'${pageContext.request.contextPath}/ApresTarif?'+req,
            contentType: 'application/json',
            data:null,
            success:function(ma){
                if(ma.status==='error'){
                    alert(ma.message);
                    document.getElementById("loader").style.display = "none";
                }
                else
                {
                    var myDiv = document.getElementById("butjsp");
                    console.log(myDiv);
                    fetch(ma.butApres)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Erreur de chargement de la page');}
                            return response.text(); // On récupère le texte HTML
                        })
                        .then(html => {
                            myDiv.innerHTML = html;
                            reinitializeLibelleFields()
                            initAutocompleteIngredients()
                        })
                        .catch(error => {
                        console.error(error);
                        alert('Erreur lors du chargement des données.');
                        })
                        .finally(() => {
                            // ✅ Cacher le loader après chargement ou erreur
                            document.getElementById("loader").style.display = "none";
                        });

                }
            },
            error:function(ma){
                console.log(ma)
                alert(ma.message);
                document.getElementById("loader").style.display = "none";
            }
        })
    }
    function cleanScriptWrappers(script) {
        // Remove first line (jQuery wrapper start)
        const withoutFirstLine = script.replace(
            /^jQuery\(document\)\.ready\(function\s*\(\)\s*\{\$\(function\(\)\s*\{\s*[\r\n]*/,
            ''
        );

        // Remove last line (jQuery wrapper end)
        const withoutWrappers = withoutFirstLine.replace(
            /[\s\r\n]*\}\);\}\);\s*$/,
            ''
        );

        return withoutWrappers;
    }

    function findInlineScriptByKeyword() {
        const scripts = document.getElementsByTagName('script');
        let targetScript;

        for (let i = 0; i < scripts.length; i++) {
            if (scripts[i].textContent.includes('.autocomplete(')) {
                targetScript = scripts[i].textContent;
                return cleanScriptWrappers(targetScript)
            }
        }
    }
    function initAutocompleteIngredients() {
        console.log(findInlineScriptByKeyword())
        // return findInlineScriptByKeyword()

        var autocompleteTriggered = false;
        $("#idingredientslibelle").autocomplete({
            source: function(request, response) {
                $("#idingredients").val('');
                if (autocompleteTriggered) {
                    fetchAutocomplete(request, response, "null", "id", "null", "as_ingredients_lib", "produits.IngredientsLib", "true","unite");
                }
            },
            select: function(event, ui) {
                $("#idingredientslibelle").val(ui.item.label);
                $("#idingredients").val(ui.item.value);
                $("#idingredients").trigger('change');
                $(this).autocomplete('disable');
                var champsDependant = ['unite'];   for(let i=0;i<champsDependant.length;i++){
                    $(`#${champsDependant[i]}`).val(ui.item.retour.split(';')[i]);
                }            autocompleteTriggered = false;
                return false;
            }
        }).autocomplete('disable');
        $("#idingredientslibelle").keydown(function(event) {
            if (event.key === 'Tab') {
                event.preventDefault();
                autocompleteTriggered = true;
                $(this).autocomplete('enable').autocomplete('search', $(this).val());
            }
        });
        $("#idingredientslibelle").on('input', function() {
            $("#idingredients").val('');
            autocompleteTriggered = false;
            $(this).autocomplete('disable');
        });
        $("#idingredientssearchBtn").click(function() {
            autocompleteTriggered = true;
            $("#idingredientslibelle").autocomplete('enable').autocomplete('search', $("#idingredientslibelle").val());
        });

        $("#idingredientslibelle").autocomplete({
            source: function(request, response) {
                $("#idingredients").val('');
                if (autocompleteTriggered) {
                    fetchAutocomplete(
                        request, response, "null", "id", "null",
                        "as_ingredients_lib", "produits.IngredientsLib",
                        "true", "unite"
                    );
                }
            },
            select: function(event, ui) {
                $("#idingredientslibelle").val(ui.item.label);
                $("#idingredients").val(ui.item.value);
                $("#idingredients").trigger('change');
                $(this).autocomplete('disable');

                const champsDependant = ['unite'];
                for (let i = 0; i < champsDependant.length; i++) {
                    $(`#${champsDependant[i]}`).val(ui.item.retour.split(';')[i]);
                }

                autocompleteTriggered = false;
                return false;
            }
        }).autocomplete('disable');

        $("#idingredientslibelle")
            .off('keydown.autocomplete')
            .on('keydown.autocomplete', function(event) {
                if (event.key === 'Tab') {
                    event.preventDefault();
                    autocompleteTriggered = true;
                    $(this).autocomplete('enable').autocomplete('search', $(this).val());
                }
            });

        $("#idingredientslibelle")
            .off('input.autocomplete')
            .on('input.autocomplete', function() {
                $("#idingredients").val('');
                autocompleteTriggered = false;
                $(this).autocomplete('disable');
            });

        $("#idingredientssearchBtn")
            .off('click.autocomplete')
            .on('click.autocomplete', function() {
                autocompleteTriggered = true;
                $("#idingredientslibelle")
                    .autocomplete('enable')
                    .autocomplete('search', $("#idingredientslibelle").val());
            });
    }

    function reinitializeLibelleFields() {
        $('input[id*="libelle"]').each(function() {
            $(this).addClass('ui-autocomplete-input')
                .attr('autocomplete', 'off')
                .attr('tabindex', '1');
        });
        $("#ui-id-1").empty();

    }
    function modifEtatMult(event)
    {
        event.preventDefault();
        var formData = new FormData(event.target);
        var req="";
        document.getElementById("loader").style.display = "flex";
        $.ajax({
            type:'POST',
            url:'${pageContext.request.contextPath}/ApresMultiple',
            contentType: false,
            data:formData,
            processData:false,
            success:function(ma){
                if(ma.status==='error'){
                    alert(ma.message);
                    document.getElementById("loader").style.display = "none";
                }
                else
                {
                    var myDiv = document.getElementById("butjsp");
                    fetch(ma.butApres)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Erreur de chargement de la page');}
                            return response.text(); // On récupère le texte HTML
                        })
                        .then(html => {
                            myDiv.innerHTML = html;
                            reinitializeLibelleFields()
                            initAutocompleteIngredients()
                        })
                        .catch(error => {
                        console.error(error);
                        alert('Erreur lors du chargement des données.');
                        })
                        .finally(() => {
                            // ✅ Cacher le loader après chargement ou erreur
                            document.getElementById("loader").style.display = "none";
                        });

                }
            },
            error:function(ma){
                console.log(ma)
                alert(ma.message);
                document.getElementById("loader").style.display = "none";
            }
        })
    }

    function pagePopUp(page, width, height) {
        w = 750;
        h = 600;
        t = "D&eacute;tails";

        if (width != null || width == "")
        {
            w = width;
        }
        if (height != null || height == "") {
            h = height;
        }
        window.open(page, t, "titulaireresizable=no,scrollbars=yes,location=no,width=" + w + ",height=" + h + ",top=0,left=0");
    }
    function searchKeyPress(e)
    {
        // look for window.event in case event isn't passed in
        e = e || window.event;
        if (e.keyCode == 13)
        {
            document.getElementById('btnListe').click();
            return false;
        }
        return true;
    }
    function back() {
        history.back();
    }
    function dependante(valeurFiltre,champDependant,nomTable,nomClasse,nomColoneFiltre,nomColvaleur,nomColAffiche)
    {
        console.out.println("NIDITRA TATO");
        document.getElementById(champDependant).length=0;
        var param = {'valeurFiltre':valeurFiltre,'nomTable':nomTable,'nomClasse':nomClasse,'nomColoneFiltre':nomColoneFiltre,'nomColvaleur':nomColvaleur,'nomColAffiche':nomColAffiche};
        var lesValeur=[new Option("-","",false,false)];  
        $.ajax({
            type:'GET',
            url:'/prospection/deroulante',
            contentType: 'application/json',
            data:param,
            success:function(ma){
                var data = JSON.parse(ma);   
                
                for(i in data.valeure)
                {
                    lesValeur.push(new Option(data.valeure[i].valeur, data.valeure[i].id, false, false));
                }
                addOptions(champDependant,lesValeur);
            },
            error:function(ma){
                console.log(ma);
            }
        });


    }
    function getChoix() {
        setTimeout("document.frmchx.submit()", 800);
    }
    $('#sigi').DataTable({
        "paging": false,
        "lengthChange": false,
        "searching": false,
        "ordering": true,
        "info": false,
        "autoWidth": false
    });
    $(function () {
        $(".select2").select2();
        $("#example1").DataTable();
        $('#example2').DataTable({
            "paging": true,
            "lengthChange": false,
            "searching": false,
            "ordering": true,
            "info": true,
            "autoWidth": false
        });
    });
    function CocheToutCheckbox(ref, name) {
        var form = ref;

        while (form.parentNode && form.nodeName.toLowerCase() != 'form') {
            form = form.parentNode;
        }

        var elements = form.getElementsByTagName('input');

        for (var i = 0; i < elements.length; i++) {
            if (elements[i].type == 'checkbox' && elements[i].name == name) {
                elements[i].checked = ref.checked;
            }
        }
    }
    function showNotification(message, classe, url) {
        $.notify({
            message: message,
            url: url
        }, {
            type: classe
        });
    }
    function add_line() {
        var indexMultiple = document.getElementById('indexMultiple').value;
        var nbrLigne = document.getElementById('nbrLigne').value;
        var html = genererLigneFromIndex(indexMultiple);
        $('#ajout_multiple_ligne').append(html);
        document.getElementById('indexMultiple').value = parseInt(indexMultiple) + 1;
        document.getElementById('nbrLigne').value = parseInt(nbrLigne) + 1;
    }
    function removeLineByIndex(iLigne) {
        var nomId = "ligne-multiple-" + iLigne;

        var ligne = document.getElementById(nomId);
        ligne.parentNode.removeChild(ligne);
        var nbrLigne = document.getElementById('nbrLigne').value;
        //document.getElementById('nbrLigne').value = nbrLigne - 1;
    }

    function getHtmlTabeauLigne() {
        var htmlComplet = $('#tableauLigne').html();
        document.getElementById('htmlComplet').value = htmlComplet;
        $('#declarationFormulaire').submit();


    }

    function changeInput(input) {
//        alert(input.id);
//        document.getElementById(input.id).value = ;
        $('#' + input.id).attr('value', input.value);
    }
    function dependante(valeurFiltre, champDependant, nomTable, nomClasse, nomColoneFiltre, nomColvaleur, nomColAffiche)
    {
        document.getElementById(champDependant).length = 0;
        var param = {'valeurFiltre': valeurFiltre, 'nomTable': nomTable, 'nomClasse': nomClasse, 'nomColoneFiltre': nomColoneFiltre, 'nomColvaleur': nomColvaleur, 'nomColAffiche': nomColAffiche};
        var lesValeur=[new Option("-","",false,false)];  
        $.ajax({
            type: 'GET',
            url: '/prospection/deroulante',
            contentType: 'application/json',
            data: param,
            success: function (ma) {
                var data = JSON.parse(ma);

                for (i in data.valeure)
                {
                    lesValeur.push(new Option(data.valeure[i].valeur, data.valeure[i].id, false, false));
                }
                addOptions(champDependant, lesValeur);
            }
        });


    }
    function addOptions(nomListe, lesopt)
    {
        var List = document.getElementById(nomListe);
        var elOption = lesopt;

        var i, n;
        n = elOption.length;

        for (i = 0; i < n; i++)
        {
            List.options.add(elOption[i]);
        }
    }
    function dependanteChamp(valeurFiltre, champDependant, nomTable, nomClasse, nomColoneFiltre, nomColvaleur, nomColAffiche, nomOrderby, sensOrderBy)
    {
        $('#' + champDependant + " option").remove();
        var param = {'valeurFiltre': valeurFiltre, 'nomTable': nomTable, 'nomClasse': nomClasse, 'nomColoneFiltre': nomColoneFiltre, 'nomColvaleur': nomColvaleur, 'nomColAffiche': nomColAffiche, 'nomOrderby': nomOrderby, 'sensOrderBy': sensOrderBy};
        var valeur = "";
        $.ajax({
            type: 'GET',
            url: '/spat/deroulante',
            contentType: 'application/json',
            data: param,
            success: function (ma) {
                var data = JSON.parse(ma);

                for (i in data.valeure)
                {
                    valeur += data.valeure[i].valeur;
                }
                console.log(valeur);
                addChamp(champDependant, valeur);
            }
        });


    }

    function addChamp(nomListe, valeur)
    {
        document.getElementById(nomListe).value = valeur;

    }
    function dependanteChampUneValeur(valeurFiltre, champDependant, nomTable, nomClasse, nomColoneFiltre, nomColvaleur, nomColAffiche, nomOrderby, sensOrderBy)
    {
        $('#' + champDependant + " option").remove();
        var param = {'valeurFiltre': valeurFiltre, 'nomTable': nomTable, 'nomClasse': nomClasse, 'nomColoneFiltre': nomColoneFiltre, 'nomColvaleur': nomColvaleur, 'nomColAffiche': nomColAffiche, 'nomOrderby': nomOrderby, 'sensOrderBy': sensOrderBy};
        var valeur = "";
        $.ajax({
            type: 'GET',
            url: '/spat/deroulante?estListe=false',
            contentType: 'application/json',
            data: param,
            success: function (ma) {
                var data = JSON.parse(ma);

                for (i in data.valeure)
                {
                    valeur += data.valeure[i].valeur;
                }
                addChamp(champDependant, valeur);
            }
        });


    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/script.js" type="text/javascript"></script>

<script src="${pageContext.request.contextPath}/assets/js/controleTj.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/apjplugins/champcalcul.js" defer></script>

<script src="${pageContext.request.contextPath}/assets/js/soundmanager2-jsmin.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/assets/js/messagews.js" type="text/javascript"></script>
<script type="text/javascript">
    if (typeof (Storage) !== "undefined") {
        // Code for localStorage/sessionStorage.
        var collapse = localStorage.getItem("menuCollapse");

    } else {
        // Sorry! No Web Storage support..
    }
    $(document).ready(function () {

        if (localStorage.getItem("menuCollapse") == "true") {
            $("body").addClass("sidebar-collapse");
        }

        $(".sidebar-toggle").click(function () {
            if (localStorage.getItem("menuCollapse") == "false" || localStorage.getItem("menuCollapse") == "") {
                localStorage.setItem("menuCollapse", "true");
            } else {
                localStorage.setItem("menuCollapse", "false");
            }
        });

        //TAB INDEX
        var tab = $("[tabindex]");
        for (var i = 0; i < tab.length; i++) {
            $(tab[i]).removeAttr("tabindex");
        }
        var nombre_form = $($("form")[1]).length;

        for (var f = 0; f < nombre_form; f++) {
            var id_index = 1;

            var new_elm = $($("form")[1])[f];

            for (var i = 0; i < new_elm.length; i++) {
                if ($(new_elm[i]).context.type === "hidden" || $(new_elm[i]).context.readOnly) {

                } else {
                    $(new_elm[i]).attr("tabindex", id_index);
                    id_index++;
                }

            }
        }

    });
		
		
		
		
		function fetchAutocomplete(request, response, affiche, valeur, colFiltre, nomTable, classe,useMocle,champRetour) {
		if (request.term.length >= 1) {
				$.ajax({
						url: "/asynclocation/autocomplete",
						method: "GET",
						contentType: "application/x-www-form-urlencoded",
						dataType: "json",
						data: {
								libelle: request.term,
								affiche: affiche,
								valeur: valeur,
								colFiltre: colFiltre,
								nomTable: nomTable,
								classe: classe,
								useMotcle:useMocle,
                                champRetour: champRetour
						},
						success: function(data) {
								response($.map(data.valeure, function(item) {
										return {
												label: item.valeur,
												value: item.id,
                                                retour: item.retour
										};
								}));
						}
				});
		}
		}
    function fetchAutocomplete(request, response, affiche, valeur, colFiltre, nomTable, classe,useMocle,champRetour,ac_Where) {
        if (request.term.length >= 1) {
            $.ajax({
                url: "/asynclocation/autocomplete",
                method: "GET",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                data: {
                    libelle: request.term,
                    affiche: affiche,
                    valeur: valeur,
                    colFiltre: colFiltre,
                    nomTable: nomTable,
                    classe: classe,
                    useMotcle:useMocle,
                    champRetour: champRetour,
                    ac_Where:ac_Where
                },
                success: function(data) {
                    response($.map(data.valeure, function(item) {
                        return {
                            label: item.valeur,
                            value: item.id,
                            retour: item.retour
                        };
                    }));
                }
            });
        }
    }

    function synchro(champ,champCheck)
    {
        // var vraiNom=champ.name.substring(9);
        let checkboxes = document.querySelectorAll('input[name="ids"]');
        checkboxes.forEach((checkbox) => {
            if(checkbox.id===champCheck) {
                checkbox.checked = true;
            }
        });
    }

    function autoCompleteDyn(inputID, table, classe, champRetour,valeur) {
        let input = document.getElementById(inputID);
        if (!input) {
            return;
        }
        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === 'Tab') {
                event.preventDefault();
                let prest = input.value;
                if (prest != null && prest.trim() !== "") {
                    let temp = prest.split("::");
                    input.value = temp[0].trim();
                }
            } else {

                $('#' + inputID).autocomplete({
                    source: function (request, response) {
                        fetchAutocomplete(request, response, "null", valeur, "null", table, classe, "true",champRetour,"null");
                    },
                    minLength: 0,
                    select: function (event, ui) {
                        let selectedObj = ui.item;
                        let prest = selectedObj.value;
                        let temp = prest.split("::");
                        let compte = temp[0].trim();
                        $('#' + inputID).val(compte);
                        console.log("SelectedObj"+selectedObj);
                    }
                });
            }
        });
    }

    function afficherModalConfirmation(targetUrl) {
        var message = 'Confirmer cette action ?';
        $('#confirmationMessage').text(message);
        var modal = $('#confirmationModal');

        modal.attr('style', '');
        $('.modal-dialog').attr('style', '');
        $('.modal-content').attr('style', '');

        $('.modal-content').css({
            'border-radius': '2px',
            'box-shadow': '0 5px 15px rgba(0, 0, 0, 0.5)'
        });

        modal.css({
            'transition': 'opacity 0.3s ease-in-out'
        });

        $('#confirmActionBtn').off('click');
        $('.modal-footer .btn-default').off('click');
        $('.modal-header .close').off('click');

        // action apres btn confirmer
        $('#confirmActionBtn').on('click', function() {
            fadeOutModal(modal);
            if (targetUrl) {
                setTimeout(function() {
                    window.location.href = targetUrl;
                }, 300); // Match the transition duration
            } else {
                console.error("Target URL inexistant");
            }
        });

        $('.modal-footer .btn-default').on('click', function() {
            fadeOutModal(modal);
        });

        $('.modal-header .close').on('click', function() {
            fadeOutModal(modal);
        });

        modal.on('click', function(e) {
            if ($(e.target).is(modal)) {
                fadeOutModal(modal);
            }
        });

        $('.modal-backdrop').css({
            'transition': 'opacity 0.3s ease-in-out'
        });

        modal.modal('show');

        setTimeout(function() {
            $('.modal-dialog').css({
                'margin': '0 auto',
                'max-width': '500px',
                'width': '90%'
            });

            var windowHeight = $(window).height();
            var modalHeight = $('.modal-dialog').height();
            var marginTop = Math.max(30, (windowHeight - modalHeight) / 2);

            $('.modal-dialog').css({
                'margin-top': marginTop + 'px'
            });

            modal.addClass('in').css('opacity', '1');
            $('.modal-backdrop').addClass('in').css('opacity', '0.5');
        }, 100);

        function fadeOutModal(modal) {
            modal.css('opacity', '0');
            $('.modal-backdrop').css('opacity', '0');
            setTimeout(function() {
                modal.modal('hide');
            }, 300);
        }
    }

    function loadPage(url, containerIds = [], onError = () => {}, onFinally = () => {toggleLoader(false)}) {
        toggleLoader(true);
        fetch(url)
            .then(res => {
                if (!res.ok) throw new Error('Erreur de chargement');
                return res.text();
            })
            .then(html => {
                const doc = new DOMParser().parseFromString(html, 'text/html');
                containerIds.forEach(id => {
                    const src = doc.getElementById(id);
                    const dst = document.getElementById(id);
                    if (src && dst) {
                        dst.innerHTML = src.innerHTML;
                        src.querySelectorAll('script').forEach(s => {
                            const script = document.createElement('script');
                            script.text = s.textContent;
                            dst.appendChild(script);
                        });
                    } else console.error(`#${id} introuvable`);
                });
            })
            .catch(onError)
            .finally(onFinally)
    }
    function toggleLoader(show) {
        const loader = document.getElementById('loader');
        if (loader) loader.style.display = show ? 'flex' : 'none';
    }
    function toQueryString (data) {
        if (data instanceof FormData) {
            return new URLSearchParams(data).toString();
        }
        return Object.entries(data)
            .map(([k, v]) => encodeURIComponent(k) + '=' + encodeURIComponent(v))
            .join('&');
    }

    function request ({ method = 'GET', url = '', data = null, json = false, onSuccess = (response) => {}, onError = (error) => {}, onFinally = () => {}}) {
        const opts = { method };
        let fullUrl = url;
        toggleLoader(true);

        if (method.toUpperCase() === 'GET' && data) {
            const qs = toQueryString(data);
            fullUrl += (url.includes('?') ? '&' : '?') + qs;
        } else if (data) {
            if (json) {
                opts.headers = { 'Content-Type': 'application/json' };
                opts.body = JSON.stringify(data);
            } else if (data instanceof FormData) {
                opts.body = data;
            }
        }

        fetch(fullUrl, opts)
            .then(async res => {
                const payload = await res.json().catch(() => null);
                if (!res.ok || (payload && payload.status === 'error')) {
                    throw payload || new Error(res.statusText);
                }
                return payload;
            })
            .then(onSuccess)
            .catch(onError)
            .finally(onFinally)
    }

    function loadTarifGet(event, rajoutLien, containerIds = [], rajoutLienApres) {
        if (event) event.preventDefault();
        request({
            method: 'GET',
            url: `${pageContext.request.contextPath}/ApresTarif?0=0` + rajoutLien,
            onSuccess: ma => loadPage(
                ma.butApres + (rajoutLienApres ? rajoutLienApres : ''),
                containerIds,
                err => {
                    alert(err.message || 'Erreur loadTarifGet');
                    console.error(err);
                    toggleLoader(false);
                }
            ),
            onError: err => {
                alert(err.message || 'Erreur loadTarifGet');
                console.error(err);
                toggleLoader(false);
            }
        });
    }

</script>
<script language="javascript">
    (function ($) {
        var title = ($('h1:first').text());
        if (title === '' || title == null)
            title = ($('h2:first').text());
        if (title === '' || title == null)
            title = 'ERP';
        document.title = title;
    }(jQuery));
</script>
<!-- Calculcate min-height of content-wrapper -->
<script src="${pageContext.request.contextPath}/dist/js/content-wrapper.js"></script>