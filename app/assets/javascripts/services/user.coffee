angular.module('JedzmyrazemApp').factory 'User', ($http) ->
  resetPassword: (email) ->
    user = {user: {email: email}}
    $http.post('/users/password.json', user)

  editUser: (user) ->
    user = {user: {email: user.email,
    username: user.username,
    phone: user.phone,
    password: user.password,
    password_confirmation: user.password_confirmation,
    current_password: user.current_password}}

    $http.put('/users.json', user)

  editPassword: (user, resetPasswordToken) ->
    user = {user: {
    reset_password_token: resetPasswordToken
    password: user.password,
    password_confirmation: user.password_confirmation}}
    
    $http.put('/users/password.json', user)