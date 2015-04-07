ModelView = require "../lib/gamebone/model_view"
PIXI = require "pixi"

module.exports = class BulletView extends ModelView
  create: ->
    g = new PIXI.Graphics()
    g.lineStyle(0)
    g.beginFill(0xd84900, 1)
    g.drawCircle(0, 0, @model.physicsAttrs.radius)
    g.endFill()

    @el.addChild g

  update: ->
    @el.x = @model.get("state.pos.x")
    @el.y = @model.get("state.pos.y")