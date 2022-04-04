$(document).ready(function() {


    let base_url = "http://127.0.0.1:8000/api";

    let company = JSON.parse(localStorage.company)
    let settings = JSON.parse(localStorage.settings)

    let retry_count = 0;

    $(".close_btn").click(function(e) {

        Swal.showLoading();

        window.location = 'welcome.html'
        return

    })


    function showAlert(icon, message, timer = "") {
        if (timer == "") {
            Swal.fire({
                // position: "top-end",
                icon: icon,
                title: message,
                showConfirmButton: false,
                // timer: 4000,
            });
        } else {
            Swal.fire({
                // position: "top-end",
                icon: icon,
                title: message,
                showConfirmButton: false,
                timer: timer,
            });
        }
    }

    $('#customer_id').keyup(function(e) {

        $(this).val($(this).val().replace(/^0+/, ''))

    });


    $(".resend-checkout-code").click(function(e) {
        e.preventDefault();
        Swal.showLoading();

        let country_phone_code = $(".country_phone_code_hidden").val();
        let customer_id = $(".customer_id_hidden").val();

        $(".resend-checkout-code").text("Processing...");

        // let data = {
        //     visitor: {
        //         customerId: customer_id,
        //     },
        //     settings: settings,
        // };

        $.ajax({
            type: "GET",
            url: base_url + "/visitor/resend-check-out-code/" + customer_id,
            // data: data,
            headers: {
                Authorization: "Bearer " + company.bearer_token,
            },
            success: function(res) {
                if (res.code == "000") {
                    $(".resend-checkout-code").text("Resend Code")

                    showAlert("success", res.message, 4000);
                    console.log(res);

                } else {

                    $(".resend-checkout-code").text("Resend Code")
                    showAlert("error", res.message, 4000);

                }

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                $(".resend-checkout-code").text("Resend Code")
                showAlert("error", "Server error");

            },
        });

    })

    //  Verify checkout visitor phone number
    $("#verify-phone-form").submit(function(e) {
        e.preventDefault();
        $("#visitor-form").trigger("reset");

        Swal.showLoading();



        $("#verify-visitor-form-btn").prop("disabled", true);
        $("#verify-visitor-form-btn").text("Processing...");

        let customer_id = $("#customer_id").val();


        let data = {
            visitor: {
                customerId: customer_id
            },
            settings: settings,
        };

        // console.log(data);

        // return
        $.ajax({
            type: "POST",
            url: base_url + "/visitor/verify-check-out",
            data: data,
            headers: {
                Authorization: "Bearer " + company.bearer_token,
            },
            success: function(res) {
                if (res.code == "000") {
                    $("#verify-visitor-form-btn").prop("disabled", false);
                    $("#verify-visitor-form-btn").text("Verify Phone Number");

                    $(".visitor_log_uuid_hidden").val(res.data.uuid);
                    $(".country_phone_code_hidden").val(res.data.country_phone_code);
                    $(".customer_id_hidden").val(res.data.customer_id);
                    $(".visitor_name").text(res.data.fullName);
                    $(".visitor_gender").text(res.data.gender);
                    $(".visitor_category").text(res.data.category_id);

                    let purpose = (res.data.purpose_description == null) ? `N/A` : res.data.purpose_description;
                    $(".visitor_purpose_description").text(purpose);

                    $(".continue-div-btn").css("display", "block");

                    showAlert("success", res.message, 3000);
                    console.log(res);

                } else if (res.code == "001") {
                    $("#verify-visitor-form-btn").prop("disabled", false);
                    $("#verify-visitor-form-btn").text("Verify Phone Number");

                    $(".visitor_log_uuid_hidden").val(res.data.uuid);
                    $(".country_phone_code_hidden").val(res.data.country_phone_code);
                    $(".customer_id_hidden").val(res.data.customer_id);
                    $(".visitor_name").text(res.data.fullName);
                    $(".visitor_gender").text(res.data.gender);
                    $(".visitor_category").text(res.data.category_id);

                    let purpose = (res.data.purpose_description == null) ? `N/A` : res.data.purpose_description;
                    $(".visitor_purpose_description").text(purpose);

                    // $(".continue-div-btn").css("display", "block");

                    showAlert("info", res.message, 5000);
                    console.log(res);

                } else {

                    $("#verify-visitor-form-btn").prop("disabled", false);
                    $("#verify-visitor-form-btn").text("Verify Phone Number");
                    showAlert("error", res.message, 4000);

                }

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                showAlert("error", "Server error");
                $("#verify-visitor-form-btn").prop("disabled", false);
                $("#verify-visitor-form-btn").text("Verify Phone Number");
            },
        });
    });


    // Verify checkout code entered
    $("#verify-form").submit(function(e) {
        e.preventDefault();

        Swal.showLoading();



        $("#verify-visitor-form-btn").prop("disabled", true);
        $("#verify-visitor-form-btn").text("Processing...");



        let token_1 = $("#token_1").val();
        let token_2 = $("#token_2").val();
        let token_3 = $("#token_3").val();
        let token_4 = $("#token_4").val();
        let token_number = token_1 + token_2 + token_3 + token_4;



        let customer_id = $(".customer_id_hidden").val();
        let visitor_log_uuid = $(".visitor_log_uuid_hidden").val();


        let data = {
            visitor: {
                customerId: customer_id,
                visitor_log_uuid: visitor_log_uuid,
                token: token_number

            },
            settings: settings,
        };

        // console.log(data);

        // return
        $.ajax({
            type: "POST",
            url: base_url + "/visitor/check-out",
            data: data,
            headers: {
                Authorization: "Bearer " + company.bearer_token,
            },
            success: function(res) {
                console.log(res);

                if (res.code == "000") {
                    $("#verify-visitor-form-btn").prop("disabled", false);
                    $("#verify-visitor-form-btn").text("Verify");
                    $("#visitor-form").trigger("reset");
                    showAlert("success", res.message, 7000);
                    Swal.showLoading();
                    // $(".visitor-form-display").css("display", "none");
                    // $(".verify-pin-display").css("display", "block");
                    setTimeout(() => {
                        window.location = 'welcome.html'
                    }, 6000);




                } else {
                    retry_count = retry_count + 1;
                    $("#verify-visitor-form-btn").prop("disabled", false);
                    $("#verify-visitor-form-btn").text("Verify");
                    showAlert("error", res.message, 4000);

                }

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                showAlert("error", "Server error");
                $("#verify-visitor-form-btn").prop("disabled", false);
                $("#verify-visitor-form-btn").text("Verify");
            },
        });
    });



})