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

    maxCols = if $attrs.maxCols? then parseFloat($attrs.maxCols) else 2
    minBlockWidth = if $attrs.minBlockWidth? then parseFloat($attrs.minBlockWidth) else 250
    defaultNumCols = -> Math.floor($element.width()/minBlockWidth)
    numCols = -> if defaultNumCols() > maxCols then maxCols else defaultNumCols()
    $scope.blocks = []
    $scope.columns = []

    addColumns = ->
      _.each $scope.columns, (column, colIndex) ->
        $element.append("<ul class='column'></ul>")
        columnEl = angular.element(_.last($element.find(".column")))
        _.each column.blocks, (block, blockIndex) ->
          blockEl = columnEl.append("<li class='block'></li>")
          blockEl.append(block.el)

    resetColumns = ->
      $scope.columns = []
      for i in [0..numCols() - 1]
        $scope.columns[i] = {num: i + 1, blocks: []}

    @addBlock = (block) ->
      $scope.blocks.push block

    @resizeGrid = ->
      resetColumns()
      _.each $scope.blocks, (block, i) ->
        column = (i % numCols())
        $scope.columns[column].blocks.push(block)
      addColumns()

    @removeTransclusion = ->
      $element.find('.transcluded').remove()

    



    # scope.blockRatio = if attrs.blockRatio? then parseFloat(attrs.blockRatio) else null
    # scope.blockMargin = ->
    #   if attrs.blockMargin? then parseFloat(attrs.blockMargin) else 4
    # scope.setHeight = -> scope.blockRatio?
    # scope.blockWidth = -> Math.floor(element.width()/scope.numCols()) - (scope.blockMargin()/scope.numCols()) - 1
    # scope.blockHeight = -> Math.floor(scope.blockWidth() * scope.blockRatio)
    # scope.columnNum = (i) -> (i % scope.numCols()) + 1


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
  transclude: true
  replace: true
  template: "<div ng-transclude></div>"

  link: (scope, element, attrs, gridCtrl) ->
    gridCtrl.addBlock 
      scope: scope
      el: element
      test: 3

    $timeout( ->
      if scope.$last || attrs.lastBlock
        gridCtrl.removeTransclusion()
        gridCtrl.resizeGrid()
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