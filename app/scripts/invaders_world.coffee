World = require "./lib/gamebone/world"
Bullet = require("./entities/bullet").Bullet
Invader = require("./entities/invaders").Invader

module.exports = class InvadersWorld extends World
  initialize: ->
    {@bounds, @interactiveEl} = @options

    @world.add [ 
      Physics.behavior "body-impulse-response"
      Physics.behavior "interactive",
        el: @interactiveEl
        maxVel: 
          x: 1
          y: 1
        minVel:
          x: -1
          y: -1
    ]

    bodyCollisionDetection = Physics.behavior "body-collision-detection"

    sweepPrune = Physics.behavior "sweep-prune"

    @world.add [bodyCollisionDetection, sweepPrune]

    @world.on "collisions:detected", (data) ->
      for c in data.collisions
        if c.bodyA.model instanceof Bullet && c.bodyB.model instanceof Invader
          bullet = c.bodyA.model
          invader = c.bodyB.model
        else if (c.bodyA.model instanceof Invader && c.bodyB.model instanceof Bullet)
          invader = c.bodyA.model
          bullet = c.bodyB.model
        else
          continue

        bullet["handle#{invader.constructor.name}Collision"] invader
        invader.hanldeBulletCollision bullet

  setBulletsCollection: (@bullets) ->
    @addCollection bullets

    constantAcceleration = Physics.behavior "constant-acceleration"
    @world.add constantAcceleration
    
    @_attachCollectionToBehavior bullets, constantAcceleration


  setInvadersCollection: (invaders) ->
    @addCollection invaders

  afterUpdate: ->
    @bullets.each (bullet) =>
      _.defer =>
        bulletAABB = bullet.body.aabb()
  
        unless Physics.aabb.overlap bulletAABB, @bounds
          bullet.handleWorldExit()

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