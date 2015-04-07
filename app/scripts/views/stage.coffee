PIXI = require 'pixi'
Events = require('backbone').Events
_ = require("lodash");
Backbone = require("backbone")

class Stage
  constructor: (@options)->
    @canvas = @createCanvas()
    containerElement = @options.container
    containerElement.appendChild @canvas

    @stage = new PIXI.Stage(@options.backgroundColor, true)
    @stage.setBackgroundColor @options.backgroundColor

    @width = @canvas.width
    @height = @canvas.height

    @pixiRenderer = PIXI.autoDetectRenderer @width, @height,
      view: @canvas
      antialias: true

    @pixleRatio = window.devicePixelRatio
    @container = new PIXI.DisplayObjectContainer()
    @container.width = @width/@pixleRatio
    @container.height = @height/@pixleRatio
    @container.pivot = new PIXI.Point 0.5, 0.5
    @container.scale = new PIXI.Point @pixleRatio, @pixleRatio
    @stage.addChild @container

  createCanvas: ->
    canvas = document.createElement "canvas"
    canvas.style.width = "#{@options.width}px" 
    canvas.style.height = "#{@options.height}px" 
    canvas.width = @options.width * window.devicePixelRatio
    canvas.height = @options.height * window.devicePixelRatio
    canvas

  getCanvas: ->
    @canvas

  startMainLoop: ->
    mainLoop = =>
      unless @paused
        @trigger "frame"
        @render()
        requestAnimationFrame mainLoop

    mainLoop()

  pause: ->
    @paused = true

  resume: ->
    @paused = false
    @startMainLoop()

  getContainer: ->
    @container

  getPixiRenderer: ->
    @pixiRenderer

  render: ->
    @pixiRenderer.render(@stage)

  clear: ->
    while @container.children.length > 0
      @container.removeChild @container.children[0]

  getWidth: ->
    @container.width

  getHeight: ->
    @container.height

_.extend Stage.prototype, Backbone.Events

module.exports = Stage