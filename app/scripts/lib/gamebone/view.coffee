PIXI = require "pixi"
Events = require("backbone").Events
_ = require "lodash"

module.exports = class View
  constructor: (options)->
    {@el} = options
    @initialize? options

  render: ->
    @_ensureElement()
    @create?()

    @el

  update: ->

  _ensureElement: ->
    unless @el?
      @el = new PIXI.DisplayObjectContainer

_.extend View.prototype, Events
