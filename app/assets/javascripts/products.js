$(function () {
    $('#catalog .pagination a').live("click", function () {
        $.getScript(this.href);
        return false;
    });

    $('#catalog_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });
});