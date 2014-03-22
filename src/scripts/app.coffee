angular.module('App.config', [])
  .constant('siteOffset', 0)

window.App = angular.module("App", [
  "ui.router",
  "App.config"
])


App.config ($httpProvider, $stateProvider, $urlRouterProvider, $locationProvider) ->

  $locationProvider.html5Mode(true);
  
  default_page = "/"

  $urlRouterProvider
    .when("", default_page)
    .otherwise(default_page)

  $stateProvider
    .state "about",
      url: "/about"
      templateUrl: 'templates/about.html'

    .state "blog",
      url: "/blog"
      templateUrl: 'templates/blog.html'

    .state "work",
      url: "/"
      templateUrl: 'templates/work.html'

    .state "work.site",
      url: "{site_id}"
      templateUrl: 'templates/work.site.html'
      controller: ($scope, $stateParams, SiteCollectionService) ->
        $scope.site = SiteCollectionService.siteFromName($stateParams.site_id)
        SiteCollectionService.setActive($scope.site)
