App.directive "thumbnail", ->
  restrict: "A"
  scope: 
    thumbnail: "@"
    fancybox: "@"
    thumbnailBg: "@"

  link: (scope, element, attrs) ->
    if scope.fancybox
      url = if scope.fancybox == "true" then scope.thumbnail else scope.fancybox
      $(element).attr("href", url)
      $(element).fancybox() 

    if scope.thumbnailBg == "true"
      element
        .css('width', '100%')
        .css('height', '100%')
        .css('display', 'inline-block')
        .css('background', "url(#{scope.thumbnail}) no-repeat center center")
        .css("-webkit-background-size", "cover")
        .css("-moz-background-size", "cover")
        .css("-o-background-size", "cover")
        .css("background-size", "cover")   
    else
      element
        .addClass("thumbnail")
        .append("<img src='#{scope.thumbnail}'>")