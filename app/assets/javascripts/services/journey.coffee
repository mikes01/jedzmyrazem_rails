angular.module('JedzmyrazemApp').factory 'Journey', ($http) ->
  createJourney: (journey) ->
    $http.post('/journeys.json', {journey: journey})