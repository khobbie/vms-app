$(document).ready(function() {

    console.log(localStorage.company);
    console.log(localStorage.has_settings);

    if (localStorage.company == undefined || localStorage.company == "") {
        window.location = "onboarding.html";
    }

    if (localStorage.has_settings == "false") {
        console.log("ooooooooo");
        $(".visitor-welcome-display").css("display", "none");
        $(".settings-form-display").css("display", "block");
        getCompanyInfoSettings()
    }

    let company = JSON.parse(localStorage.company)
    let settings = JSON.parse(localStorage.settings)

    $(".txt-welcome-company-name").text(company.name)
    $(".txt-welcome-branch-name").text(settings.branchName)
    $(".txt-welcome-event-name").text(settings.eventName)
    $(".txt-welcome-location-name").text(settings.branchLocation)

    function showAlert(icon, message, timer = "", ok_btn = false) {

        let options = {
            // position: "top-end",
            icon: icon,
            title: message,
            showConfirmButton: true,
            // timer: 4000,
        }

        if (ok_btn) {
            options.showConfirmButton = true

            Swal.fire(options).then((result) => {
                /* Read more about isConfirmed, isDenied below */
                if (result.isConfirmed) {
                    Swal.showLoading();
                    window.location = 'onboarding.html'
                }
                return
            });

            return
        }

        if (timer == "") {
            Swal.fire({
                // position: "top-end",
                icon: icon,
                title: message,
                showConfirmButton: true,
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







    function getCompanyInfoSettings() {
        let url = base_url + "/company";

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
                    let countries = res.data.countries;
                    let branches = res.data.branches;
                    let events = res.data.events;

                    if (countries.length > 0) {
                        let country_selected = ""
                        countries.map((country) => {
                            country_selected = country.dail_code == company.dail_code ? "selected" : ""

                            $(".country_list").append(`
                                    <option value="${country.dail_code}" ${country_selected}>${country.country}</option>
                                `);
                        });
                    }

                    if (branches.length > 0) {
                        branches.map((branch) => {
                            let branch_selected = ""
                            branch_selected = branch.uuid == settings.branchId ? "selected" : ""
                            $(".branch_list").append(`
                                    <option value="${branch.uuid + '-' + branch.name + '-' + branch.location}" ${branch_selected}>${branch.name}</option>
                                `);
                        });
                    }

                    if (events.length > 0) {
                        events.map((event) => {
                            let event_selected = ""
                            event_selected = event.uuid == settings.eventId ? "selected" : ""
                            $(".event_list").append(`
                                    <option value="${event.uuid + '-' + event.name + '-' + event.location}" ${event_selected}>${event.name}</option>
                                `);
                        });
                    }
                } else {

                }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                alert("some error");
            },
        });
    }
    $(".submit-reset-app-btn").click(function(e) {
        localStorage.clear();
        showAlert("success", "Application reset successful", 3000);
        Swal.showLoading();
        setTimeout(() => {
            window.location = "onboarding.html"
        }, 3000);

    })

    $(".submit-onboarding-id-btn").click(function(e) {
        let onboarding_id = $("#onboarding_id").val();

        let company = JSON.parse(localStorage.company);

        if (company.onboarding_id !== onboarding_id) {

            showAlert("error", "Wrong onboarding ID", 3000);
            return
        } else {

            $(".visitor-welcome-display").css("display", "none");
            $(".settings-form-display").css("display", "block");
            $('#onboarding-id-form').modal('hide');
            getCompanyInfoSettings();
        }
    })

    $(".close_btn").click(function(e) {
        if (localStorage.has_settings == false) {
            showAlert("error", "Please finish set up", 3000);
            return
        } else {
            $(".visitor-welcome-display").css("display", "block");
            $(".settings-form-display").css("display", "none");
        }
    })

    $("#country").change(function() {
        console.log($(this).val());
        $("span.txt-dail-code").text($(this).val())
    })

    $("#update-setting-form").submit(function(e) {
        e.preventDefault();

        console.log(company.bearer_token);
        Swal.showLoading();
        // return

        $("#submit-settings-form-btn").prop("disabled", true);
        $("#submit-settings-form-btn").text("Processing...");



        let country_dail_code = $("#country").val();
        let branch_list = $("#branch").val();
        let event_list = $("#event").val();
        console.log(branch_list)

        let branch = branch_list.split("-")
        let event = event_list.split("-")


        settings = {
            countryCode: country_dail_code,
            branchId: branch[0],
            branchName: branch[1],
            branchLocation: branch[2],
            eventId: event[0],
            eventName: event[1],
            eventLocation: event[2],
            location: company.country,
        }

        localStorage.company = JSON.stringify(company)
        localStorage.settings = JSON.stringify(settings)
        localStorage.has_settings = true

        showAlert("success", "Application setup successful", 4000);
        $(".settings-form-display").css("display", "none");
        $(".visitor-welcome-display").css("display", "block");
    });
});