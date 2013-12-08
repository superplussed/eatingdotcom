App.directive "overlay", ->
  restrict: "A"

  link: (scope, element, attrs) ->

    overlayColor = attrs.overlayColor|| "rgba(0, 0, 0, 0.7)"
    hoverColor = attrs.hoverColor || "rgba(0, 0, 0, 1)"
    transitionSpeed = attrs.transitionSpeed || 0.5
    defaultOpacity = attrs.defaultOpacity || 0.7

    $(element)
      .children()
      .wrap("<div class='overlay'></div>") 

    hoverEl = angular.element(element.children()[0]) 

    hoverEl
      .css('-webkit-transition', "all #{transitionSpeed}s ease-in-out")
      .css('-moz-transition', "all #{transitionSpeed}s ease-in-out")
      .css('transition', "all #{transitionSpeed}s ease-in-out")
      .css('backgroundColor', overlayColor)
    
    hoverEl.bind 'mouseleave', (el) ->
      angular.element(el.currentTarget)
        .css('backgroundColor', overlayColor)

    hoverEl.bind 'mouseover', (el) ->
      angular.element(el.currentTarget)
        .css('backgroundColor', hoverColor)
        