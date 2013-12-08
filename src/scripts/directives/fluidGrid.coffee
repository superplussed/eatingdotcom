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

  # compile: (cElement, cAttr) ->
  #   pre: (scope, iElement, iAttr) ->


  controller: ($scope, $element, $attrs) ->

    $scope.blocks = []
    $scope.columns = []

    $scope.minBlockWidth = -> parseFloat($attrs.minBlockWidth) || 250
    $scope.blockMargin = -> parseFloat($attrs.blockMargin) || 4
    $scope.blockRatio = -> parseFloat($attrs.blockRatio) || 250
    $scope.maxCols = -> parseInt($attrs.maxCols, 10) || 250
        
    $scope.numCols = -> 
      cnt = Math.floor($element.width()/$scope.minBlockWidth())
      if cnt > $scope.maxCols() then $scope.maxCols() else cnt

    $scope.blockWidth = -> Math.floor($element.width()/$scope.numCols()) - ($scope.blockMargin()/$scope.numCols()) - 1
    $scope.blockHeight = -> Math.floor($scope.blockWidth() * parseFloat($scope.blockRatio()))
    $scope.fixedHeight = -> $scope.blockHeight() if $scope.blockRatio()?

    $scope.initializeColumnArray = ->
      $scope.columns = []

    $scope.initializeColumnArray()  

    $scope.addBlock = (block) ->
      $scope.blocks.push block
      column = ($scope.blocks.length % ($scope.numCols()))
      $scope.columns[column] = [] unless $scope.columns[column]
      $scope.columns[column].push(block)
      console.log('column', column, 'blocks', $scope.columns[column])
      
    $scope

  
    # $scope.resizeGrid = ->  
    #   if $scope.lastNumCols? && $scope.lastNumCols != numCols()
    #     $scope.changeColumnCount()

    # $scope.changeColumnCount = ->
    #   # unless _.isEmpty($scope.columns)
    #   $scope.initializeColumnArray()   
    #   $scope.addBlocksToColumnArray()   
    #   $scope.addBlocksToGrid()
    #   $scope.setCssDefaults()

    # @initialize = ->
    #   $scope.changeColumnCount()
    #   @removeTransclusion()
    #   $scope.setCssDefaults()
    #   $scope.resizeGrid()

    # $rootScope.$on "resizeWindow", ->
    #   $scope.resizeGrid()


#-------------------------------------------------
# FLUID-COLUMN
#-------------------------------------------------


App.directive "fluidColumn", ($timeout) ->
  require: "^fluidGrid"
  restrict: "EA"
  scope: 
    column: "="

  compile: (cElement, cAttr, transclude) ->
    (scope, iElement, iAttrs, gridCtrl) ->
      debugger
      iElement
        .css("width", gridCtrl.blockWidth())
        .css("margin-right", gridCtrl.blockMargin)
        .css("display", "inline-block")

      scope.$watchCollection 'column', (collection) ->        
        angular.forEach collection, (block) ->
          transclude block.scope, (clone) ->
            iElement.append block.el


#-------------------------------------------------
# FLUID-BLOCK
#-------------------------------------------------

App.directive "fluidBlock", ($timeout) ->
  require: "^fluidGrid"
  restrict: "EA"
  transclude: true

  template: """
    <div class='fluid-block' ng-transclude></div>
  """

  link: (scope, element, attrs, gridCtrl) ->
    element.css("margin-bottom", gridCtrl.blockMargin)
    
    if gridCtrl.fixedHeight()
      element
        .css("height", gridCtrl.fixedHeight())
        .css("width", "100%")
        .css("display", "inline-block")

    gridCtrl.addBlock
      scope: scope
      el: element
    