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
