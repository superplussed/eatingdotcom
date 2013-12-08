App.directive "thumbnail", ->
  restrict: "A"
  scope: 
    thumbnail: "@"
    fancybox: "@"

  link: (scope, element, attrs) ->
    if scope.fancybox
      $(element).fancybox() 

    if scope.overlay
      $(element).children().wrap("<div class='overlay'></div>") 

    element
      .addClass("thumbnail")
      .css('background', "url(#{scope.thumbnail}) no-repeat center center")
      .css("-webkit-background-size", "cover")
      .css("-moz-background-size", "cover")
      .css("-o-background-size", "cover")
      .css("background-size", "cover")   