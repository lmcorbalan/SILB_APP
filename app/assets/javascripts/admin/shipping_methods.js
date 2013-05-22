$(function () {
    $('#shipping_methods th a, #shipping_methods .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#shipping_methods_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

    //AJAX State changer
    $('#shipping_methods td input[type=checkbox]').live("click", function () {
        var id = $('#hidden-'+this.id).attr('value');
        var url = '/admin/shipping_method_states/'+id+'.js';
        console.log(this.checked)
        $.ajax({
            type: "PUT",
            url: url,
            data: this.checked ? {state: 1 } : {}
        });
    });

});
