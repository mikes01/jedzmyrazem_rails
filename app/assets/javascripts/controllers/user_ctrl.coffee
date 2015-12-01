angular.module('JedzmyrazemApp')
  .controller 'UserCtrl',
  ($scope, $http, $location, $stateParams, Auth, User, toastr) ->

    $scope.user = ''

    if Auth.isAuthenticated()
      $location.path('/home')

    $scope.signUp = () ->
      if $scope.validate.check_all()
        credentials = {email: $scope.user.email,
        username: $scope.user.username,
        phone: $scope.user.phone,
        password: $scope.user.password,
        password_confirmation: $scope.user.password_confirmation}

        Auth.register(credentials, null).then((user) ->
          $location.path('/home')
        (error) ->
          toastr.error('Sprawdź czy adres email i telefon są unikalne i '+
            'spróbuj ponownie', 'Wystąpił błąd')
          $scope.user.password = ''
          $scope.user.password_confirmation = ''
        )

    $scope.signIn = () ->
      if $scope.validate.check_email_password()
        credentials = {email: $scope.user.email, password: $scope.user.password}
        Auth.login(credentials, null).then((user) ->
          $location.path('/home')
        (error) ->
          toastr.error('Adres email lub hasło są nieprawidłowe.',
            'Wystąpił błąd')
          $scope.user.password = ''
        )

    $scope.goToSignIn = () ->
      $location.path('/sign_in')

    $scope.goToSignUp = () ->
      $location.path('/sign_up')

    $scope.resetPassword = () ->
      if $scope.user.email == '' || typeof($scope.user.email) == 'undefined'
        $scope.validate.email_require = true
      else if !$scope.validate.email_format
        User.resetPassword($scope.user.email).success (data) ->
          toastr.success('Sprawdź swoją skrzynkę pocztową.', 'Wysłano email')
        .error (data) ->
          toastr.error('Sprawdź czy adres email jest poprawny \
            i spróbuj ponownie', 'Wystąpił błąd')

    $scope.editPassword = () ->
      if $scope.validate.check_passwords()
        User.editPassword($scope.user, $stateParams.resetPasswordToken)
        .success (data) ->
          $location.path('/home')
        .error (data) ->
          toastr.error('Spróbuj ponownie.', 'Wystąpił błąd')
          $scope.user = ''

    $scope.validate =
      email_require: false
      email_format: false
      password_require: false
      password_format: false
      password_confirmation_require: false
      password_confirmation_format: false
      username_require: false
      phone_require: false
      phone_format: false
      check_all: ()->
        result = true
        if $scope.user.email == '' || typeof($scope.user.email) == 'undefined'
          $scope.validate.email_require = true
          result = false
        if $scope.user.password == '' ||
        typeof($scope.user.password) == 'undefined'
          $scope.validate.password_require = true
          result = false
        if $scope.user.password_confirmation == '' ||
        typeof($scope.user.password_confirmation) == 'undefined'
          $scope.validate.password_confirmation_require = true
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
        result
      check_email_password: ()->
        result = true
        if $scope.user.email == '' || typeof($scope.user.email) == 'undefined'
          $scope.validate.email_require = true
          result = false
        if $scope.user.password == '' ||
        typeof($scope.user.password) == 'undefined'
          $scope.validate.password_require = true
          result = false
          result = false
        if $scope.validate.email_format || $scope.validate.password_format
          result = false
        result
      check_passwords: ()->
        result = true
        if $scope.user.password == '' ||
        typeof($scope.user.password) == 'undefined'
          $scope.validate.password_require = true
          result = false
        if $scope.user.password_confirmation == '' ||
        typeof($scope.user.password_confirmation) == 'undefined'
          $scope.validate.password_confirmation_require = true
          result = false
        if $scope.validate.password_confirmation_format ||
        $scope.validate.password_format
          result = false
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

