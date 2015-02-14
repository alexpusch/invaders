View = require "../lib/gamebone/view"

module.exports = class BackgroundView extends View
  cityImagePath = "images/city.png"
  cloudImagePath = "images/cloud.png"

  initialize: (options) ->
    { @height, @width } = options

  create: ->
    cityGraphics = @_createCityGraphics()
    @el.addChild cityGraphics

    cloudGraphics = @_createCloudGraphics()
    @el.addChild cloudGraphics
  
  _createCityGraphics: ->
    texture = PIXI.Texture.fromImage(cityImagePath);
    cityGraphics = new PIXI.Sprite(texture);
    cityGraphics.anchor.x = 0.5;
    cityGraphics.anchor.y = 1;
    cityGraphics.x = @width/2
    cityGraphics.y = @height

    r = @width / cityGraphics.width
    cityGraphics.width *= r 
    cityGraphics.height *= r  

    cityGraphics

  _createCloudGraphics: ->
    texture = PIXI.Texture.fromImage(cloudImagePath);
    cloudGraphics = new PIXI.Sprite(texture);
    cloudGraphics.anchor.x = 0.5;
    cloudGraphics.anchor.y = 0;
    cloudGraphics.x = @width * 0.6
    cloudGraphics.y = @height * 0.1

    cloudWidth = @width * 0.7
    r = cloudWidth / cloudGraphics.width
    cloudGraphics.width *= r 
    cloudGraphics.height *= r  

    cloudGraphics