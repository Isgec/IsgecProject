$().ready(function () {
    $.ajax({
        type: "POST",
        url: "Default2.aspx/GetNames",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (msg) {
            $("#ddlName").get(0).options.length = 0;
            $("#ddlName").get(0).options[0] = new Option("--Select Option--", "-1");

            $.each(msg.d, function (index, item) {
                $("#ddlName").get(0).options[$("#ddlName").get(0).options.length] = new Option(item.Display, item.Value);
            });
        },
        error: function () {
            alert("Failed to load Name");
        }
    });
});




