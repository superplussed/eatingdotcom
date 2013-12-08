App.directive "thumbnail", ->
  restrict: "A"
  scope: 
    thumbnail: "@"
    fancybox: "@"

  link: (scope, element, attrs) ->
    if scope.fancybox
      $(element).attr("href", scope.fancybox)
      $(element).fancybox() 

    element
      .addClass("thumbnail")
      .css('width', '100%')
      .css('height', '100%')
      .css('display', 'inline-block')
      .css('background', "url(#{scope.thumbnail}) no-repeat center center")
      .css("-webkit-background-size", "cover")
      .css("-moz-background-size", "cover")
      .css("-o-background-size", "cover")
      .css("background-size", "cover")   