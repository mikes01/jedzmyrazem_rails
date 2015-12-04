describe 'HomeCtrl', ( $scope)->
  $scope = null
  $controller = null
  beforeEach module('JedzmyrazemApp')

  beforeEach inject ($injector, _$q_) ->
    $scope = $injector.get('$rootScope').$new()
    $controller = $injector.get('$controller')
    $controller('HomeCtrl', {$scope: $scope })

  describe '$scope', ->
    it 'has timeshow equal false', ->
      expect($scope.timeshow).toEqual false

    it 'has time not to be null', ->
      expect($scope.time).not.toBeNull

    it 'has startPlace to be null', ->
      expect($scope.startPlace).toBeNull

    it 'has finishPlace to be null', ->
      expect($scope.finishPlace).toBeNull

    it 'has format equal dd.MM.yyyy', ->
      expect($scope.format).toEqual 'dd.MM.yyyy'

    it 'has format equal status.opened', ->
      expect($scope.status.opened).toEqual false

    it 'has dt not to be null', ->
      expect($scope.dt).not.toBeNull

    it 'has minDate not to be null', ->
      expect($scope.minDate).not.toBeNull

  describe 'setDate', ->
    it 'initialize $scope.dt var', ->
      $scope.setDate(2014, 11, 15)
      expect($scope.dt).toEqual new Date(2014, 11, 15)

  describe 'clear', ->
    it 'clear $scope.dt var', ->
      $scope.dt = new Date(2014, 11, 15)
      $scope.clear()
      expect($scope.dt).toBeNull

  describe 'toggleMin', ->
    it 'if minDate is setted, it set minDate to null', ->
      $scope.toggleMin()
      expect($scope.minDate).toBeNull
    it 'if minDate is not setted, it set minDate', ->
      $scope.minDate = null
      $scope.toggleMin()
      expect($scope.minDate).not.toBeNull

  describe 'today', ->
    it 'initialize $scope.dt var with today date', ->
      $scope.today()
      expect($scope.dt).toEqual new Date

  describe 'open', ->
    it 'set status.opened to true', ->
      $scope.open()
      expect($scope.status.opened).toEqual true