$(document).ready(function() {

    if (localStorage.company == undefined || localStorage.company == "") {
        window.location = "onboarding.html";
    }

    let company = JSON.parse(localStorage.company)
    let settings = JSON.parse(localStorage.settings)

    var retry_count = 0;

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
    $.ajaxSetup({
        timeout: 3000,
        retryAfter: 7000,
    });

    function getCompanyCategories() {
        let url = base_url + "/company/categories";

        let company = JSON.parse(localStorage.company);
        let settings = JSON.parse(localStorage.settings);


        $.ajax({
            type: "GET",
            url: url,
            headers: {
                Authorization: "Bearer " + company.bearer_token,
            },
            success: function(res) {
                console.log(res);
                if (res.code == "000") {
                    let categories = res.data;

                    if (categories.length > 0) {
                        let country_selected = ""
                        categories.map((category) => {

                            $("#category_id").append(`
                                    <option value="${category.uuid}" >${category.name}</option>
                                `);
                        });
                    }

                } else {
                    alert("some error");

                }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                alert("some error");
            },
        });
    }

    setTimeout(function() {
        getCompanyCategories();
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
        let gender = $("#gender").val();
        let category_id = $("#category_id").val();
        let purpose = $("#purpose").val();

        let data = {
            visitor: {
                customerId: phone_number,
            },
            settings: settings,
        };
        $.ajax({
            type: "POST",
            url: base_url + "/visitor/verify-check-in",
            data: data,
            headers: {
                Authorization: "Bearer " + company.bearer_token,
            },
            success: function(res) {
                if (res.code == "000") {

                    $(".phone_number_hidden").val($("#phone_number").val());
                    $(".fullName_hidden").val($("#fullName").val());
                    $(".gender_hidden").val($("#gender").val());
                    $(".category_id_hidden").val($("#category_id").val());
                    $(".purpose_hidden").val($("#purpose").val());
                    $(".verification_token_hidden").val(res.data.verification_token);
                    $(".verification_token_uuid_hidden").val(res.data.verification_token_uuid);



                    $("#submit-visitor-form-btn").prop("disabled", false);
                    $("#submit-visitor-form-btn").text("Submit");
                    $("#visitor-form").trigger("reset");
                    showAlert("success", res.message, 5000);
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

    $(".back_btn").click(function(e) {

        // Swal.showLoading();

        $(".verify-pin-display").css("display", "none");
        $(".visitor-form-display").css("display", "block");

        $("#phone_number").val($(".phone_number_hidden").val());
        $("#fullName").val($(".fullName_hidden").val());
        $("#gender").val($(".gender_hidden").val());
        $("#category_id").val($(".category_id_hidden").val());
        $("#purpose").val($(".purpose_hidden").val());



        return

    })

    $(".close_btn").click(function(e) {

        Swal.showLoading();

        window.location = 'welcome.html'


        return

    })


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



        let phone_number = $(".phone_number_hidden").val();
        let fullName = $(".fullName_hidden").val();
        let gender = $(".gender_hidden").val();
        let category_id = $(".category_id_hidden").val();
        let purpose = $(".purpose_hidden").val();
        let verification_token = $(".verification_token_hidden").val()
        let verification_token_uuid = $(".verification_token_uuid_hidden").val()

        if (token_number !== verification_token) {
            retry_count = retry_count + 0;
            if (retry_count >= 3) {
                $(".verify-pin-display").css("display", "none");
                $(".visitor-form-display").css("display", "block");

                $("#phone_number").val($(".phone_number_hidden").val());
                $("#fullName").val($(".fullName_hidden").val());
                $("#gender").val($(".gender_hidden").val());
                $("#category_id").val($(".category_id_hidden").val());
                $("#purpose").val($(".purpose_hidden").val());
                showAlert("error", "You have exceeded the Maximum retry", 5000);


                return

            } else {
                showAlert("error", "Wrong token entered, Try again", 4000);
                return
            }
        }

        let typeOfVisit = "IDIVIDUAL";
        let typeDescription = "O";

        let data = {
            visitor: {
                customerId: phone_number,
                fullName: fullName,
                gender: gender,
                category_id: category_id,
                purpose: purpose,
                typeOfVisit: typeOfVisit,
                typeDescription: typeDescription,
                verification_token: verification_token,
                verification_token_uuid: verification_token_uuid,
            },
            settings: settings,
        };

        // console.log(data);

        // return
        $.ajax({
            type: "POST",
            url: base_url + "/visitor/check-in",
            data: data,
            headers: {
                Authorization: "Bearer " + company.bearer_token,
            },
            success: function(res) {
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
                    retry_count = retry_count + 0;
                    $("#verify-visitor-form-btn").prop("disabled", false);
                    $("#verify-visitor-form-btn").text("Verify");
                    showAlert("error", res.message, 4000);

                }
                console.log(res);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                showAlert("error", "Server error");
                $("#verify-visitor-form-btn").prop("disabled", false);
                $("#verify-visitor-form-btn").text("Verify");
            },
        });
    });

});