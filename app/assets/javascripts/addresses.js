$(document).on "ajax:error", "form", (evt, xhr, status, error) ->
   errors = xhr.responseJSON.error
   for message of errors
      $('#errors ul').append '<li>' + errors[message] + '</li>'
