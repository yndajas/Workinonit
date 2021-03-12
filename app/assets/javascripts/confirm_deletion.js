document.addEventListener("turbolinks:load", function(){
    $("#delete_record").submit(function(e){
        var model = e.target.className.replace("edit_", "").replace(/ .*/, "")

        switch(model) {
            case "user":
                var message = "deleting your account cannot be undone. You will lose all data, including saved jobs and applications.\n\nAre you sure you wish to delete your account and all associated data?";
                break;
            case "job":
                var message = "deleting a job cannot be undone. Deleting a job will also delete any associated application data.\n\nAre you sure you wish to delete this job?";
                break;
            case "application":
                // check if action ends 'feedback'
                if (e.target.action.substring(e.target.action.length - 8, e.target.action.length) == "feedback") {
                    var message = "deleting feedback cannot be undone.\n\nAre you sure you wish to delete this feedback?";
                    break;    
                } else {
                    var message = "deleting an application cannot be undone.\n\nAre you sure you wish to delete this application?";
                    break;    
                }
            case "user_company_information":
                var message = "deleting company information cannot be undone.\n\nAre you sure you wish to delete this company information?";
                break;
            }

        return confirm(`Warning: ${message}`);
        e.preventDefault();
    });
})