App.factory "BlogService", ["$http", "$location", ($http, $location) ->

  BlogService = 
    list: [
      template: "berlin-tech-scene"
      date: "04-01-2013"
      title: "Berlin Tech Scene"
    ]

  self = BlogService
  BlogService

]