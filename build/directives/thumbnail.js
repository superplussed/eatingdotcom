(function() {
  App.directive("thumbnail", function() {
    return {
      restrict: "A",
      scope: {
        thumbnail: "@"
      },
      controller: function($scope) {
        return $scope.args = $scope.$eval($scope.thumbnail);
      },
      link: function(scope, element, attrs) {
        var imgEl;
        element.addClass("thumbnail");
        if ((scope.args.addToDom != null) && scope.args.addToDom) {
          element.addClass("loading");
          element.append("<img src='" + scope.args.src + "' style='opacity: 0'>");
          imgEl = element.find("img").first();
          imgEl.bind('load', function() {
            imgEl.css("opacity", 1);
            return element.addClass("loading-complete");
          });
        } else {
          element.css('width', '100%').css('height', '100%').css('display', 'inline-block').css('background', "url(" + scope.args.src + ") no-repeat center center").css("-webkit-background-size", "cover").css("-moz-background-size", "cover").css("-o-background-size", "cover").css("background-size", "cover");
        }
        if (scope.args.zoomConfig || scope.args.zoom) {
          element.addClass("zoomable").css("cursor", "pointer").css("display", "inline-block");
          element.append("<div class='icon-bg'><i class='fa fa-search-plus fa-lg'></i></div>");
          Zoomerang.config({
            maxWidth: 800,
            maxHeight: 800
          });
          return Zoomerang.listen(element.find("img")[0]);
        }
      }
    };
  });

}).call(this);
