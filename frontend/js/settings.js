$(document).ready(function() {


    let base_url = "http://127.0.0.1:8000/api";

    setTimeout(() => {
        getCompanyInfoSettings();
    }, 1500);

    function getCompanyInfoSettings() {
        let url = base_url + "/company";

        $.ajax({
            type: "GET",
            url: url,
            headers: {
                Authorization: "Bearer " + token,
            },
            success: function(res) {
                console.log(res);
                if (res.code == "000") {
                    let countries = res.data.countries;
                    let branches = res.data.branches;
                    let events = res.data.events;

                    if (countries.length > 0) {
                        countries.map((country) => {
                            $(".country_list").append(`
                                    <option value="${country.dail_code}" selected>${country.country}</option>
                                `);
                        });
                    }

                    if (branches.length > 0) {
                        branches.map((branch) => {
                            $(".branch_list").append(`
                                    <option value="${branch.uuid}" selected>${branch.name}</option>
                                `);
                        });
                    }

                    if (events.length > 0) {
                        events.map((event) => {
                            $(".event_list").append(`
                                    <option value="${event.uuid}" selected>${event.name}</option>
                                `);
                        });
                    }
                } else {}
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                alert("some error");
            },
        });
    }

    $("#update-setting-form").submit(function(e) {
        e.preventDefault();

        Swal.showLoading();

        $("#submit-settings-form-btn").prop("disabled", true);
        $("#submit-settings-form-btn").text("Processing...");

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
                    $("#submit-settings-form-btn").prop("disabled", false);
                    $("#submit-settings-form-btn").text("Submit");
                    // $("#visitor-form").trigger("reset");
                    showAlert("success", res.message);
                    // $(".visitor-form-display").css("display", "none");
                    // $(".verify-pin-display").css("display", "block");
                } else {
                    $("#submit-settings-form-btn").prop("disabled", false);
                    $("#submit-settings-form-btn").text("Submit");
                    showAlert("error", res.message);
                }
                console.log(res);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                showAlert("error", "Server error");
                $("#submit-settings-form-btn").prop("disabled", false);
                $("#submit-settings-form-btn").text("Submit");
            },
        });
    });
});