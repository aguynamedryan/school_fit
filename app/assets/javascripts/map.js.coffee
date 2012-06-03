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
    <div class="top_ten_in_district">
      <p>Top Ten in District</p>
      <ol>
      <% _.each(top_ten_in_district, function(school) { %> <li><%= school.name %></li> <% }); %>
      </ol>
    </div>
    <div class="graph">
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
    barWidth = 40
    width = (barWidth + 10) * school.score_values.length
    height = 200

    getValue = (datum) ->
      datum.value

    x = d3.scale.linear().domain([0, school.score_values.length]).range([0, width])
    y = d3.scale.linear().domain([0, d3.max(school.score_values, getValue)]).rangeRound([0, height])

    heightOffset = (datum) ->
      height - y(datum.value)

    xIndex = (datum, index) ->
      x(index)
    yOnValue = (datum) ->
      y(datum.value)
    barDemo = d3.select(".graph").
      append("svg:svg").
      attr("width", width).
      attr("height", height)

    barDemo.selectAll("rect").
      data(school.score_values).
        enter().
        append("svg:rect").
          attr("x", xIndex).
          attr("y", heightOffset).
          attr("height", yOnValue).
          attr("width", barWidth).
          attr("fill", "#2d578b")


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
