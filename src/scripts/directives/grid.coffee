App.directive "grid", ($window, $timeout, $rootScope) ->
  transclude: true
  replace: false
  scope: {}
  template: "<section class='grid' style='display:inline-block;width:100%' ng-transclude></section>"

  link: (scope, element, attrs) ->
    scope.debug = false
    scope.debugStr = ""
    scope.columns = {}
    scope.blocks = []
    scope.blockRatio = if attrs.blockRatio? then parseFloat(attrs.blockRatio) else null
    scope.minBlockWidth = if attrs.minBlockWidth? then parseFloat(attrs.minBlockWidth) else 250
    scope.blockMargin = ->
      if attrs.blockMargin? then parseFloat(attrs.blockMargin) else 4
    scope.maxCols = if attrs.maxCols? then parseFloat(attrs.maxCols) else 2
    scope.defaultNumCols = -> Math.floor(element.width()/scope.minBlockWidth)
    scope.numCols = -> if scope.defaultNumCols() > scope.maxCols then scope.maxCols else scope.defaultNumCols()
    scope.setHeight = -> scope.blockRatio?
    scope.blockWidth = -> Math.floor(element.width()/scope.numCols()) - (scope.blockMargin()/scope.numCols()) - 1
    scope.blockHeight = -> Math.floor(scope.blockWidth() * scope.blockRatio)
    scope.columnNum = (i) -> (i % scope.numCols()) + 1
    scope.resetColumns = ->
      for i in [1..scope.numCols() + 1]
        scope.columns[i] = {height: 0}
    scope.blockSize = ->
      if scope.blockWidth() > 350 then "large" else "small"




    scope.resizeBlock = (block, i) ->
      scope.debugStr = ""
      scope.displayDebug("numCols", scope.maxCols)
      angular.element(block.element).attr('data-block-size', scope.blockSize())
      scope.setAttribute(block.element, 'margin-bottom', scope.blockMargin())
      scope.setAttribute(block.element, 'width', scope.blockWidth())

      if scope.numCols() > 1
        scope.setAttribute(block.element, 'float', "left")

      if scope.setHeight()
        scope.setAttribute(block.element, 'height', scope.blockHeight())

      if scope.numCols() > 1 and scope.columnNum(i) < scope.numCols()
        scope.setAttribute(block.element, 'margin-right', scope.blockMargin())

      if !scope.setHeight() && scope.numCols() > 1
        scope.displayDebug("origHeight", block.element.height())
        offset = scope.getHeightOffset(i, block)
        scope.setAttribute(block.element, 'margin-top', offset) if offset < 0
      else if scope.numCols() == 1
        scope.setAttribute(block.element, 'margin-top', 0)

      if scope.debug
        block.element.find(".debug-wrapper").remove()
        block.element.children().first().prepend("<div class='debug-wrapper'><ul class='debug'>"+ scope.debugStr + "</ul></div>")

    scope.setAttribute = (el, attr, value) ->
      scope.displayDebug(attr, value)
      angular.element(el).css(attr, value)

    scope.displayDebug = (attr, value) ->
      scope.debugStr += "<li>" + attr + ": " + value + "</li>"




    scope.getHeightOffset = (i, block) ->
      offset = 0
      height = block.element.height()
      myColumnNum = scope.columnNum(i)
      col = scope.columns[myColumnNum]

      if i >= scope.numCols() && myColumnNum == 1
        otherColumns = _.omit(scope.columns, myColumnNum)
        largestColumn = _.max(otherColumns, (column) -> column.height)
        scope.displayDebug("largestHeight", largestColumn.height)
        offset = col.height - largestColumn.height if largestColumn.height > col.height

      col.height = col.height + height + scope.blockMargin()
      offset




    scope.resizeGrid = ->
      scope.resetColumns()
      _.each scope.blocks, (block, i) ->
        scope.resizeBlock(block, i)

    scope.registerBlock = (block) ->
      scope.blocks.push(block)





  controller: ($scope, $element, $attrs, $timeout, $rootScope) ->
    $rootScope.$on "resizeWindow", ->
      $scope.resizeGrid()

    $scope

# ------------------------------------------------
App.directive "gridColumn", ($timeout) ->
  restrict: "AC"
  require: "^grid"

  link: (scope, element, attrs) ->
  
  controller: ($scope) ->
    scope.blocks = []


# ------------------------------------------------
App.directive "gridBlock", ($timeout) ->
  restrict: "AC"
  require: "^grid"

  link: (scope, element, attrs, gridCtrl) ->
    angular.element(element).css("position", "relative")
    gridCtrl.registerBlock
      element: element
      scope: scope

    # $timeout( ->
    #   if scope.$last || attrs.lastBlock
    #     gridCtrl.resizeGrid()
    # , 500)