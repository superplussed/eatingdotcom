angular.module('App.config', ['ngDisqus'])

window.App = angular.module("App", [
  "ui.router",
  "App.config"
])

App.config ($disqusProvider, $httpProvider, $stateProvider, $urlRouterProvider, $locationProvider) ->
  
  default_page = "/"
  $locationProvider.hashPrefix('!')
  window.disqus_shortname = "eatingdotcom"

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
      controller: ($scope) ->
        $scope.templateLoaded = ->
          Prism.highlightAll()

    .state "blog.entry",
      url: "/{blog_id}"
      templateUrl: 'templates/blog.entry.html'
      controller: ($scope, BlogService) ->
        $scope.disqus_id = $scope.params.blog_id
        $scope.blog_entry = _.where(BlogService.list, {template: $scope.params.blog_id})[0]
      
    .state "work",
      url: "/"
      templateUrl: 'templates/work.html'

    .state "work.site",
      url: "{site_id}"
      templateUrl: 'templates/work.site.html'
      controller: ($scope, $stateParams, SiteCollectionService) ->
        $scope.site = SiteCollectionService.siteFromName($stateParams.site_id)
        SiteCollectionService.setActive($scope.site)
