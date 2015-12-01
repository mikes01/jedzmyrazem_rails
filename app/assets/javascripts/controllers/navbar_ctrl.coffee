angular.module 'JedzmyrazemApp'
  .controller 'NavbarCtrl', ($http, $scope, $location, Auth, User, toastr)->

    Auth.currentUser().then((user) ->
      $scope.user = user
    (error) ->
      $location.path('/home')
    )

    $scope.signOut = () ->
      Auth.logout().then((user) ->
        $scope.user = ''
        $location.path('/home')
      (error) ->
        console.log('error')
      )

    $scope.editUser = () ->
      if $scope.validate.check_all()
        User.editUser($scope.user).success (data) ->
          console.log data
          toastr.success('Zapisano nowe dane.', 'Sukces')
          $location.path('/home')
          $scope.user.current_password = ''
        .error (data) ->
          toastr.error('Spróbuj ponownie.', 'Wystąpił błąd')
          console.log data.errors

    $scope.validate =
      email_require: false
      email_format: false
      password_format: false
      password_confirmation_format: false
      current_password_require: false
      current_password_format: false
      username_require: false
      phone_require: false
      phone_format: false
      check_all: ()->
        result = true
        console.log $scope.user
        if $scope.user.email == '' || typeof($scope.user.email) == 'undefined'
          $scope.validate.email_require = true
          result = false
        if $scope.user.current_password == '' ||
        typeof($scope.user.current_password) == 'undefined'
          $scope.validate.current_password_require = true
          result = false
        if $scope.user.username == '' ||
        typeof($scope.user.username) == 'undefined'
          $scope.validate.username_require = true
          result = false
        if $scope.user.phone == '' || typeof($scope.user.phone) == 'undefined'
          $scope.validate.phone_require = true
          result = false
        if $scope.validate.email_format || $scope.validate.password_format ||
        $scope.validate.password_confirmation_format ||
        $scope.validate.phone_format
          result = false
        console.log result
        console.log $scope.validate
        result

    $scope.$watch 'user.email', (newValue, oldValue) ->
      re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      if !re.test(newValue) && typeof(newValue) != 'undefined' && newValue != ''
        $scope.validate.email_format = true
      else
        $scope.validate.email_format = false

    $scope.$watch 'user.password', (newValue, oldValue) ->
      if typeof(newValue) != 'undefined' && newValue != '' &&
      newValue.length < 8
        $scope.validate.password_format = true
      else
        $scope.validate.password_format = false

    $scope.$watch 'user.password_confirmation', (newValue, oldValue) ->
      if typeof(newValue) != 'undefined' &&
      newValue != '' && newValue != $scope.user.password
        $scope.validate.password_confirmation_format = true
      else
        $scope.validate.password_confirmation_format = false

    $scope.$watch 'user.current_password', (newValue, oldValue) ->
      if typeof(newValue) != 'undefined' && newValue != '' &&
      newValue.length < 8
        $scope.validate.current_password_format = true
      else
        $scope.validate.current_password_format = false

    $scope.$watch 'user.phone', (newValue, oldValue) ->
      
      if typeof(newValue) != 'undefined' && newValue != ''
        if newValue.length < 9
          $scope.validate.phone_format = true
        else if newValue.length > 9
          $scope.user.phone = newValue[0..-2]
        if (isNaN(newValue))
          $scope.user.phone = newValue[0..-2]
        if $scope.user.phone.length == 9
          $scope.validate.phone_format = false
