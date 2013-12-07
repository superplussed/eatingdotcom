App.directive "grid", ($window, $timeout, $rootScope) ->
  restrict: "EA"
  transclude: true
  replace: true
  scope: {}
  template: """
    <div class='grid'>
      <div class='transcluded' style='display:none' ng-transclude></div>
    </div>
  """
  link: (scope, element, attrs) ->
    element
      .css("width", "100%")
      .css("display", "inline-block")

  controller: ($scope, $element, $attrs) ->

    blockMargin = ->
      if $attrs.blockMargin? then parseFloat($attrs.blockMargin) else 4
    blockRatio = if $attrs.blockRatio? then parseFloat($attrs.blockRatio) else null
    setHeight = -> blockRatio?
    blockWidth = -> Math.floor($element.width()/numCols()) - (blockMargin()/numCols()) - 1
    blockHeight = -> Math.floor(blockWidth() * blockRatio)
    columnNum = (i) -> (i % numCols()) + 1

    maxCols = if $attrs.maxCols? then parseFloat($attrs.maxCols) else 2
    minBlockWidth = if $attrs.minBlockWidth? then parseFloat($attrs.minBlockWidth) else 250
    defaultNumCols = -> Math.floor($element.width()/minBlockWidth)
    numCols = -> if defaultNumCols() > maxCols then maxCols else defaultNumCols()
    $scope.blocks = []
    $scope.columns = []


    $scope.initializeColumnArray = ->
      $scope.columns = []
      for i in [0..numCols() - 1]
        $scope.columns[i] = {num: i + 1, blocks: []}

    $scope.addBlocksToColumnArray = ->
      _.each $scope.blocks, (block, i) ->
        column = (i % numCols())
        $scope.columns[column].blocks.push(block)

    $scope.addBlocksToGrid = ->
      $element.find(".column").remove()
      _.each $scope.columns, (column, colIndex) ->
        $element.append("<ul class='column'></ul>")
        columnEl = angular.element(_.last($element.find(".column")))
        _.each column.blocks, (block, blockIndex) ->
          columnEl.append("<li class='grid-block-wrapper'></li>")
          blockEl = angular.element(_.last(columnEl.find(".grid-block-wrapper")))
          blockEl.append(block.el)
      $scope.$apply()

    @addBlock = (block) ->
      $scope.blocks.push block

    $scope.resizeGrid = ->  
      if $scope.lastNumCols? && $scope.lastNumCols != numCols()
        $scope.changeColumnCount()

      $element.find(".column")
        .css("width", blockWidth)

      $element.find(".column:not(:last)")
        .css("margin-right", blockMargin())

      if setHeight()
        $element.find(".grid-block-wrapper")
          .css("height", blockHeight())

      $scope.lastNumCols = numCols()

    @removeTransclusion = ->
      $element.find('.transcluded').remove()

    $scope.setCssDefaults = ->
      $element.find(".column")
        .css("display", "inline-block")

      $element.find(".grid-block-wrapper")
        .css("display", "inline-block")
        .css("width", "100%")
        .css("margin-bottom", blockMargin())

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


App.directive "gridBlock", ($timeout) ->
  require: "^grid"
  restrict: "EA"

  link: (scope, element, attrs, gridCtrl) ->
    element
      .addClass("grid-block")
      .css("width", "100%")
      .css("height", "100%")

    gridCtrl.addBlock 
      scope: scope
      el: element

    $timeout( ->
      if scope.$last || attrs.lastBlock
        gridCtrl.initialize()
    , 500)