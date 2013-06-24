$(function () {
    $('#products th a, #products .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#products_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

    //AJAX State changer
    $('#products td input[type=checkbox]').live("click", function () {
        var id = $('#hidden-'+this.id).attr('value');
        var url = '/admin/product_states/'+id+'.js';
        console.log(this.checked)
        $.ajax({
            type: "PUT",
            url: url,
            data: this.checked ? {state: 1 } : {}
        });
    });

});
