angular.module('JedzmyrazemApp').directive 'reverseGeocode', ->
  restrict: 'E'
  template: '<div></div>'
  link: (scope, element, attrs) ->
    geocoder = new (google.maps.Geocoder)
    latlng = new (google.maps.LatLng)(attrs.lat, attrs.lng)
    geocoder.geocode { 'latLng': latlng }, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        if results[1]
          element.text results[1].formatted_address
        else
          element.text 'Location not found'
      else
        element.text 'Geocoder failed due to: ' + status
      return
    return
  replace: true