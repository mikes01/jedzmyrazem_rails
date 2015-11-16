angular.module 'JedzmyrazemApp'
  .controller 'SearchJourneyCtrl',
  ($http, $scope, Auth, Journey)->
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

    $scope.search = () ->
      params = {date: moment($scope.dt).format("YYYY-MM-DD"),
      start_time: moment($scope.startTime).format("HH:mm"),
      start_lat: $scope.startPlace.geometry.location.lat()
      start_lng: $scope.startPlace.geometry.location.lng(),
      finish_lat: $scope.finishPlace.geometry.location.lat(),
      finish_lng: $scope.finishPlace.geometry.location.lng()}

      Journey.searchJourney(params).success (data) ->
        console.log data
      .error (data) ->
        console.log data