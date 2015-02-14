{Bullet, Bullets} = require "./bullet"

module.exports = class BulletsSpawner
  constructor: (options) ->
    {@bullets, @width, @height, @n} = options

  startSpawning: ->
    for i in [0...@n]
      x = _.random 0, @width
      y = _.random @height/2, @height
      r = 20

      bullet = new Bullet
      bullet.set "state.pos.x", x
      bullet.set "state.pos.y", y

      @bullets.add bullet