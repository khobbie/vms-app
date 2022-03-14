$(document).ready(function() {
    console.log(token);

    function showAlert(icon, message) {
        Swal.fire({
            // position: "top-end",
            icon: icon,
            title: message,
            showConfirmButton: false,
            // timer: 4000,
        });
    }
    $.ajaxSetup({
        timeout: 3000,
        retryAfter: 7000,
    });

    setTimeout(function() {
        // getCategories();
        // getBranches();
        // getEvents();
    }, 1000);

    $("#visitor-form").submit(function(e) {
        e.preventDefault();

        Swal.showLoading();

        $("#submit-visitor-form-btn").prop("disabled", true);
        $("#submit-visitor-form-btn").text("Processing...");

        let phone_number = $("#phone_number").val();
        let fullName = $("#fullName").val();
        let category_id = $("#category_id").val();
        let purpose = $("#purpose").val();

        let data = {
            visitor: {
                customerId: phone_number,
            },
            settings: {
                countryCode: "233",
                branchId: "7830293",
                eventId: "467382",
                location: "sdgdf",
            },
        };
        $.ajax({
            type: "POST",
            url: base_url + "/visitor/verify-check-in",
            data: data,
            headers: {
                Authorization: "Bearer " + token,
            },
            success: function(res) {
                if (res.code == "000") {
                    $("#submit-visitor-form-btn").prop("disabled", false);
                    $("#submit-visitor-form-btn").text("Submit");
                    $("#visitor-form").trigger("reset");
                    showAlert("success", res.message);
                    $(".visitor-form-display").css("display", "none");
                    $(".verify-pin-display").css("display", "block");
                } else {
                    $("#submit-visitor-form-btn").prop("disabled", false);
                    $("#submit-visitor-form-btn").text("Submit");
                    showAlert("error", res.message);
                }
                console.log(res);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                showAlert("error", "Server error");
                $("#submit-visitor-form-btn").prop("disabled", false);
                $("#submit-visitor-form-btn").text("Submit");
            },
        });
    });
});