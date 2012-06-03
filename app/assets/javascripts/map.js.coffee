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
    <div id="recommendation">
      <a href="recs.pdf"><%= recommendation.title %></a>
    </div>
    <div id="graph">
    </div>
    <div id="top_ten_in_district">
      <p><strong>Top Ten in District</strong></p>
      <ol>
      <% _.each(top_ten_in_district, function(school) { %> <li><%= school.name %></li> <% }); %>
      </ol>
    </div>
    <div id="links">
      <strong>School Fit Resources</strong>
      <ul>
        <li>School Fit Curriculum</li>
        <li>School Fit Newsletter</li>
        <li>School Fit Fun Facts</li>
      </ul>
      <strong>State Partners/Resources</strong>
      <ul>
        <li><a href="http://www.californiahealthykids.org/index">California Healthy Kids</a></li>
      </ul>
      <strong>National Partners/Resources</strong>
      <ul>
        <li><a href="http://americawalks.org/2011/02/kaiser-announces-every-body-walk-project/">Kaiser Everybody Walks</a></li>
        <li><a href="http://www.choosemyplate.gov/healthy-eating-tips/ten-tips.html">My Plate Educational Tips</a></li>
      </ul>
      <strong>Print Materials for Your School</strong>
      <ul>
        <li><a href="http://www.choosemyplate.gov/downloads/GettingStartedWithMyPlate.pdf">Getting Started with MyPlate</a></li>
        <li><a href="http://www.choosemyplate.gov/downloads/mini_poster_English_final.pdf">MyPlate Mini-Poster</a></li>
        <li><a href="http://www.choosemyplate.gov/downloads/FruitsAndVeggiesMiniPoster.pdf">Make Half Your Plate Fruits & Vegetables Mini-Poster</a></li>
        <li><a href="http://teamnutrition.usda.gov/Resources/MyPlate_halfplateposter.pdf">Make Half Your Plate Fruits & Vegetables Poster for Children</a></li>
        <li><a href="http://www.choosemyplate.gov/print-materials-ordering/dietary-guidelines.html">Dietary Guidelines Consumer Brochure</a></li>
        <li><a href="http://www.choosemyplate.gov/print-materials-ordering/selected-messages.html">Selected Messages for Consumers</a></li>
        <li><a href="http://www.choosemyplate.gov/healthy-eating-tips/ten-tips.html">10 Tips Nutrition Education Series</a></li>
        <li><a href="http://www.cnpp.usda.gov/Publications/MyPlate/GraphicsSlick.pdf">1-page graphics slick</a></li>
        <li><a href="http://www.choosemyplate.gov/healthy-eating-tips/sample-menus-recipes.html">Sample menus and recipes</a></li>
        <li><a href="http://www.choosemyplate.gov/print-materials-ordering/graphic-resources.html">MyPlate Graphic Resources</a></li>
      </ul>
    </div>
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
    r.linechart(10, 10, 180, 150, years, [values], { axis: "0 0 1 1", axisxstep: school.score_values.length - 1 })

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
