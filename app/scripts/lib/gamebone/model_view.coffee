PIXI = require "pixi"
View = require "./view"

module.exports = class ModelView extends View
  constructor: (options)->
    super
    {@model} = options