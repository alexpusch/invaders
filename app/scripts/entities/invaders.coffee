Collection = require '../lib/gamebone/collection'
PhysicsModel = require '../lib/gamebone/physics_model'
_ = require "lodash"

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

  moveDown: ->
    @set "state.vel.y", @speed/6

  hanldeBulletCollision: (bullet) ->
    @trigger "destroyed"

module.exports = 
  Invader: Invader
  Invaders: Invaders