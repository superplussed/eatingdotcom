#-------------------------------------------------
# FLUID-GRID
#-------------------------------------------------

App.directive "fluidGrid", ($window, $timeout, $rootScope) ->
  restrict: "EA"
  transclude: true
  replace: true

  template: """
    <div class='fluid-grid' style='width:100%;display:inline-block;'>
      <fluid-column ng-repeat='column in columns' column='column'></fluid-column>
      <div ng-transclude></div>
    </div>
  """

  controller: ($scope, $element, $attrs) ->

    $scope.blocks = []
    $scope.columns = []

    $scope.minBlockWidth = -> parseFloat($attrs.minBlockWidth) || 250
    $scope.blockMargin = -> parseFloat($attrs.blockMargin) || 4
    $scope.maxCols = -> parseInt($attrs.maxCols, 10) || 2
        
    $scope.numCols = -> 
      cnt = Math.floor($element.width()/$scope.minBlockWidth())
      if cnt > $scope.maxCols() then $scope.maxCols() else cnt

    $scope.blockWidth = -> Math.floor($element.width()/$scope.numCols()) - ($scope.blockMargin()/$scope.numCols()) - 1
    $scope.blockHeight = (aspectRatio) -> Math.floor($scope.blockWidth() * parseFloat(aspectRatio))

    $scope.initializeColumnArray = ->
      $scope.columns = []

    $scope.initializeColumnArray()  

    $scope.addBlock = (block) ->
      columnIndex = $scope.blocks.length % $scope.numCols()
      block.columnIndex = columnIndex
      $scope.blocks.push block
      $scope.columns[columnIndex] = [] unless $scope.columns[columnIndex]
      $scope.columns[columnIndex].push(block)

    $scope



#-------------------------------------------------
# FLUID-COLUMN
#-------------------------------------------------


App.directive "fluidColumn", ($timeout, $rootScope) ->
  require: "^fluidGrid"
  restrict: "EA"
  scope: 
    column: "="

  compile: (cElement, cAttr, transclude) ->
    (scope, iElement, iAttrs, gridCtrl) ->

      scope.resize = ->
        iElement.css("width", gridCtrl.blockWidth())
    
      scope.resize()

      iElement.css("display", "inline-block")

      if scope.column[0].columnIndex != gridCtrl.numCols() - 1
        iElement.css("margin-right", gridCtrl.blockMargin)

      scope.$watchCollection 'column', (collection) ->        
        angular.forEach collection, (block) ->
          iElement.append(block.el)

  controller: ($scope, $rootScope) ->
    $rootScope.$on "resizeWindow", ->
      $scope.resize()



#-------------------------------------------------
# FLUID-BLOCK
#-------------------------------------------------

App.directive "fluidBlock", ($timeout) ->
  require: "^fluidGrid"
  restrict: "EA"
  transclude: true
  replace: true
  scope: 
    "aspectRatio": "@"

  template: """
    <div class='fluid-block' ng-transclude></div>
  """

  link: (scope, element, attrs, gridCtrl) ->
    element
      .css("margin-bottom", gridCtrl.blockMargin())
      .css("width", "100%")
      .css("display", "inline-block")
    
    scope.resize = ->
      if scope.aspectRatio?
        element.css("height", gridCtrl.blockHeight(scope.aspectRatio))

    scope.resize()

    gridCtrl.addBlock
      scope: scope
      el: element

  controller: ($scope, $rootScope) ->
    $rootScope.$on "resizeWindow", ->
      $scope.resize()

    