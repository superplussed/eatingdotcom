(function() {
  App.directive("fluidGrid", function($window, $timeout, $rootScope) {
    return {
      restrict: "EA",
      transclude: true,
      replace: true,
      scope: {
        normalizeColumns: "@"
      },
      template: "<div class='fluid-grid' style='width:100%;display:inline-block;'>\n  <fluid-column ng-repeat='column in columns' column='column'></fluid-column>\n  <div ng-transclude></div>\n</div>",
      controller: function($scope, $element, $attrs) {
        $scope.blocks = [];
        $scope.columns = [];
        $scope.minBlockWidth = function() {
          return parseFloat($attrs.minBlockWidth) || 250;
        };
        $scope.blockMargin = function() {
          return parseFloat($attrs.blockMargin) || 4;
        };
        $scope.maxCols = function() {
          return parseInt($attrs.maxCols, 10) || 2;
        };
        $scope.numCols = function() {
          var cnt;
          cnt = Math.floor($element.width() / $scope.minBlockWidth());
          if (cnt > $scope.maxCols()) {
            return $scope.maxCols();
          } else {
            return cnt;
          }
        };
        $scope.blockWidth = function() {
          return Math.floor($element.width() / $scope.numCols()) - ($scope.blockMargin() / $scope.numCols()) - 1;
        };
        $scope.blockHeight = function(aspectRatio) {
          return Math.floor($scope.blockWidth() * parseFloat(aspectRatio));
        };
        $scope.initializeColumnArray = function() {
          return $scope.columns = [];
        };
        $scope.initializeColumnArray();
        $scope.addBlock = function(block) {
          var columnIndex;
          columnIndex = $scope.blocks.length % $scope.numCols();
          block.columnIndex = columnIndex;
          $scope.blocks.push(block);
          if (!$scope.columns[columnIndex]) {
            $scope.columns[columnIndex] = [];
          }
          return $scope.columns[columnIndex].push(block);
        };
        return $scope;
      }
    };
  });

  App.directive("fluidColumn", function($timeout, $rootScope) {
    return {
      require: "^fluidGrid",
      restrict: "EA",
      scope: {
        column: "="
      },
      compile: function(cElement, cAttr, transclude) {
        return function(scope, iElement, iAttrs, gridCtrl) {
          scope.resize = function() {
            return iElement.css("width", gridCtrl.blockWidth());
          };
          scope.resize();
          iElement.css("display", "inline-block");
          if (scope.column[0].columnIndex !== gridCtrl.numCols() - 1) {
            iElement.css("margin-right", gridCtrl.blockMargin);
          }
          return scope.$watchCollection('column', function(collection) {
            angular.forEach(collection, function(block) {
              return iElement.append(block.el);
            });
            scope.resize();
            return $timeout(function(el) {
              return angular.forEach(scope.column, function(block) {
                return block.scope.resize();
              });
            }, 1000);
          });
        };
      },
      controller: function($scope, $rootScope) {
        return $rootScope.$on("resizeWindow", function() {
          return $scope.resize();
        });
      }
    };
  });

  App.directive("fluidBlock", function($timeout) {
    return {
      require: "^fluidGrid",
      restrict: "EA",
      transclude: true,
      replace: true,
      scope: {
        "aspectRatio": "@"
      },
      template: "<div class='fluid-block' ng-transclude></div>",
      link: function(scope, element, attrs, gridCtrl) {
        element.css("margin-bottom", gridCtrl.blockMargin()).css("width", "100%").css("display", "inline-block");
        scope.resize = function() {
          var height;
          if (scope.aspectRatio != null) {
            height = gridCtrl.blockHeight(scope.aspectRatio);
          }
          return element.css("height", height);
        };
        scope.resize();
        return gridCtrl.addBlock({
          scope: scope,
          el: element
        });
      },
      controller: function($scope, $rootScope) {
        return $rootScope.$on("resizeWindow", function() {
          return $scope.resize();
        });
      }
    };
  });

}).call(this);
