$(function () {
    $('#brands th a, #brands .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#brands_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

    //AJAX State changer
    $('#brands td input[type=checkbox]').live("click", function () {
        var id = $('#hidden-'+this.id).attr('value');
        var url = '/admin/brand_states/'+id+'.js';

        $.ajax({
            type: "PUT",
            url: url,
            data: this.checked ? {state: 1 } : {}
        });
    });

});
