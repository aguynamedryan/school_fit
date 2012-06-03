# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready () ->
  return if $('#map_canvas').length == 0
  console.log('mapping')
  details_template = _.template('
    <div class="header">
      <%= name %>
    </div>
    <div>
      <p>
        <strong>Fit Score:</strong>
        <span class="fit_grade fit_grade_<%= grade %>"><%= grade %></span><span class="fit_score">(<%= fit_score %>)</span>
      </p>
    </div>
    <div id="graph">
    </div>
    <div id="top_ten_in_district">
      <p>Top Ten in District</p>
      <ol>
      <% _.each(top_ten_in_district, function(school) { %> <li><%= school.name %></li> <% }); %>
      </ol>
    </div>
    <a href="#" class="close">Close</a>
  ')
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

  hideDetail = () ->
    $('#info').hide()
    $(document).off('keydown.hideDetail')

  $('#info').on 'click', 'a.close', null,(event) ->
    hideDetail()

  drawGraph = (school) ->
    r = Raphael("graph")
    years = school.score_values.map (school) ->
              school.year
    values = school.score_values.map (school) ->
              school.value
    console.log(years)
    console.log(r)
    r.linechart(10, 10, 290, 150, years, [values], { axis: "0 0 1 1", axisxstep: school.score_values.length - 1 })

  showOnClick = (marker, school) ->
    google.maps.event.addListener marker, 'click', (event) ->
      event.stop()
      console.log(event)
      $.ajax url: 'schools/' + school.id, dataType: 'json', success: (school)->
        $('#info').html(details_template(school)).show()
        drawGraph(school)
        $(document).on 'keydown.hideDetail', (event) ->
          console.log(event)
          if event.keyCode == 27
            hideDetail()

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

  $.ajax url: "/schools/", dataType: 'json', success: (schools) ->
    console.log('got ' + schools)
    addSchool(school) for school in schools
