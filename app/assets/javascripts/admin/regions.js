$(function () {
    $('#regions th a, #regions .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#regions_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

    //AJAX State changer
    $('#regions td input[type=checkbox]').live("click", function () {
        var id = $('#hidden-'+this.id).attr('value');
        var url = '/admin/region_states/'+id+'.js';
        console.log(this.checked)
        $.ajax({
            type: "PUT",
            url: url,
            data: this.checked ? {state: 1 } : {}
        });
    });

});
