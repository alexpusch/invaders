{Bullet, Bullets} = require "./bullet"

module.exports = class BulletsController
  constructor: (options) ->
    {@bullets, @width, @height, @n} = options
    
    @bullets.on "hitInvader", (bullet) =>
      @bullets.remove bullet

    @bullets.on "exitWorld", (bullet) =>
      @bullets.remove bullet

  startSpawning: ->
    @spawn()

    setInterval =>
      if @bullets.length < 3
        @spawn()
    , 2000

  spawn: ->
    x = _.random 0, @width
    y = _.random @height/2, @height
    r = 20

    bullet = new Bullet
    bullet.set "state.pos.x", x
    bullet.set "state.pos.y", y

    @bullets.add bullet