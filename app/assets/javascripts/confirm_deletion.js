$(document).ready(function(){
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
                var message = "deleting an application cannot be undone.\n\nAre you sure you wish to delete this application?";
                break;
            }

        return confirm(`Warning: ${message}`);
        e.preventDefault();
    });
})