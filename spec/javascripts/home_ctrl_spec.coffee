describe 'HomeCtrl', ( $scope)->
  $scope = null
  $controller = null
  beforeEach module('JedzmyrazemApp')

  beforeEach inject ($injector) ->
    $scope = $injector.get('$rootScope').$new()
    $controller = $injector.get('$controller')

  it 'has timeshow var in scope', ->
    $controller('HomeCtrl', {$scope: $scope })
    expect($scope.timeshow).toEqual false