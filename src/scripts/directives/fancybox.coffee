App.directive "fancybox", ->
  restrict: "C"

  controller: ($scope, $element, $attrs) ->
    $($element).fancybox()