angular.module 'JedzmyrazemApp'
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('home')

    $stateProvider
      .state('home', {
        url: '/home',
        controller: 'HomeCtrl',
        templateUrl: 'home.html'
      })
      .state('sign_in', {
        url: '/sign_in',
        controller: 'UnloggedUserCtrl',
        templateUrl: 'sign_in.html'
      })
      .state('sign_up', {
        url: '/sign_up',
        controller: 'UnloggedUserCtrl',
        templateUrl: 'sign_up.html'
      })
      .state('reset_password', {
        url: '/reset_password',
        controller: 'UnloggedUserCtrl',
        templateUrl: 'reset_password.html'
      })
      .state('edit_user', {
        url: '/edit_user',
        controller: 'HomeCtrl',
        templateUrl: 'edit_user.html'
      })
      .state('edit_password', {
        url: '/edit_password/:resetPasswordToken',
        controller: 'UnloggedUserCtrl',
        templateUrl: 'edit_password.html'
      })