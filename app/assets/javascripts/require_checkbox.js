// credit: https://stackoverflow.com/questions/35541816/disable-submit-button-until-atleast-one-checkbox-is-checked/35542213#35542213
$(function(){
    $("#search-results-form").on("change", "input", function(e){
        status=($("#search-results-form").find("input:checked").length==0)?"disabled":"";
        $(":submit").prop("disabled", status);
    })    
})