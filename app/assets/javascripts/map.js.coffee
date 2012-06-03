# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready () ->
  return if $('#map_canvas').length == 0
  console.log('mapping')
  gradeToIcon = (grade) ->
    gradeToIconName = (grade) ->
      return 'green_MarkerA.png' if grade == 'A'
      return 'yellow_MarkerB.png' if grade == 'B'
      return 'orange_MarkerC.png' if grade == 'C'
      return 'red_MarkerD.png' if grade == 'D'
      return 'brown_MarkerF.png' if grade == 'F'
    return 'images/' + gradeToIconName(grade)

  myOptions =
    center: new google.maps.LatLng(37.055177,-120.454102)
    zoom: 5
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)

  showOnClick = (marker, school) ->
    google.maps.event.addListener marker, 'click', () ->
      window.location = '/schools/' + school.id

  # Acquired icons from:
  # http://www.benjaminkeen.com/?p=105
  addSchool = (school) ->
    markerOptions =
      map: map
      position: new google.maps.LatLng(school.latitude, school.longitude)
      title: school.name
      icon: gradeToIcon(school.grade)

    marker = new google.maps.Marker markerOptions
    showOnClick(marker, school)

  $.ajax url: "/schools/", dataType: 'json', success: (data) ->
    console.log('got ' + data)
    addSchool(school) for school in data
