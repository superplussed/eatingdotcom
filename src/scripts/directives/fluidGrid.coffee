#-------------------------------------------------
# FLUID-GRID
#-------------------------------------------------

App.directive "fluidGrid", ($window, $timeout, $rootScope) ->
  restrict: "EA"
  transclude: true
  replace: true
  scope: 
    minBlockWidth: "@"
    blockMargin: "@"
    blockRatio: "@"
    maxCols: "@"
    # blocks: "="

  template: """
    <div class='fluid-grid' style='width:100%;display:inline-block;'>
      <fluid-column ng-repeat='column in columns' column='column'></fluid-column>
      <div ng-transclude></div>
    </div>
  """

  controller: ($scope, $element, $attrs) ->

    _.extend $scope, 
      minBlockWidth: 250
      blockMargin: 4
      blockRatio: null
      maxCols: 2

    $scope.blocks = []
    $scope.columns = []
        
    blockWidth = -> Math.floor($element.width()/numCols()) - ($scope.blockMargin/gridCtrl.numCols()) - 1
    blockHeight = -> Math.floor(blockWidth() * $scope.blockRatio)
    fixedHeight = -> blockHeight() if $scope.blockRatio?
    numCols = -> 
      cnt = Math.floor($element.width()/$scope.minBlockWidth)
      if cnt > $scope.maxCols then $scope.maxCols else cnt

    $scope.initializeColumnArray = ->
      $scope.columns = []

    $scope.initializeColumnArray()  

    @addBlock = (block) ->
      $scope.blocks.push block
      column = ($scope.blocks.length % (numCols()))
      $scope.columns[column] = [] unless $scope.columns[column]
      $scope.columns[column].push(block)
      console.log('column', column, 'blocks', $scope.columns[column])
      

    # $scope.addBlocksToColumnArray = ->
    #   _.each $scope.blocks, (block, i) ->
    #     column = (i % numCols())
    #     $scope.columns[column].blocks.push(block)


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
  # template: """
  #   <div class='fluid-column' 
  #     style='
  #       display:inline-block;
  #     ',
  #     ng-style="{
  #       width: gridCtrl.blockWidth(),
  #       margin-right: gridCtrl.blockMargin
  #     }"
  #   >
  #     <div ng-repeat="block in blocks">
  #       <fluid-block block='block'></fluid-block'>
  #     </div>
  #   </div>
  # """

  compile: (cElement, cAttr, transclude) ->
    (scope, iElement, iAttrs, gridCtrl) ->
      scope.$watchCollection 'column', (collection) ->        
        angular.forEach collection, (block) ->
          transclude block.scope, (clone) ->
            iElement.append block.el
            
      

  # controller: ($scope) ->
  #   $scope.$watch $scope.column, (newCol) ->
  #     debugger


#-------------------------------------------------
# FLUID-BLOCK
#-------------------------------------------------

App.directive "fluidBlock", ($timeout) ->
  require: "^fluidGrid"
  restrict: "EA"
  transclude: true

  template: """
    <div class='fluid-block'>
      <div ng-transclude></div>
    </div>
  """

  compile: (cElement, cAttrs, transclude) ->
    (scope, iElement, iAttrs, gridCtrl) ->
      gridCtrl.addBlock
        scope: scope
        el: iElement
    

    # $timeout( ->
    #   if scope.$last || attrs.lastBlock
    #     gridCtrl.initialize()
    # , 500)