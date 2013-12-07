#-------------------------------------------------
# FLUID-GRID
#-------------------------------------------------

App.directive "fluidGrid", ($window, $timeout, $rootScope) ->
  restrict: "EA"
  transclude: true
  replace: true
  # scope: 
    # minBlockWidth: "@"
    # blockMargin: "@"
    # blockRatio: "@"
    # maxCols: "@"
    # blocks: "="

  template: """
    <div class='fluid-grid' style='width:100%;display:inline-block;'>
      <fluid-column ng-repeat='thing in things' output='thing'></fluid-column>
      <div ng-transclude></div>
    </div>
  """
  compile: (cElement, cAttrs, transclude) ->
    (scope, iElement, iAttrs) ->
      elements = []
      scope.columns = []
      scope.things = []
      scope.$watchCollection scope.things, (thing) ->
        if elements.length > 0
          i = 0
          while i < elements.length
            elements[i].el.remove()
            elements[i].scope.$destroy()
            i++
          elements = []

        i = 0
        while i < scope.things.length
          
          childScope = $scope.$new()
          
          childScope[indexString] = things[i]
          transclude childScope, (clone) ->
            
            parent.append clone # add to DOM
            thing = {}
            thing.el = clone
            thing.scope = childScope
            elements.push thing

          i++

  controller: ($scope, $element, $attrs) ->

    defaults: 
      minBlockWidth: 250
      blockMargin: 4
      blockRatio: null
      maxCols: 2

    $scope.blocks = []
        
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

    @addThing = (thing) ->
      $scope.things.push thing
      console.log($scope.things)

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


#-------------------------------------------------
# FLUID-COLUMN
#-------------------------------------------------


App.directive "fluidColumn", ($timeout) ->
  require: "^fluidGrid"
  restrict: "EA"
  scope: 
    output: "="
  # template: """
  #   <div class='fluid-column' 
  #     style='
  #       display:inline-block;
  #     ',
  #     ng-style="{
  #       width: gridCtrl.blockWidth(),
  #       margin-right: gridCtrl.blockMargin()
  #     }"
  #   >
  #     <div ng-repeat="block in blocks">
  #       <fluid-block block='block'></fluid-block'>
  #     </div>
  #   </div>
  # """
  template: """
    <div class='fluid-column'>{{output}}</div>

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
  #       margin-bottom: gridCtrl.blockMargin()
  #     }"
  #   >
  #     <div ng-transclude></div>
  #   </div>
  # """

  compile: (cElement, cAttrs, transclude) ->
    (scope, iElement, iAttrs, gridCtrl) ->
      gridCtrl.addThing(scope.$id)
    

    # $timeout( ->
    #   if scope.$last || attrs.lastBlock
    #     gridCtrl.initialize()
    # , 500)