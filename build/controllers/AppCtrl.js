(function() {
  App.controller("AppCtrl", [
    '$window', '$state', '$stateParams', 'SiteCollectionService', '$rootScope', '$scope', function($window, $state, $stateParams, SiteCollectionService, $rootScope, $scope) {
      $rootScope.siteCollection = SiteCollectionService;
      $rootScope.siteCollection.initialize();
      $rootScope.state = $state;
      $rootScope.params = $stateParams;
      $rootScope.offlineMode = false;
      $window.onresize = function() {
        return $rootScope.$broadcast("resizeWindow");
      };
      $scope.goto = function(name) {
        return $state.transitionTo("main.site", {
          site_id: name
        });
      };
      if (!$rootScope.offlineMode) {
        return $(function() {
          return WebFont.load({
            typekit: {
              id: "yyo6olf"
            }
          });
        });
      }
    }
  ]);

}).call(this);
