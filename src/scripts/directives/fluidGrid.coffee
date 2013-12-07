#
# FLUID-GRID
#

App.directive "fluidGrid", ($window, $timeout, $rootScope) ->
  restrict: "EA"
  transclude: true
  replace: true
  scope: 
    minBlockWidth: "@"
    blockMargin: "@"
    blockRatio: "@"
    maxCols: "@"

  template: """
    <div class='fluid-grid' style='width:100%;display:inline-block;'>
      <fluid-column ng-repeat="column in columns">
        <div ng-transclude></div>
      </fluid-column>
    </div>
  """
  compile: (cElement, attrs) ->

  controller: ($scope, $element, $attrs) ->

    defaults: 
      minBlockWidth: 250
      blockMargin: 4
      blockRatio: null
      maxCols: 2

    $scope.blocks = []
    $scope.columns = []
        
    blockWidth = -> Math.floor(gridCtrl.width()/gridCtrl.numCols()) - (blockMargin()/gridCtrl.numCols()) - 1
    blockHeight = -> Math.floor(blockWidth() * blockRatio)
    fixedHeight = -> blockHeight() if $scope.blockRatio?

    numCols = -> 
      cnt = Math.floor($element.width()/minBlockWidth)
      if cnt > maxCols then maxCols else cnt


    $scope.initializeColumnArray = ->
      $scope.columns = []
      for i in [0..numCols() - 1]
        $scope.columns[i] = {num: i + 1, blocks: []}

    $scope.addBlocksToColumnArray = ->
      _.each $scope.blocks, (block, i) ->
        column = (i % numCols())
        $scope.columns[column].blocks.push(block)

    @addBlock = (block) ->
      $scope.blocks.push block

    $scope.resizeGrid = ->  
      if $scope.lastNumCols? && $scope.lastNumCols != numCols()
        $scope.changeColumnCount()

    $scope.changeColumnCount = ->
      # unless _.isEmpty($scope.columns)
      $scope.initializeColumnArray()   
      $scope.addBlocksToColumnArray()   
      $scope.addBlocksToGrid()
      $scope.setCssDefaults()

    @initialize = ->
      $scope.changeColumnCount()
      @removeTransclusion()
      $scope.setCssDefaults()
      $scope.resizeGrid()

    $rootScope.$on "resizeWindow", ->
      $scope.resizeGrid()


#
# FLUID-COLUMN
#


App.directive "fluidColumn", ($timeout) ->
  require: "^grid"
  restrict: "EA"
  template: """
    <div class='fluid-column' 
      style='
        display:inline-block;
      ',
      ng-style="{
        width: gridCtrl.blockWidth(),
        margin-right: gridCtrl.blockMargin()
      }"
    >
      <fluid-block ng-repeat="block in blocks">
      </fluid-block>
    </div>

  """

  link: (scope, element, attrs, gridCtrl) ->
    gridCtrl

  controller: ($scope)



#
# FLUID-BLOCK
#


App.directive "fluidBlock", ($timeout) ->
  require: "^grid"
  restrict: "EA"

  template: """
    <div class='fluid-block' 
      style='
        width: 100%;
        height: 100%; 
        display:inline-block',
      ng-style="{
        height: gridCtrl.fixedHeight(),
        margin-bottom: gridCtrl.blockMargin()
      }"
      >
    </div>
  """

  link: (scope, element, attrs, gridCtrl) ->

    gridCtrl.addBlock 
      scope: scope
      el: element

    $timeout( ->
      if scope.$last || attrs.lastBlock
        gridCtrl.initialize()
    , 500)