document.addEventListener("turbolinks:load", function(){
    $("#dilla_button").click(function(e){
        // get the container
        var video_container = document.getElementById("video-container")

        // add a new br before the container
        var new_br = document.createElement("br");
        var main = document.getElementsByTagName("main")[0];
        main.insertBefore(new_br, video_container);

        // unhide the container
        video_container.style.display = "block";

        //add the source to the iframe (autoplaying YouTube video; originally uww2R-Cql1o but changed due to embed permissions)
        var video = document.getElementById("video");
        video.setAttribute("src","https://www.youtube.com/embed/videoseries?list=PL9dk_xtWpAkKXxzv_TfLWmlJj6G3quWQ2&autoplay=1");

        //scroll to just above the video

        videoPosition = video.getBoundingClientRect().top;

        window.scrollTo({
            top: videoPosition - 10,
            behavior: "smooth"
        });
    });
})