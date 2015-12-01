angular.module 'JedzmyrazemApp'
  .controller 'NavbarCtrl', ($http, $scope, $location, Auth, User)->

    Auth.currentUser().then((user) ->
      $scope.user = user
    (error) ->
    )

    $scope.signOut = () ->
      Auth.logout().then((user) ->
        $scope.user = ''
        $location.path('/home')
      (error) ->
        console.log('error')
      )

    $scope.editUser = () ->
      User.editUser($scope.user).success (data) ->
        console.log data
        $location.path('/home')
      .error (data) ->
        console.log data.errors