$ ->
  $(".update-tweets").click (e) ->
    e.preventDefault()
    first_name  = $("#user-id-0").html()
    second_name = $("#user-id-1").html()
    third_name  = $("#user-id-2").html()
    $.ajax
      url: "/timeline/update"
      data:
        profile_names: [first_name, second_name, third_name]
      type: "GET"
      dataType: "html"
      success: (response) ->
        $("#tweets").replaceWith response
        $("#update-notification").fadeIn "slow"
      error: ->
        $("#failure-notification").fadeIn "slow"

  $("#update-notification a.close").click ->
    $("#update-notification").fadeOut "slow"
    false

  $("#failure-notification a.close").click ->
    $("#failure-notification").fadeOut "slow"
    false

  $("#back-to-top").backToTop
