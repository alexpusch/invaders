Collection = require '../lib/gamebone/collection'
PhysicsModel = require '../lib/gamebone/physics_model'

class Invaders extends Collection
  initialize: (models) ->
    _(models).each (invader) ->
      invader.moveLeft()

class Invader extends PhysicsModel
  physicsBody: "rectangle"
  speed: 0.1
  physicsAttrs:
    width: 50
    height: 50
    mass: 100

  # update: ->
  #   movmentRange = @get "movmentRange"
  #   if @get("state.pos.x") > movmentRange.max 
  #     @moveLeft()
  #   else if @get("state.pos.x") < movmentRange.min
  #     @moveRight()

  moveLeft: ->
    @set "state.vel.x", -@speed

  moveRight: ->
    @set "state.vel.x", @speed


  hanldeBulletCollision: (bullet) ->
    @trigger "destroyed"

module.exports = 
  Invader: Invader
  Invaders: Invaders