Collection = require '../lib/gamebone/collection'
PhysicsModel = require '../lib/gamebone/physics_model'

class Bullets extends Collection

class Bullet extends PhysicsModel
  physicsBody: "circle"

  physicsAttrs:
    radius: 20
    restitution: 0.9
    mass: 20
    x: 0
    y: 0

module.exports = 
  Bullet: Bullet
  Bullets: Bullets