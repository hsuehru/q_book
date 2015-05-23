$(document).ready(function() {
        $('.ajax-load').click( function(){
            $('#content').load( $(this).attr("href") );
            $(window).scrollLeft("0");
            $(window).scrollTop("0");
            return false;
        });

    });
