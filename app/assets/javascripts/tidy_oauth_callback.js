// removes '#_=_' from Facebook callback; credit: https://stackoverflow.com/questions/7131909/facebook-callback-appends-to-return-url/7297873#7297873
if (window.location.hash && window.location.hash == '#_=_') {
    if (window.history && history.pushState) {
        window.history.pushState("", document.title, window.location.pathname);
    } else {
        // Prevent scrolling by storing the page's current scroll offset
        var scroll = {
            top: document.body.scrollTop,
            left: document.body.scrollLeft
        };
        window.location.hash = '';
        // Restore the scroll offset, should be flicker free
        document.body.scrollTop = scroll.top;
        document.body.scrollLeft = scroll.left;
    }
}

// removes '#' from Google callback (own code)
var last_character_index = window.location.href.length - 1
var last_character = window.location.href.charAt(last_character_index)

if (last_character == '#') {
    window.location.href = window.location.href.substring(0, last_character_index)
}