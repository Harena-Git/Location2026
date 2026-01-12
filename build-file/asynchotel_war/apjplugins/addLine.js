

function add_line_tab(champ){
    var firstElement = document.getElementById("ajout_multiple_ligne").lastChild.innerHTML;
    var lastTr = $("#ajout_multiple_ligne tr:last");

    // Get the numeric ID from the last row
    var lastId = lastTr.attr('id'); // Gets 'ligne-multiple-9'
    var indiceNew = lastId ? parseInt(lastId.split('-')[2]) : -1; // Extracts 9 from 'ligne-multiple-9'
    indiceNew = indiceNew+1;
    // console.log("firstElement",firstElement)
    //var newElem = firstElement.toString().replaceAll(/(?<=[^0-9])0(?=[^0-9])/g, ''+indiceNew);
    var newElem = firstElement.replaceAll(/_[0-9]/g, '_' + indiceNew);
    newElem = newElem.replaceAll(/\([0-9]+\)/g, '('+ indiceNew+')');
    newElem = newElem.replaceAll(indiceNew+""+indiceNew, indiceNew);
    newElem = newElem.replaceAll(indiceNew+""+indiceNew+""+indiceNew, indiceNew);
    newElem = newElem.replaceAll(indiceNew+""+indiceNew+""+indiceNew+""+indiceNew, indiceNew);
    // console.log("newElen",newElem)
    $("#ajout_multiple_ligne").append("<tr id='ligne-multiple-"+indiceNew+"'>"+newElem+"</tr>");
    $("#nombreLigne").val(indiceNew+1);
}

function delete_line(lineId) {
    var taille = $("#ajout_multiple_ligne tr").length;
    if(taille>=2){
        var ligne = document.getElementById('ligne-multiple-' + lineId);
        if(ligne) {
            ligne.remove();
            var newCount = $("#ajout_multiple_ligne tr").length;
            $("#nombreLigne").val(newCount);
        }
    }
}

function add_line_tabs(champ){
    var firstElement = document.getElementById("ajout_multiple_ligne").lastChild.innerHTML;
    for(let i=0;i<10;i++){
         var lastTr = $("#ajout_multiple_ligne tr:last");
    
        // Get the numeric ID from the last row
        var lastId = lastTr.attr('id'); // Gets 'ligne-multiple-9'
        var indiceNew = lastId ? parseInt(lastId.split('-')[2]) : -1; // Extracts 9 from 'ligne-multiple-9'
        indiceNew = indiceNew+1;

        //var newElem = firstElement.replaceAll(/(?<=[^0-9])0(?=[^0-9])/g, (indiceNew+i));
        var newElem = firstElement.replaceAll(/_[0-9]/g, '_' + indiceNew);
        newElem = newElem.replaceAll(/\([0-9]+\)/g, '('+ indiceNew+')');
        newElem = newElem.replaceAll(indiceNew+""+indiceNew, indiceNew);
        newElem = newElem.replaceAll(indiceNew+""+indiceNew+""+indiceNew, indiceNew);
        newElem = newElem.replaceAll(indiceNew+""+indiceNew+""+indiceNew+""+indiceNew, indiceNew);
        $("#ajout_multiple_ligne").append("<tr id='ligne-multiple-"+(indiceNew)+"'>"+newElem+"</tr>");
        $("#nombreLigne").val(indiceNew+(1));
    }
}


