angular.module('App.config', [])
  .constant('siteOffset', 0)

window.App = angular.module("App", [
  "ui.router",
  "App.config"
])


App.config ($httpProvider, $stateProvider, $urlRouterProvider, $locationProvider) ->

  default_page = "/"

  $urlRouterProvider
    .when("", default_page)
    .otherwise(default_page)

  $stateProvider
    .state "main",
      url: "/"
      templateUrl: 'templates/main.html'

    .state "main.site",
      url: "{site_id}"
      templateUrl: 'templates/main.site.html'
      controller: ($scope, $stateParams, SiteCollectionService) ->
        $scope.site = SiteCollectionService.siteFromName($stateParams.site_id)
        SiteCollectionService.setActive($scope.site)
