$(document).ready(function() {



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




    $("#onboarding-form").submit(function(e) {
        e.preventDefault();


        Swal.showLoading();


        localStorage.clear();


        $("#onboard-company-form-btn").prop("disabled", true);
        $("#onboard-company-form-btn").text("Processing...");

        let company_id = $("#company_id").val();
        let company_onboarding_id = $("#onboarding_id").val();

        let data = {
            company_id: company_id,
            company_onboarding_id: company_onboarding_id,

        };

        $.ajax({
            type: "POST",
            url: base_url + "/onboarding-company",
            data: data,
            success: function(res) {
                if (res.code == "000") {


                    // set key
                    localStorage.company = JSON.stringify(res.data);
                    localStorage.settings = JSON.stringify({
                        branchId: "",
                        branchName: "",
                        branchLocation: "",
                        eventId: "",
                        eventName: "",
                        eventLocation: "",
                        location: "",
                    });

                    localStorage.has_settings = false


                    $("#onboard-company-form-btn").prop("disabled", false);
                    $("#onboard-company-form-btn").text("Submit");
                    $("#visitor-form").trigger("reset");

                    let message = "Welcome " + res.data.name + ". \n You have successfully onboard onto VMS \n Go ahead and set up you app"
                    showAlert("success", message, 6000);
                    Swal.showLoading();
                    setTimeout(() => {
                        window.location = "welcome.html";
                    }, 6000);
                    // $(".visitor-form-display").css("display", "none");
                    // $(".verify-pin-display").css("display", "block");
                } else {
                    $("#onboard-company-form-btn").prop("disabled", false);
                    $("#onboard-company-form-btn").text("Submit");
                    showAlert("error", res.message);
                }
                console.log(res);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                showAlert("error", "Server error");
                $("#onboard-company-form-btn").prop("disabled", false);
                $("#onboard-company-form-btn").text("Submit");
            },
        });
    });



});