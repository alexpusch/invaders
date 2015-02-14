Physics = require "physicsjs"
Collection = require "./collection"

module.exports = class World
  constructor: (@options) ->
    @world = new Physics.world
    @collection = new Collection()

    @initialize?()

  addCollection: (collection) ->
    collection.onForever (model) =>
      @collection.add model
      @world.addBody model.body

    collection.on "remove", (model) =>
      @collection.remove model
      @world.removeBody model.body     

  update: ->
    @world.step(new Date().getTime())
    @collection.each (model) ->
      model.update?()

  