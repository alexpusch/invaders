Collection = require '../lib/gamebone/collection'
PhysicsModel = require '../lib/gamebone/physics_model'

class @Solid extends PhysicsModel
  physicsBody: "rectangle"
  physicsAttrs: 
    restitution: 0.5
    treatment: "static"

  initialize: (options) ->
    @body.geometry.width = options.width
    @body.geometry.height = options.height

class @Solids extends Collection