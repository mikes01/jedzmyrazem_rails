angular.module 'JedzmyrazemApp'
  .controller 'HomeCtrl', ($http, $scope, $location, Auth, User)->
    $scope.hello = "hello"
    Auth.currentUser().then((user) ->
      $scope.user = user
      console.log user
    (error) ->
      $location.path('/sign_in')
    )

    $scope.signOut = () ->
      Auth.logout().then((user) ->
        $location.path('/sign_in')
      (error) ->
        console.log('error')
      )

    $scope.editUser = () ->
      User.editUser($scope.user).success (data) ->
        console.log data
        $location.path('/home')
      .error (data) ->
        console.log data.errors