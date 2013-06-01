$(function () {
    $('#users th a, #users .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#users_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

});