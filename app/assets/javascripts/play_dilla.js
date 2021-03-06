function playDilla() {
    // unhide the p container
    document.getElementById("video-container").style.display = "block";

    //add the source to the iframe (autoplaying YouTube video; originally uww2R-Cql1o but changed due to embed permissions)
    var video = document.getElementById("video");
    video.setAttribute("src","https://www.youtube.com/embed/videoseries?list=PL9dk_xtWpAkKXxzv_TfLWmlJj6G3quWQ2&autoplay=1");

    //scroll to just above the video

    videoPosition = video.getBoundingClientRect().top;

    window.scrollTo({
         top: videoPosition - 10,
         behavior: "smooth"
    });
}