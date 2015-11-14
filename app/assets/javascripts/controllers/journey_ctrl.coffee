angular.module 'JedzmyrazemApp'
  .controller 'JourneyCtrl',
  ($http, $scope, $location, $rootScope, $filter, Auth)->

    directionsService = new google.maps.DirectionsService()
    _directionsRenderer = ""

    $scope.map =
      center: [51.109395, 17.033151]
      zoom: 14

    $scope.autocompleteOptions =
      componentRestrictions: {country: 'pl'}

    $scope.chosenPlace = [null, null]
    $scope.times = [moment(new Date).add(10, 'm'),
    moment(new Date).add(20, 'm')]

    marker = null

    $scope.addWayPoint = () ->
      lastPlace = $scope.chosenPlace[$scope.chosenPlace.length - 1]
      lastTime = $scope.times[$scope.times.length - 1]
      $scope.chosenPlace[$scope.chosenPlace.length - 1] = null
      $scope.times[$scope.times.length - 1] = moment(lastTime)
      $scope.chosenPlace.push lastPlace
      $scope.times.push lastTime


    $scope.removeWayPoint = (index) ->
      $scope.chosenPlace.splice(index, 1)
      $scope.times.splice(index, 1)
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

      i = 1
      while i < $scope.chosenPlace.length - 1
        if $scope.chosenPlace[i] != null
          _waypoints.push
            location: $scope.chosenPlace[i].geometry.location
            stopover: true
        i++
      try
        marker.setMap null
        drawRoute $scope.chosenPlace[0].geometry.
        location, $scope.chosenPlace[$scope.chosenPlace.length - 1].
        geometry.location, _waypoints
      catch
        marker = new google.maps.Marker({
          map: $scope.map,
          position: $scope.chosenPlace[0].geometry.location,
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

    $scope.checkMinTime = () ->
      date = moment($scope.dt, $scope.format)
      today = moment(new Date, $scope.format)
      if date.isSame(today)
        if moment($scope.times[0], 'H:mm:ss').valueOf() <
        moment(new Date, 'H:mm:ss').valueOf()
          $scope.times[0] = moment(new Date).add(10, 'm')
          $scope.updateTime()

    $scope.updateTime = (index, oldValue) ->
      if(index > 0)
        if(moment($scope.times[index]).valueOf() <
        moment($scope.times[index - 1]).valueOf())
          $scope.times[index] =  moment(oldValue)
          return
      diff = moment($scope.times[index]).valueOf() - moment(oldValue).valueOf()
      i = index + 1
      while(i < $scope.times.length)
        $scope.times[i] = moment($scope.times[i]).add(diff, 'ms')
        i++

    setTimes = (points) ->
      i = 1
      while(i < $scope.times.length)
        $scope.times[i] = moment($scope.times[i-1])
        .add(points[i-1].duration.value, 's')
        i++