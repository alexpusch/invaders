{ Invader, Invaders } = require "./invaders"
_ = require "lodash"

module.exports = class InvadersController
  constructor: (options = {} ) ->
    { @worldAABB } = options

  createInvaders: ->
    invaders = @invaders = new Invaders

    minX = @worldAABB.x - @worldAABB.hw
    maxX = @worldAABB.x + @worldAABB.hw
    minY = @worldAABB.y - @worldAABB.hh
    invaderWidth = 50
    invaderHeight = 50
    padding = 50
    invadersInLine = 3
    lines = 3

    for i in [0...invadersInLine]
      for j in [0...lines]
        x = i * (invaderWidth + padding) + minX
        y = j * (invaderHeight + padding) + minY

        invader = new Invader
          type: @_randomInvaderType()
          movmentRange:
            min: minX
            max: maxX

        invader.set "state.pos.x", x
        invader.set "state.pos.y", y
        invader.moveLeft()
        # invader.moveDown()
        invader.on "destroyed", ->
          invaders.remove this

        @invaders.add invader

    @invaders

  update: ->
    if @invaders.length > 0
      leftMostInvader = @getLeftmostInvader()
      if leftMostInvader.get("state.pos.x") < @worldAABB.x - @worldAABB.hw
        @invaders.each (invader) ->
          invader.moveRight()
      else
        rightMostInvader = @getRightmostInvader()
        if rightMostInvader.get("state.pos.x") > @worldAABB.x + @worldAABB.hw
          @invaders.each (invader) ->
            invader.moveLeft()

  getLeftmostInvader: ->
    @invaders.min (invader) ->
      invader.get "state.pos.x"

  getRightmostInvader: ->
    @invaders.max (invader) ->
      invader.get "state.pos.x"    

  getCollection: ->
    @invaders

  _randomInvaderType: ->
    _.random(1,3)
