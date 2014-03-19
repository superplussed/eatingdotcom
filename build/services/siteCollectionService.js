(function() {
  App.factory("SiteCollectionService", [
    "$window", "$http", "$location", function($window, $http, $location) {
      var SiteCollectionService, self;
      SiteCollectionService = {
        list: [
          {
            name: "3rd Ward",
            dateRange: "Sept 2012 - Sept 2013",
            tech: [
              {
                name: "jQuery",
                type: "frontend"
              }, {
                name: "AngularJS",
                type: "frontend"
              }, {
                name: "Sass",
                type: "frontend"
              }, {
                name: "Ruby on Rails",
                type: "backend"
              }, {
                name: "MySQL",
                type: "backend"
              }, {
                name: "Elastic Search",
                type: "backend"
              }, {
                name: "Rspec",
                type: "backend"
              }, {
                name: "HAML",
                type: "backend"
              }, {
                name: "Amazon Web Services",
                type: "ops"
              }
            ],
            role: 'CTO, Lead Developer & Designer'
          }, {
            name: "Eat The Web",
            dateRange: "Sept 2013 - Present",
            tech: [
              {
                name: "Angular.js",
                type: "frontend"
              }, {
                name: "Coffeescript",
                type: "frontend"
              }, {
                name: "Jade",
                type: "frontend"
              }, {
                name: "Sass",
                type: "frontend"
              }, {
                name: "Node.js",
                type: "backend"
              }, {
                name: "Sails",
                type: "backend"
              }, {
                name: "MongoDB",
                type: "backend"
              }, {
                name: "Ruby",
                type: "backend"
              }, {
                name: "Grunt",
                type: "ops"
              }
            ],
            role: 'Project Creator'
          }, {
            name: "Robusto",
            dateRange: "2011-2012",
            role: 'Project Creator',
            tech: [
              {
                name: "Knockout.js",
                type: "frontend"
              }, {
                name: "jQuery",
                type: "frontend"
              }, {
                name: "D3.js",
                type: "frontend"
              }, {
                name: "SVG",
                type: "frontend"
              }, {
                name: "Sass",
                type: "frontend"
              }, {
                name: "Ruby",
                type: "backend"
              }, {
                name: "Sinatra",
                type: "backend"
              }, {
                name: "MongoDB",
                type: "backend"
              }, {
                name: "Elastic Search",
                type: "backend"
              }, {
                name: "Redis",
                type: "backend"
              }, {
                name: "Cucumber",
                type: "backend"
              }, {
                name: "Rspec",
                type: "backend"
              }, {
                name: "HAML",
                type: "backend"
              }
            ]
          }, {
            name: "Dropchart",
            dateRange: "2012",
            description: "A single page and open source project for creating drop-in charts built for maximum flexibility and minimum fuss.",
            role: 'Project Creator',
            tech: [
              {
                name: "Javascript",
                type: "frontend"
              }, {
                name: "Knockout.js",
                type: "frontend"
              }, {
                name: "jQuery",
                type: "frontend"
              }, {
                name: "Require.js",
                type: "frontend"
              }, {
                name: "Mocha",
                type: "frontend"
              }, {
                name: "SVG",
                type: "frontend"
              }, {
                name: "HAML",
                type: "frontend"
              }, {
                name: "Deployed to AWS - S3",
                type: "ops"
              }
            ]
          }, {
            name: "Xpert Sports",
            dateRange: "2003-2008, Sold in 2007 to Bodog Sports",
            description: "Xpert Sports was fantasy football league management software.",
            role: 'Sole Founder, Developer & Designer',
            tech: [
              {
                name: "Javascript",
                type: "frontend"
              }, {
                name: "Flash",
                type: "frontend"
              }, {
                name: "HTML",
                type: "frontend"
              }, {
                name: "CSS",
                type: "frontend"
              }, {
                name: "PHP",
                type: "backend"
              }, {
                name: "MySQL",
                type: "backend"
              }, {
                name: "Postgres",
                type: "backend"
              }
            ]
          }
        ],
        active: {},
        activeIndex: -1,
        destination: {},
        initialize: function() {
          var site, _i, _len, _ref, _results;
          _ref = self.list;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            site = _ref[_i];
            site.screenshots = self.screenshotArray(site.name, site.numScreenshots);
            _results.push(site.nameUnderscore = self.toUnderscore(site.name));
          }
          return _results;
        },
        hasTechType: function(site, type) {
          var technologies;
          technologies = _.find(self.list, {
            name: site.name
          }).technologies;
          return _.find(technologies, {
            type: type
          });
        },
        setActive: function(site) {
          self.active = site;
          self.activeIndex = self.list.indexOf(site);
          if (site != null) {
            return $location.path(site.nameUnderscore);
          }
        },
        nextProject: function() {
          var index;
          index = self.activeIndex + 1;
          if (index >= self.list.length) {
            index = 0;
          }
          return self.list[index].nameUnderscore;
        },
        prevProject: function() {
          var index;
          index = self.activeIndex - 1;
          if (index < 0) {
            index = self.list.length - 1;
          }
          return self.list[index].nameUnderscore;
        },
        isActive: function(site) {
          var _ref;
          return (site != null ? site.name : void 0) === ((_ref = self.active) != null ? _ref.name : void 0);
        },
        getActive: function() {
          return self.active;
        },
        siteFromName: function(name) {
          var site;
          site = _.find(self.list, {
            nameUnderscore: name
          });
          return site || self.list[0];
        },
        scrollToTop: function() {
          return self.scrollToContent(self.list[0]);
        },
        scrollToContent: function(site) {
          return TweenLite.to(window, 0.8, {
            scrollTo: {
              y: $("#" + site.nameUnderscore).position().top + 10
            },
            ease: Power2.easeOut
          });
        },
        toUnderscore: function(str) {
          return str.replace(/\s/g, '_').toLowerCase();
        },
        screenshotArray: function(name, num) {
          var _i, _results;
          return _.map((function() {
            _results = [];
            for (var _i = 1; 1 <= num ? _i <= num : _i >= num; 1 <= num ? _i++ : _i--){ _results.push(_i); }
            return _results;
          }).apply(this), function(n) {
            return "" + (self.toUnderscore(name)) + "_" + n + "_1000w.png";
          });
        }
      };
      self = SiteCollectionService;
      return SiteCollectionService;
    }
  ]);

}).call(this);
