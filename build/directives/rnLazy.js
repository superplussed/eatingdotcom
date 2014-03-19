(function() {
  (function() {
    "use strict";
    angular.module("rn-lazy", []).directive("rnLazyBackground", [
      "$document", "$parse", function($document, $parse) {
        return {
          restrict: "A",
          link: function(scope, iElement, iAttrs) {
            var bgModel, loader, setLoading;
            setLoading = function(elm) {
              if (loader) {
                elm.html("");
                elm.append(loader);
                elm.css({
                  "background-image": null
                });
              }
            };
            loader = null;
            if (angular.isDefined(iAttrs.rnLazyLoader)) {
              loader = angular.element($document[0].querySelector(iAttrs.rnLazyLoader)).clone();
            }
            bgModel = $parse(iAttrs.rnLazyBackground);
            scope.$watch(bgModel, function(newValue) {
              var img, src;
              setLoading(iElement);
              src = bgModel(scope);
              img = $document[0].createElement("img");
              img.onload = function() {
                if (loader) {
                  loader.remove();
                }
                if (angular.isDefined(iAttrs.rnLazyLoadingClass)) {
                  iElement.removeClass(iAttrs.rnLazyLoadingClass);
                }
                if (angular.isDefined(iAttrs.rnLazyLoadedClass)) {
                  iElement.addClass(iAttrs.rnLazyLoadedClass);
                }
                iElement.css({
                  "background-image": "url(" + this.src + ")"
                });
              };
              img.onerror = function() {};
              img.src = src;
            });
          }
        };
      }
    ]);
  })();

}).call(this);
