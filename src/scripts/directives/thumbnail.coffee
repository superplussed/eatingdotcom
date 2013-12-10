# zoom requires https://github.com/yyx990803/zoomerang
# config options:
# transitionDuration - default: '.4s'
# transitionTimingFunction - default: 'cubic-bezier(.4,0,0,1)'
# bgColor - default: '#fff'
# bgOpacity - default: 1
# maxWidth - max element width when zoomed-in. default: 300
# maxHeight - max element height when zoomed-in. default: 300
# deepCopy - whether to copy innerHTML. If target element has complicated inner structure you might need this to make it work. default: false

App.directive "thumbnail", ->
  restrict: "A"
  scope: 
    thumbnail: "@"

  controller: ($scope) ->
    $scope.args = $scope.$eval($scope.thumbnail)

  link: (scope, element, attrs) ->
    element.addClass("thumbnail")
    if scope.args.addToDom? && scope.args.addToDom
      element.append("<img src='#{scope.args.src}'>")
      imgEl = element.find("img").first()
    else
      element
        .css('width', '100%')
        .css('height', '100%')
        .css('display', 'inline-block')
        .css('background', "url(#{scope.args.src}) no-repeat center center")
        .css("-webkit-background-size", "cover")
        .css("-moz-background-size", "cover")
        .css("-o-background-size", "cover")
        .css("background-size", "cover")   

    if scope.args.zoomConfig or scope.args.zoom
      element
        .css("pointer", "cursor")
      Zoomerang.config(scope.args.zoomConfig) if scope.args.zoomConfig
      Zoomerang.listen(zoomEl?[0] or element[0])


