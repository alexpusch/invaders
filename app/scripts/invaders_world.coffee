World = require "./lib/gamebone/world"

module.exports = class InvadersWorld extends World
  initialize: ->
    {@bounds, @interactiveEl} = @options

    @world.add [ 
      Physics.behavior "body-impulse-response"
      Physics.behavior "edge-collision-detection",
        aabb: @bounds
        restitution: 0.2
        cof: 0.8
      Physics.behavior "interactive",
        el: @interactiveEl
        maxVel: 
          x: 1
          y: 1
        minVel:
          x: -1
          y: -1
    ]

    bodyCollisionDetection = Physics.behavior "body-collision-detection",
      check: "bullets-canidates"

    sweepPrune = Physics.behavior "sweep-prune",
      channel: "bullets-canidates"

    @world.add [bodyCollisionDetection, sweepPrune]

  setBulletsCollection: (bullets) ->
    @addCollection bullets

    constantAcceleration = Physics.behavior "constant-acceleration"
    @world.add constantAcceleration
    
    @_attachCollectionToBehavior bullets, constantAcceleration


  setInvadersCollection: (invaders) ->
    @addCollection invaders

  _attachCollectionToBehavior: (collection, behavior) ->
    bodies = @_getBodiesOf collection
    behavior.applyTo bodies

    collection.on "add", (model) =>
      targets = behavior.getTargets()
      targets.push model.body
      behavior.applyTo targets

  _getBodiesOf: (collection) ->
    collection.map (model) ->
      model.body