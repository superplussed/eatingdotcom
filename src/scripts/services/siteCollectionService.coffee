App.factory "SiteCollectionService", ["$window", "$http", "$location", ($window, $http, $location) ->
  SiteCollectionService =
    list: [
      name: "3rd Ward"
      dateRange: "Sept 2012 - Sept 2013"
      tech: [
        name: "Ruby on Rails"
        type: "backend"
      ,
        name: "MySQL"
        type: "backend"
      ,
        name: "Elastic Search"
        type: "backend"
      ,
        name: "Rspec"
        type: "backend"
      ,
        name: "HAML"
        type: "backend"
      ,
        name: "jQuery"
        type: "frontend"
      ,
        name: "AngularJS"
        type: "frontend"
      ,
        name: "Sass"
        type: "frontend"
      ,
        name: "Amazon Web Services"
        type: "ops"
      ]
      role: 'CTO, Lead Developer & Designer'
    ,
      name: "Eat The Web"
      dateRange: "Sept 2013 - Present"
      tech: [
        name: "Node.js"
        type: "backend"
      ,
        name: "Sails"
        type: "backend"
      ,
        name: "MongoDB"
        type: "backend"
      ,
        name: "Ruby"
        type: "backend"
      ,
        name: "Angular.js"
        type: "frontend"
      ,
        name: "Coffeescript"
        type: "frontend"
      ,
        name: "Jade"
        type: "frontend"
      ,
        name: "Sass"
        type: "frontend"
      ,
        name: "Grunt"
        type: "ops"
      ]
      role: 'Project Creator'
    ,
      name: "Robusto"
      dateRange: "2011-2012"
      role: 'Project Creator'
      technologies: [
        name: "Ruby"
        type: "backend"
      ,
        name: "Sinatra"
        type: "backend"
      ,
        name: "MongoDB"
        type: "backend"
      ,
        name: "Elastic Search"
        type: "backend"
      ,
        name: "Redis"
        type: "backend"
      ,
        name: "Cucumber"
        type: "backend"
      ,
        name: "Rspec"
        type: "backend"
      ,
        name: "HAML"
        type: "backend"
      ,
        name: "Knockout.js"
        type: "frontend"
      ,
        name: "jQuery"
        type: "frontend"
      ,
        name: "D3.js"
        type: "frontend"
      ,
        name: "SVG"
        type: "frontend"
      ,
        name: "Sass"
        type: "frontend"
      ]
    ,
      name: "Dropchart"
      dateRange: "2012"
      description: "A single page and open source project for creating drop-in charts built for maximum flexibility and minimum fuss."
      role: 'Project Creator'
      tech: [
        name: "Javascript"
        type: "frontend"
      ,
        name: "Knockout.js"
        type: "frontend"
      ,
        name: "jQuery"
        type: "frontend"
      ,
        name: "Require.js"
        type: "frontend"
      ,
        name: "Mocha"
        type: "frontend"
      ,
        name: "SVG"
        type: "frontend"
      ,
        name: "HAML"
        type: "frontend"
      ,
        name: "Deployed to AWS - S3"
        type: "ops"
      ]
    ,
      name: "Xpert Sports"
      dateRange: "2003-2008, Sold in 2007 to Bodog Sports"
      description: "Xpert Sports was fantasy football league management software."
      role: 'Sole Founder, Developer & Designer'
      tech: [
        name: "PHP"
        type: "backend"
      ,
        name: "MySQL"
        type: "backend"
      ,
        name: "Postgres"
        type: "backend"
      ,
        name: "Javascript"
        type: "frontend"
      ,
        name: "Flash"
        type: "frontend"
      ,
        name: "HTML"
        type: "frontend"
      ,
        name: "CSS"
        type: "frontend"
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