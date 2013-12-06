App.factory "SiteCollectionService", ["$window", "$http", "$location", ($window, $http, $location) ->
  SiteCollectionService =
    list: [
      name: "3rd Ward"
      dateRange: "Sept 2012 - Sept 2013"
      technologies: [
        type: "backend"
        tech: [
          name: "Ruby on Rails"
          rating: 4
        ,
          name: "MySQL"
          rating: 3
        ,
          name: "Elastic Search"
          rating: 3
        ,
          name: "Rspec"
          rating: 3
        ,
          name: "HAML"
          rating: 4
        ]
      ,
        type: "frontend"
        tech: [
          name: "jQuery"
          rating: 3
        ,
          name: "AngularJS"
          rating: 4
        ,
          name: "Sass"
          rating: 4
        ]
      ,
        type: "ops"
        tech: [
          name: "Amazon Web Services"
          rating: 3
        ]
      ]
      role: 'CTO, Lead Developer & Designer'
    ,
      name: "Eat The Web"
      dateRange: "Sept 2013 - Present"
      technologies: [
        type: "backend"
        tech: [
          name: "Node.js"
          rating: 2
        ,
          name: "Sails"
          rating: 2
        ,
          name: "MongoDB"
          rating: 3
        ,
          name: "Ruby"
          rating: 4
        ]
      ,
        type: "frontend"
        tech: [
          name: "Angular.js"
          rating: 3
        ,
          name: "Coffeescript"
          rating: 3
        ,
          name: "Jade"
          rating: 4
        ,
          name: "Sass"
          rating: 4
        ]
      ,
        type: "ops"
        tech: [
          name: "Grunt"
          rating: 2
        ]
      ]
      role: 'Project Creator'
    ,
      name: "Robusto"
      dateRange: "2011-2012"
      role: 'Project Creator'
      technologies: [
        type: "backend"
        tech: [
          name: "Ruby"
          rating: 4
        ,
          name: "Sinatra"
          rating: 2
        ,
          name: "MongoDB"
          rating: 3
        ,
          name: "Elastic Search"
          rating: 3
        ,
          name: "Redis"
          rating: 2
        ,
          name: "Cucumber"
          rating: 3
        ,
          name: "Rspec"
          rating: 3
        ,
          name: "HAML"
          rating: 4
        ]
      ,
        type: "frontend"
        tech: [
          name: "Knockout.js"
          rating: 3
        ,
          name: "jQuery"
          rating: 3
        ,
          name: "D3.js"
          rating: 2
        ,
          name: "SVG"
          rating: 2
        ,
          name: "Sass"
          rating: 4
        ]
      ]
    ,
      name: "Dropchart"
      dateRange: "2012"
      description: "A single page and open source project for creating drop-in charts built for maximum flexibility and minimum fuss."
      role: 'Project Creator'
      technologies: [
        type: "frontend"
        tech: [
          name: "Javascript"
          rating: 4
        ,
          name: "Knockout.js"
          rating: 3
        ,
          name: "jQuery"
          rating: 3
        ,
          name: "Require.js"
          rating: 3
        ,
          name: "Mocha"
          rating: 3
        ,
          name: "SVG"
          rating: 2
        ,
          name: "HAML"
          rating: 4
        ]
      ,
        type: "ops"
        tech: [
          name: "Deployed to AWS - S3"
          rating: 3
        ]
      ]
    ,
      name: "Xpert Sports"
      dateRange: "2003-2008, Sold in 2007 to Bodog Sports"
      description: "Xpert Sports was fantasy football league management software."
      role: 'Sole Founder, Developer & Designer'
      technologies: [
        type: "backend"
        tech: [
          name: "PHP"
          rating: 3
        ,
          name: "MySQL"
          rating: 3
        ,
          name: "Postgres"
          rating: 3
        ]
      ,
        type: "frontend"
        tech: [
          name: "Javascript"
          rating: 4
        ,
          name: "Flash"
          rating: 3
        ,
          name: "HTML"
          rating: 4
        ,
          name: "CSS"
          rating: 4
        ]
      ]
    ]
    active: {}
    activeIndex: -1
    destination: {}

    initialize: ->
      for site in self.list
        site.screenshots = self.screenshotArray(site.name, site.numScreenshots)
        site.nameUnderscore = self.toUnderscore(site.name)

    hasTechType: (site, type) ->
      technologies = _.find(self.list, {name: site.name}).technologies
      _.find(technologies, {type: type})

    setActive: (site) ->
      self.active = site
      self.activeIndex = self.list.indexOf(site)
      $location.path(site.nameUnderscore) if site?

    nextProject: ->
      index = self.activeIndex + 1
      index = 0 if index >= self.list.length
      self.list[index].nameUnderscore

    prevProject: ->
      index = self.activeIndex - 1
      index = self.list.length - 1 if index < 0
      self.list[index].nameUnderscore

    isActive: (site) ->
      site?.name is self.active?.name

    getActive: ->
      self.active

    siteFromName: (name) ->
      site = _.find(self.list, {nameUnderscore: name})
      site or self.list[0]

    scrollToTop: ->
      self.scrollToContent(self.list[0])

    scrollToContent: (site) ->
      TweenLite.to(window, 0.8,
        scrollTo:
          y: $("#" + site.nameUnderscore).position().top + 10
        ease: Power2.easeOut
      )


    toUnderscore: (str) ->
      str.replace(/\s/g,'_').toLowerCase()
    screenshotArray:(name, num) ->
      _.map([1..num], (n) -> "#{self.toUnderscore(name)}_#{n}_1000w.png")


  self = SiteCollectionService
  SiteCollectionService
]