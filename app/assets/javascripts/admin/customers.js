$(function () {
    $('#customers th a, #customers .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#customers_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });

});
