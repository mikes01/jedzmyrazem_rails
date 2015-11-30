angular.module('JedzmyrazemApp').factory 'Journey', ($http) ->
  createJourney: (journey) ->
    $http.post('/journeys.json', {journey: journey})
  searchJourney: (params) ->
    $http.get('/journeys.json', {params: params})