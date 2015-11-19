angular.module 'JedzmyrazemApp'
  .controller 'JourneyCtrl',
  ($http, $scope, $location, $rootScope, $filter, Auth, Journey)->

    Auth.currentUser().then((user) ->
      $scope.user = user
      (error) ->
        $location.path('/sign_in')
      )

    directionsService = new google.maps.DirectionsService()
    _directionsRenderer = ""

    $scope.map =
      center: [51.109395, 17.033151]
      zoom: 14

    $scope.autocompleteOptions =
      componentRestrictions: {country: 'pl'}

    $scope.start = {time: moment(new Date).add(10, 'm'), place: null}
    $scope.finish = {time: moment(new Date).add(20, 'm'), place: null}
    $scope.waypoints = []
    $scope.spaces = 1

    marker = null

    $scope.addWayPoint = () ->
      lastWaypoint = {place: null, time: $scope.finish.time}
      $scope.waypoints.push lastWaypoint


    $scope.removeWayPoint = (index) ->
      $scope.waypoints.splice(index, 1)
      $scope.getRoutePointsAndWaypoints()


    $scope.$on 'mapInitialized', (evt, map) ->
      _directionsRenderer = new google.maps.DirectionsRenderer()
      $scope.map = map
      _directionsRenderer.setMap($scope.map)
      _directionsRenderer.setOptions
        draggable: true

    $scope.getRoutePointsAndWaypoints = ->
      #Define a variable for waypoints.
      _waypoints = new Array

      i = 0
      while i < $scope.waypoints.length
        if $scope.waypoints[i].place != null
          _waypoints.push
            location: $scope.waypoints[i].place.geometry.location
            stopover: true
        i++
      try
        marker.setMap null
        drawRoute $scope.start.place.geometry.location,
        $scope.finish.place.geometry.location, _waypoints
      catch
        if $scope.start.place != null
          location = $scope.start.place
        else
          location = $scope.finish.place
        marker = new google.maps.Marker({
          map: $scope.map,
          position: location.geometry.location,
          draggable: false})


    drawRoute = (originAddress, destinationAddress, _waypoints) ->
      _request = ''
      if _waypoints.length > 0
        _request =
          origin: originAddress
          destination: destinationAddress
          waypoints: _waypoints
          optimizeWaypoints: true
          travelMode: google.maps.DirectionsTravelMode.DRIVING
      else
        #This is for one or two locations. Here noway point is used.
        _request =
          origin: originAddress
          destination: destinationAddress
          travelMode: google.maps.DirectionsTravelMode.DRIVING

      directionsService.route _request, (_response, _status) ->
        if _status == google.maps.DirectionsStatus.OK
          setTimes(_response.routes[0].legs)
          _directionsRenderer.setDirections _response

    $scope.today = ->
      $scope.dt = new Date
      

    $scope.today()

    $scope.clear = ->
      $scope.dt = null


    $scope.toggleMin = ->
      $scope.minDate = if $scope.minDate then null else new Date

    $scope.toggleMin()

    $scope.open = ($event) ->
      $scope.status.opened = true

    $scope.setDate = (year, month, day) ->
      $scope.dt = new Date(year, month, day)

    $scope.dateOptions =
      formatYear: 'yy'
      startingDay: 1
    $scope.format = 'dd.MM.yyyy'
    $scope.status = opened: false

    $scope.checkStartTime = () ->
      date = moment($scope.dt, $scope.format)
      today = moment(new Date, $scope.format)
      if date.isSame(today)
        if moment($scope.start.time , 'H:mm:ss').valueOf() <
        moment(new Date, 'H:mm:ss').add(10, 'm').valueOf()
          $scope.start.time = moment(new Date).add(10, 'm')
          if moment($scope.finish.time , 'H:mm:ss').valueOf() <
          moment($scope.start.time , 'H:mm:ss').add(10, 'm').valueOf()
            $scope.finish.time = moment(new Date).add(20, 'm')

    $scope.checkWaypointTime = (index, oldValue) ->
      if index > 0
        if moment($scope.waypoints[index].time , 'H:mm:ss').valueOf() <
        moment($scope.waypoints[index-1].time , 'H:mm:ss').valueOf()
          $scope.waypoints[index].time = oldValue
      else
        if moment($scope.waypoints[index].time , 'H:mm:ss').valueOf() <
        moment($scope.start.time , 'H:mm:ss').valueOf()
          $scope.waypoints[index].time = oldValue

    $scope.checkFinishTime = (oldValue) ->
      if $scope.waypoints.length > 0
        if moment($scope.finish.time , 'H:mm:ss').valueOf() <
        moment($scope.waypoints[$scope.waypoints.length -1].time , 'H:mm:ss').
        valueOf()
          $scope.finish.time = oldValue
      else
        if moment($scope.finish.time , 'H:mm:ss').valueOf() <
        moment($scope.start.time , 'H:mm:ss').valueOf()
          $scope.finish.time = oldValue



    setTimes = (points) ->
      i = 1
      
      while(i < $scope.waypoints.length)
        $scope.waypoints[i].time = moment($scope.waypoints[i-1].time)
        .add(points[i].duration.value, 's')
        i++
      if $scope.waypoints.length > 0
        $scope.waypoints[0].time = moment($scope.start.time)
        .add(points[0].duration.value, 's')
        $scope.finish.time = moment($scope.waypoints[$scope.waypoints.
        length-1].time)
        .add(points[$scope.waypoints.length].duration.value, 's')
      else
        $scope.finish.time = moment($scope.start.time)
          .add(points[0].duration.value, 's')



    $scope.saveJourney = () ->
      
      
      journey = {path: [], date: moment($scope.dt).format("YYYY-MM-DD"),
      spaces: $scope.spaces}
      journey.path.push {time: moment($scope.start.time).format("HH:mm"),
      point: []}
      journey.path[0].point.push $scope.start.place.geometry.location.lat()
      journey.path[0].point.push $scope.start.place.geometry.location.lng()

      
      i = 0

      while(i < $scope.waypoints.length)
        journey.path.push
        {time: moment($scope.waypoints[i].time).format("HH:mm"),
        point: []}
        journey.path[i+1].point.push $scope.waypoints[i].
        place.geometry.location.lat()
        journey.path[i+1].point.push $scope.waypoints[i].
        place.geometry.location.lng()
        i++

      journey.path.push {time: moment($scope.finish.time).format("HH:mm"),
      point: []}
      journey.path[journey.path.length-1].point.push $scope.finish.place.
      geometry.location.lat()
      journey.path[journey.path.length-1].point.push $scope.finish.place.
      geometry.location.lng()

      Journey.createJourney(journey).success (data) ->
        console.log data
      .error (data) ->
        console.log data