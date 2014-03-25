angular.module('App.config', ['ngDisqus'])

window.App = angular.module("App", [
  "ui.router",
  "App.config"
])

App.config ($disqusProvider, $httpProvider, $stateProvider, $urlRouterProvider, $locationProvider) ->
  
  default_page = "/"
  $locationProvider.hashPrefix('!')
  $disqusProvider.setShortName = "eatingdotcom"

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

    .state "blog.entry",
      url: "/{blog_id}"
      templateUrl: 'templates/blog.entry.html'
      controller: ($scope) ->
        debugger

    .state "work",
      url: "/"
      templateUrl: 'templates/work.html'

    .state "work.site",
      url: "{site_id}"
      templateUrl: 'templates/work.site.html'
      controller: ($scope, $stateParams, SiteCollectionService) ->
        $scope.site = SiteCollectionService.siteFromName($stateParams.site_id)
        SiteCollectionService.setActive($scope.site)
