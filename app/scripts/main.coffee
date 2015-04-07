Physics = require "physicsjs"
AssetLoader = require "./lib/asset_loader"
Stage = require "./views/stage"
{ Bullet, Bullets } = require "./entities/bullet"
BulletView = require "./views/bullet_view"
BulletsView = require "./views/bullets_view"
BulletsController = require "./entities/bullets_controller"
{ Invader, Invaders } = require "./entities/invaders"
{InvaderView, InvadersView} = require "./views/invader_view"
InvadersWorld = require "./invaders_world"
InvadersController = require "./entities/invaders_controller"
BackgroundView = require "./views/background_view"
{ Solid, Solids } = require "./entities/solid"

window.onload = ->
  # Physics.util.ticker.now = ->
  #   new Date()  
  AssetLoader.loadGraphicAssets [
    'images/city.png',
    'images/cloud.png',
    'images/invader1.png',
    'images/invader2.png',
    'images/invader3.png',
  ]
  .then ->
    width = window.innerWidth
    height = window.innerHeight

    stage = new Stage
      container: document.body
      width: width
      height: height
      backgroundColor: "0xd2ebfc"

    stage.startMainLoop()


    bounds = Physics.aabb(0, 0, width, height);
    world = new InvadersWorld
      bounds: bounds
      interactiveEl: window

    container = stage.getContainer()

    backGroundView = new BackgroundView {width, height}
    container.addChild backGroundView.render()

    bullets = new Bullets
    
    world.setBulletsCollection bullets

    bulletsController = new BulletsController
      bullets: bullets
      width: width
      height: height
      n: 3

    bulletsController.startSpawning()

    bulletsView = new BulletsView  
      collection: bullets

    container.addChild bulletsView.render()

    a = 0.8
    minX = (width - width * a) / 2
    maxX = minX + width*a
    minY = (height - height * a) / 2
    maxY = minY + height*a

    invadersBounds = Physics.aabb(minX, minY, maxX, maxY);

    invadersController = new InvadersController
      worldAABB: invadersBounds

    invaders = invadersController.createInvaders()

    world.setInvadersCollection invaders

    invadersView = new InvadersView
      collection: invaders

    container.addChild invadersView.render()
    
    floor = new Solid
      width: width
      height: 10

    floor.set "state.pos.x", width/2
    floor.set "state.pos.y", height

    rightWall = new Solid
      height: height/4
      width: 10

    rightWall.set("state.pos.x", width + 5)
    rightWall.set("state.pos.y", height - height/8)

    leftWall = new Solid
      height: height/4
      width: 10

    leftWall.set("state.pos.x", -5)
    leftWall.set("state.pos.y", height - height/8)

    solids = new Solids [floor, rightWall, leftWall]

    world.addCollection solids

    stage.on "frame", ->
      world.update()
      invadersController.update()
      bulletsView.update()
      invadersView.update()
      stage.render()

