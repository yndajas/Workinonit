$(function(){
    $('#user_company_information_form').on('keyup change paste', 'input, textarea', function(){
        var website_element = website_element || document.querySelector("input[type=url]");
        var notes_element = notes_element || document.querySelector("textarea");
        if (website_element.value.length > 0 || notes_element.value.length > 0) {
            status = "";
        } else {
            status = "disabled";
        }
        $(":submit").prop("disabled", status);
    })
})