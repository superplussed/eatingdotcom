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


    @initializeColumnArray = ->
      $scope.columns = []
      for i in [0..numCols() - 1]
        $scope.columns[i] = {num: i + 1, blocks: []}

    @addBlocksToColumnArray = ->
      _.each $scope.blocks, (block, i) ->
        column = (i % numCols())
        $scope.columns[column].blocks.push(block)

    @addBlocksToGrid = ->
      _.each $scope.columns, (column, colIndex) ->
        $element.append("<ul class='column'></ul>")
        columnEl = angular.element(_.last($element.find(".column")))
        _.each column.blocks, (block, blockIndex) ->
          columnEl.append("<li class='grid-block'></li>")
          blockEl = angular.element(_.last(columnEl.find(".grid-block")))
          blockEl.append(block.el)

    @addBlock = (block) ->
      $scope.blocks.push block

    @resizeGrid = ->  
      $element.find(".column")
        .css("width", blockWidth)

      $element.find(".column:not(:last)")
        .css("margin-right", blockMargin())

      if setHeight()
        $element.find(".grid-block")
          .css("height", blockHeight())

    @removeTransclusion = ->
      $element.find('.transcluded').remove()

    @setCssDefaults = ->
      $element.find(".column")
        .css("display", "inline-block")

      $element.find(".grid-block")
        .css("display", "inline-block")
        .css("width", "100%")
        .css("margin-bottom", blockMargin())

    @changeColumnCount = ->
      @initializeColumnArray()   
      @addBlocksToColumnArray()   
      @addBlocksToGrid()

    @initialize = ->
      @changeColumnCount()
      @removeTransclusion()
      @setCssDefaults()
      @resizeGrid()


    # scope.resizeBlock = (block, i) ->
    #   scope.debugStr = ""
    #   scope.displayDebug("numCols", scope.maxCols)
    #   scope.setAttribute(block.element, 'margin-bottom', scope.blockMargin())
    #   scope.setAttribute(block.element, 'width', scope.blockWidth())

    #   if scope.numCols() > 1
    #     scope.setAttribute(block.element, 'float', "left")

    #   if scope.setHeight()
    #     scope.setAttribute(block.element, 'height', scope.blockHeight())

    #   if scope.numCols() > 1 and scope.columnNum(i) < scope.numCols()
    #     scope.setAttribute(block.element, 'margin-right', scope.blockMargin())

    #   if !scope.setHeight() && scope.numCols() > 1
    #     scope.displayDebug("origHeight", block.element.height())
    #     offset = scope.getHeightOffset(i, block)
    #     scope.setAttribute(block.element, 'margin-top', offset) if offset < 0
    #   else if scope.numCols() == 1
    #     scope.setAttribute(block.element, 'margin-top', 0)

    #   if scope.debug
    #     block.element.find(".debug-wrapper").remove()
    #     block.element.children().first().prepend("<div class='debug-wrapper'><ul class='debug'>"+ scope.debugStr + "</ul></div>")

    # scope.setAttribute = (el, attr, value) ->
    #   scope.displayDebug(attr, value)
    #   el.css(attr, value)

    # scope.displayDebug = (attr, value) ->
    #   scope.debugStr += "<li>" + attr + ": " + value + "</li>"




    # scope.getHeightOffset = (i, block) ->
    #   offset = 0
    #   height = block.element.height()
    #   myColumnNum = scope.columnNum(i)
    #   col = scope.columns[myColumnNum]

    #   if i >= scope.numCols() && myColumnNum == 1
    #     otherColumns = _.omit(scope.columns, myColumnNum)
    #     largestColumn = _.max(otherColumns, (column) -> column.height)
    #     scope.displayDebug("largestHeight", largestColumn.height)
    #     offset = col.height - largestColumn.height if largestColumn.height > col.height

    #   col.height = col.height + height + scope.blockMargin()
    #   offset










  # controller: ($scope, $element, $attrs, $timeout, $rootScope) ->
  #   $scope.columns = []
  #   $scope.blocks = []
  #   $rootScope.$on "resizeWindow", ->
  #     $scope.resizeGrid()

  #   $scope.resetColumns = ->
  #     $scope.columns = []
  #     for i in [0..$scope.numCols() - 1]
  #       $scope.columns[i] = {num: i + 1, blocks: []}

  #   $scope.registerBlock = (block) ->
  #     $scope.blocks.push(block)


  #   $scope


# app.directive "gridBlock", ->
#   transclude: "element"
#   compile: (element, attr, linker) ->
#     ($scope, $element, $attr) ->

App.directive "gridBlock", ($timeout) ->
  require: "^grid"
  restrict: "EA"

  link: (scope, element, attrs, gridCtrl) ->
    element.addClass("grid-block")

    gridCtrl.addBlock 
      scope: scope
      el: element

    $timeout( ->
      if scope.$last || attrs.lastBlock
        gridCtrl.initialize()
    , 500)

# # ------------------------------------------------
# App.directive "gridBlock", ($timeout) ->
#   restrict: "AC"
#   require: "^grid"

#   link: (scope, element, attrs, gridCtrl) ->
#     element.css("position", "relative")
#     gridCtrl.registerBlock
#       element: element
#       scope: scope

#     $timeout( ->
#       if scope.$last || attrs.lastBlock
#         gridCtrl.resizeGrid()
#     , 500)