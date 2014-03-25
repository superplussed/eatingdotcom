App.factory "BlogService", ["$http", "$location", ($http, $location) ->

  BlogService = [
    template: "berlin-vs-new-york"
    date: "04-01-2013"
    title: "Berlin vs New York"
  ]

  self = BlogService
  BlogService

]