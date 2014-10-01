jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true


window.fbAsyncInit = ->
  FB.init(appId: '<%=  Env['1479370212327640'] %>', cookie: true)

  $('#sign_in').click (e) ->
    e.preventDefault()
    FB.login (response) ->
      window.location = '/auth/facebook/callback' if response.authResponse
    , scope: "email,user_birthday,read_friendlists,publish_actions,read_stream"

  $('#sign_out').click (e) ->
    FB.getLoginStatus (response) ->
      FB.logout() if response.authResponse
    true

  if $('#sign_out').length > 0
    FB.getLoginStatus (response) ->
      window.location = $('#sign_out').attr("href") if !response.authResponse
