App.controller("AppCtrl", ['$window', '$state', '$stateParams', 'SiteCollectionService', '$rootScope', '$scope', 'BlogService', ($window, $state, $stateParams, SiteCollectionService, $rootScope, $scope, BlogService) ->
  $rootScope.siteCollection = SiteCollectionService
  $rootScope.blogService = BlogService
  $rootScope.siteCollection.initialize()
  $rootScope.state = $state
  $rootScope.params = $stateParams
  $rootScope.offlineMode = false

  $window.onresize = ->
    $rootScope.$broadcast "resizeWindow"

  $scope.goto = (name) ->
    $state.transitionTo("main.site", {site_id: name})

  unless $rootScope.offlineMode
    $ ->
      WebFont.load
        typekit:
          id: "yyo6olf"


])