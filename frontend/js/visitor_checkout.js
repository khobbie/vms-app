$(document).ready(function() {


    let base_url = "http://127.0.0.1:8000/api";

    let company = JSON.parse(localStorage.company)
    let settings = JSON.parse(localStorage.settings)

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



    $("#verify-phone-form").submit(function(e) {
        e.preventDefault();

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

                    $(".visitor_name").text(res.data.fullName);
                    $(".visitor_gender").text(res.data.gender);
                    $(".visitor_category").text(res.data.category_id);

                    let purpose = (res.data.purpose_description == null) ? `N/A` : res.data.purpose_description;
                    $(".visitor_purpose_description").text(purpose);

                    $(".continue-div-btn").css("display", "block");

                    showAlert("success", res.message, 3000);
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


})