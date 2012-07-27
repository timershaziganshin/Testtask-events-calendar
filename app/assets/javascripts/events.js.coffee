# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->

  $("a#editevent").click((e) ->
    e.preventDefault()
    $.get("/events/" + e.target.parentNode.id + "/edit", {  }, (xml) ->
      $("#editform").html(xml)
      $("#editform").css("display", "block")
    )
  )

  $("#editcurrentevent").click((e) ->
    e.preventDefault()
    $.get("/events/" + e.target.parentNode.id + "/edit", {  }, (xml) ->
      $("#currentevent").html(xml)
      $("#datepicker").datepicker({ format: 'yyyy-mm-dd' })
    )
  )
  
  $("#newevent").click((e) ->
    e.preventDefault()
    $.get("/events/new", {  }, (xml) ->
      $("#editform").html(xml)
      $("#editform").css("display", "block")
      $("#datepicker").datepicker({ format: 'yyyy-mm-dd' })
    )
  )

  $(document).keydown((e) ->
    if(e.keyCode == 27)
      $("#editform").css("display", "none")
  )
  
  $("#by_date").datepicker()
    .on('changeDate', (e) ->
      window.location = '/events/bydate/' + e.date.getFullYear() + '/' + (e.date.getMonth() + 1) + '/' + e.date.getDate() + '/'
    )

  $("#my_by_date").datepicker()
    .on('changeDate', (e) ->
      window.location = '/myevents/bydate/' + e.date.getFullYear() + '/' + (e.date.getMonth() + 1) + '/' + e.date.getDate() + '/'
    )
)
