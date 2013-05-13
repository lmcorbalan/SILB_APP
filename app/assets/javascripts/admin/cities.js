$(function () {
    $('#cities th a, #cities .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#cities_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

    //AJAX State changer
    $('#cities td input[type=checkbox]').live("click", function () {
        var id = $('#hidden-'+this.id).attr('value');
        var url = '/admin/city_states/'+id+'.js';
        console.log(this.checked)
        $.ajax({
            type: "PUT",
            url: url,
            data: this.checked ? {state: 1 } : {}
        });
    });

});

