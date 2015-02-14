ModelView = require "../lib/gamebone/model_view"
CollectionView = require "../lib/gamebone/collection_view"

class InvaderView extends ModelView
  create: ->
    image = @_getImage()
    texture = PIXI.Texture.fromImage(image);
    invaderGraphics = new PIXI.Sprite(texture);
    invaderGraphics.anchor.x = 0.5;
    invaderGraphics.anchor.y = 0.5;
    invaderGraphics.width = @model.physicsAttrs.width
    invaderGraphics.height = @model.physicsAttrs.height


    @el.addChild invaderGraphics

  update: ->
    @el.x = @model.get("state.pos.x")
    @el.y = @model.get("state.pos.y")

  _getImage: ->
    "images/invader#{@model.get('type')}.png"

class InvadersView extends CollectionView
    modelView: InvaderView

module.exports = {InvaderView, InvadersView}