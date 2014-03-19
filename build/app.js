(function() {
  angular.module('App.config', []).constant('siteOffset', 0);

  window.App = angular.module("App", ["ui.router", "App.config"]);

  App.config(function($httpProvider, $stateProvider, $urlRouterProvider, $locationProvider) {
    var default_page;
    default_page = "/";
    $urlRouterProvider.when("", default_page).otherwise(default_page);
    return $stateProvider.state("about", {
      url: "/about",
      templateUrl: 'templates/about.html'
    }).state("blog", {
      url: "/blog",
      templateUrl: 'templates/blog.html'
    }).state("work", {
      url: "/",
      templateUrl: 'templates/work.html'
    }).state("work.site", {
      url: "{site_id}",
      templateUrl: 'templates/work.site.html',
      controller: function($scope, $stateParams, SiteCollectionService) {
        $scope.site = SiteCollectionService.siteFromName($stateParams.site_id);
        return SiteCollectionService.setActive($scope.site);
      }
    });
  });

}).call(this);
