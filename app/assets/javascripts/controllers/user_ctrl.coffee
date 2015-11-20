angular.module('JedzmyrazemApp')
  .controller 'UserCtrl',
  ($scope, $http, $location, $stateParams, Auth, User) ->

    Auth.currentUser().then (user) ->
      $scope.currentUser = user
      $location.path('/home')
    (error) ->
      

    $scope.signUp = () ->
      credentials = {email: $scope.user.email,
      username: $scope.user.username,
      phone: $scope.user.phone,
      password: $scope.user.password,
      password_confirmation: $scope.user.password_confirmation}

      Auth.register(credentials, null).then((user) ->
        $location.path('/home')
      (error) ->
        console.log error
      )

    $scope.signIn = () ->
      credentials = {email: $scope.user.email, password: $scope.user.password}
      Auth.login(credentials, null).then((user) ->
        console.log user
        $location.path('/home')
      (error) ->
        console.log error
      )

    $scope.goToSignIn = () ->
      $location.path('/sign_in')

    $scope.goToSignUp = () ->
      $location.path('/sign_up')

    $scope.resetPassword = () ->
      User.resetPassword($scope.user.email).success (data) ->
        console.log "sukces!"
      .error (data) ->
        console.log data

    $scope.editPassword = () ->
      User.editPassword($scope.user, $stateParams.resetPasswordToken)
      .success (data) ->
        $location.path('/home')
      .error (data) ->
        console.log data