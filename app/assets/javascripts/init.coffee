angular.module('JedzmyrazemApp', ['templates', 'ui.router', 'Devise'])
  .config ($provide, $httpProvider) ->
    # CSFR token
    $httpProvider.defaults.headers.common['X-CSRF-Token'] =
      angular.element(document.querySelector('meta[name=csrf-token]'))
        .attr('content')