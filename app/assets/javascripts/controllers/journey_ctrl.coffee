angular.module 'JedzmyrazemApp'
  .controller 'JourneyCtrl',
  ($http, $scope, $location, $rootScope, $filter, Auth, Journey, toastr)->

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

    $scope.waypoints = []
    $scope.waypoints.push {time: moment(new Date).add(10, 'm'), place: null}
    $scope.waypoints.push {time: moment(new Date).add(20, 'm'), place: null}
    $scope.spaces = 1
    $scope.pointsCount = 2

    marker = null

    $scope.addWayPoint = () ->
      lastWaypoint = $scope.waypoints[$scope.waypoints.length-1]
      $scope.waypoints[$scope.waypoints.length-1] = {place: null,
      time: lastWaypoint.time}
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
      drawRoute _waypoints


    drawRoute = (_waypoints) ->
      _request = ''
      if _waypoints.length > 1
        _request =
          origin: _waypoints[0].location
          destination: _waypoints[_waypoints.length-1].location
          waypoints: _waypoints.splice(1, _waypoints.length - 2)
          optimizeWaypoints: true
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

    setTimes = (points) ->
      i = 1
      while(i < $scope.waypoints.length)
        $scope.waypoints[i].time = moment($scope.waypoints[i-1].time)
        .add(points[i-1].duration.value, 's')
        i++

    $scope.updateTimes = (index, oldValue) ->
      if(index > 0)
        if moment($scope.waypoints[index].time).valueOf() <
        moment($scope.waypoints[index-1].time).valueOf()
          $scope.waypoints[index].time = moment(oldValue)
          return
      if(index < $scope.waypoints.length-1)
        diff = moment($scope.waypoints[index].time).valueOf() -
        moment(oldValue).valueOf()
        index++
        while(index < $scope.waypoints.length)
          $scope.waypoints[index].time = moment($scope.waypoints[index].time)
          .add(diff, 'ms')
          index++

    $scope.saveJourney = () ->
      if checkParameters()
        i = 0
        journey = {path: [], date: moment($scope.dt).format("YYYY-MM-DD"),
        spaces: $scope.spaces}
        while(i < $scope.waypoints.length)
          journey.path.push {time: moment($scope.waypoints[i].time)
          .format("HH:mm"), point: [], name: $scope.waypoints[i].place.name}
          journey.path[i].point.push $scope.waypoints[i].
          place.geometry.location.lat()
          journey.path[i].point.push $scope.waypoints[i].
          place.geometry.location.lng()
          i++

        Journey.createJourney(journey).success (data) ->
          toastr.success('Zapisano nowy przejazd.', 'Sukces')
          $scope.waypoints = []
        .error (data) ->
          toastr.error('Spróbuj ponownie za chwilę.', 'Wystąpił błąd')

    checkParameters = ()->
      if $scope.waypoints[0].place == null
        toastr.error('Uzupełnij miejsce początkowe.', 'Wystąpił błąd')
        false
      else if $scope.waypoints[$scope.waypoints.length - 1].place == null
        toastr.error('Uzupełnij cel podróży.', 'Wystąpił błąd')
        false
      else
        true