(function() {
  App.directive("overlay", function() {
    return {
      restrict: "A",
      link: function(scope, element, attrs) {
        var defaultOpacity, hoverColor, hoverEl, overlayColor, transitionSpeed;
        overlayColor = attrs.overlayColor || "rgba(0, 0, 0, 0.75)";
        hoverColor = attrs.hoverColor || "rgba(0, 0, 0, 1)";
        transitionSpeed = attrs.transitionSpeed || 0.3;
        defaultOpacity = attrs.defaultOpacity || 0.7;
        $(element).css('position', 'relative').children().wrap("<div class='overlay'></div>");
        hoverEl = angular.element(element.children()[0]);
        hoverEl.css('-webkit-transition', "all " + transitionSpeed + "s ease-in-out").css('-moz-transition', "all " + transitionSpeed + "s ease-in-out").css('transition', "all " + transitionSpeed + "s ease-in-out").css('backgroundColor', overlayColor).css('position', 'absolute').css('height', '100%').css('width', '100%');
        hoverEl.bind('mouseleave', function(el) {
          return angular.element(el.currentTarget).css('backgroundColor', overlayColor);
        });
        return hoverEl.bind('mouseover', function(el) {
          return angular.element(el.currentTarget).css('backgroundColor', hoverColor);
        });
      }
    };
  });

}).call(this);
