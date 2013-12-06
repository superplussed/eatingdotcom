App.controller("AppCtrl", ['$window', '$state', '$stateParams', 'SiteCollectionService', '$rootScope', '$scope', ($window, $state, $stateParams, SiteCollectionService, $rootScope, $scope) ->
  $rootScope.siteCollection = SiteCollectionService
  $rootScope.siteCollection.initialize()
  $rootScope.state = $state
  $rootScope.params = $stateParams

  $window.onresize = ->
    $rootScope.$broadcast "resizeWindow"

  $scope.goto = (name) ->
    $state.transitionTo("main.site", {site_id: name})

  $ ->
    WebFont.load
      typekit:
        id: "yyo6olf"

])