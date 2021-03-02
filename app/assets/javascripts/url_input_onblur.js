// credit: https://stackoverflow.com/questions/17946960/with-html5-url-input-validation-assume-url-starts-with-http/46451909#46451909
$(function(){
    $('input[type="url"]').on('blur', function(){
      var string = $(this).val();
      if (!string.match(/^https?:/) && string.length) {
        string = "https://" + string;
          $(this).val(string)
      }
    });
});