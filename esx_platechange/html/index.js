$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://esx_platechange/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post('http://esx_platechange/exit', JSON.stringify({}));
        return
    })
    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 9) {
            $.post("http://esx_platechange/error", JSON.stringify({
                error: "You cannot have more than 8 in the plate."
            }))
            return
        } else if (!inputValue) {
            $.post("http://esx_platechange/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original 
        $.post('http://esx_platechange/main', JSON.stringify({
            text: inputValue,
        }));
        return;
    })
})
