angular.module 'JedzmyrazemApp'
  .controller 'HomeCtrl',
  ($http, $scope, $location, Auth, User, Journey,toastr)->

    $scope.time = moment(new Date)
    $scope.timeshow = false
    $scope.startPlace = null
    $scope.finishPlace = null
    $scope.dateOptions =
      formatYear: 'yy'
      startingDay: 1
    $scope.format = 'dd.MM.yyyy'
    $scope.status = opened: false

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

    $scope.search = () ->
      if checkParameters()
        params = {date: moment($scope.dt).format("YYYY-MM-DD"),
        start_time: moment($scope.time).format("HH:mm"),
        start_lat: $scope.startPlace.geometry.location.lat()
        start_lng: $scope.startPlace.geometry.location.lng(),
        finish_lat: $scope.finishPlace.geometry.location.lat(),
        finish_lng: $scope.finishPlace.geometry.location.lng()}
        Journey.searchJourney(params).success (data) ->
          $scope.journeys = data.journey
          if data.journey.length < 1
            toastr.warning('Nie ma żadnych przejazdów o tych parametrach.',
            'Przykro nam')
        .error (data) ->
          toastr.error('Spróbuj pownownie za chwilę.', 'Wystąpił błąd')

    checkParameters = ()->
      if $scope.startPlace == null
        toastr.error('Uzupełnij miejsce początkowe.', 'Wystąpił błąd')
        false
      else if $scope.finishPlace == null
        toastr.error('Uzupełnij cel podróży.', 'Wystąpił błąd')
        false
      else
        true