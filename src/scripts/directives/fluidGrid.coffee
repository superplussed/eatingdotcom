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
      <fluid-column ng-repeat='column in columns' blocks='column.blocks'></fluid-column>
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
      for i in [0..numCols() - 1]
        $scope.columns[i] = {num: i + 1, blocks: []}

    $scope.initializeColumnArray()  

    @addBlock = (block) ->
      $scope.blocks.push block
      column = ($scope.blocks.length % numCols())
      $scope.columns[column].blocks.push(block)
      

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
    blocks: "="
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
  template: """
    <div class='fluid-column'>
      <div ng-repeat='block in blocks'>
        {{block.id}}
      </div>
    </div>
  """

  link: (scope, element, attrs, gridCtrl) ->
    scope.$watch 'attrs.fluid-column'



#-------------------------------------------------
# FLUID-BLOCK
#-------------------------------------------------

App.directive "fluidBlock", ($timeout) ->
  require: "^fluidGrid"
  restrict: "EA"
  transclude: 'element'

  # template: """
  #   <div class='fluid-block' 
  #     style='
  #       width: 100%;
  #       height: 100%; 
  #       display:inline-block',
  #     ng-style="{
  #       height: gridCtrl.fixedHeight(),
  #       margin-bottom: gridCtrl.blockMargin
  #     }"
  #   >
  #     <div ng-transclude></div>
  #   </div>
  # """

  compile: (cElement, cAttrs, transclude) ->
    (scope, iElement, iAttrs, gridCtrl) ->
      gridCtrl.addBlock
        id: scope.$id
        scope: scope
        element: iElement
    

    # $timeout( ->
    #   if scope.$last || attrs.lastBlock
    #     gridCtrl.initialize()
    # , 500)