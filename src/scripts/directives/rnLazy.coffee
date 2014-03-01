#global angular
(->
  "use strict"
  angular.module("rn-lazy", []).directive "rnLazyBackground", [
    "$document"
    "$parse"
    ($document, $parse) ->
      return (
        restrict: "A"
        link: (scope, iElement, iAttrs) ->
          setLoading = (elm) ->
            if loader
              elm.html ""
              elm.append loader
              elm.css "background-image": null
            return
          loader = null
          loader = angular.element($document[0].querySelector(iAttrs.rnLazyLoader)).clone()  if angular.isDefined(iAttrs.rnLazyLoader)
          bgModel = $parse(iAttrs.rnLazyBackground)
          scope.$watch bgModel, (newValue) ->
            setLoading iElement
            src = bgModel(scope)
            img = $document[0].createElement("img")
            img.onload = ->
              loader.remove()  if loader
              iElement.removeClass iAttrs.rnLazyLoadingClass  if angular.isDefined(iAttrs.rnLazyLoadingClass)
              iElement.addClass iAttrs.rnLazyLoadedClass  if angular.isDefined(iAttrs.rnLazyLoadedClass)
              iElement.css "background-image": "url(" + @src + ")"
              return

            img.onerror = ->

            
            #console.log('error');
            img.src = src
            return

          return
      )
  ]
  return
)()