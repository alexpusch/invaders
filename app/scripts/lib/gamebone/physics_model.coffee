Model = require './model'
Physics = require 'physicsjs'
_ = require "lodash"

module.exports = class PhysicsModel extends Model
  physicsInternals = ["cof", "hidden", "mass", "offset", "restitution", "treatment", "uid"]
  stateInternals = ["state.pos", "state.vel", "state.acc",
                    "state.pos.x", "state.vel.x", "state.acc.x",
                    "state.pos.y", "state.vel.y", "state.acc.y",
                    "state.angular.pos", "state.angular.vel", "state.angular.acc", 
                  ]
  constructor: ->
    @body = Physics.body @physicsBody, @physicsAttrs
    @body.model = this
    super

  update: ->

  get: (attr) ->
    if _(_.union(physicsInternals, stateInternals)).contains attr
      @_getInnerValue @body, attr
    else
      super

  set: (attr, value, options) ->
    if _(_.union(physicsInternals, stateInternals)).contains attr
      @_setInnerValue @body, attr, value

    if _(stateInternals).contains attr
      super(attr, value, silent: true)
    else
      super

  _setInnerValue: (obj, attrPath, value) ->
    parts = attrPath.split(".")
    for part, i in parts
      if i == parts.length - 1
        obj[part] = value
      else
        obj = obj[part]

  _getInnerValue: (obj, attrPath) ->
    parts = attrPath.split(".")
    for part, i in parts
      obj = obj[part]

    obj

physicsMethods = [ "aabb", "accelerate", "applyForce", "getGlobalOffset", "recalc", "setWorld", "sleep", "sleepCheck", "toBodyCoords", "toWorldCoords", "getCOM" ]
_.each physicsMethods, (method) ->
  PhysicsModel.prototype[method] = ->
    @body[method].apply(@body, arguments)