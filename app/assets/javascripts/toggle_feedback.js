$(document).ready(function(){
    // get elements
    var status_id_input = document.getElementById("application_status_id");
    var feedback_div = document.getElementById("feedback_container");

    // update feedback visibility on page load
    updateFeedbackVisibility(status_id_input, feedback_div);

    // and then every time the application status input changes
    $("#application_status_id").change(function(e){
        updateFeedbackVisibility(status_id_input, feedback_div);
    });
})

function updateFeedbackVisibility(status_id_input, feedback_div) {
    if (status_id_input.value == 6) {
        feedback_div.style.display = "block";
    } else {
        feedback_div.style.display = "none";
    }
}