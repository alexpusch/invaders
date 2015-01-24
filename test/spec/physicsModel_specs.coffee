PhysicsModel = require "./.tmp/scripts/lib/gamebone/physics_model"
#Physics = require 'physicsjs'

describe "PhysicsModel", ->
  beforeEach ->
    @spyBody = jasmine.createSpyObj "body", [ "aabb", "accelerate", "applyForce", "getGlobalOffset", "recalc", "setWorld", "sleep", "sleepCheck", "toBodyCoords", "toWorldCoords", "getCOM" ]
    @spyBody.state = 
      pos: 
        x: 0
        y: 0

    spyOn(Physics, "body").andReturn @spyBody
    @model = new PhysicsModel

  describe "physicsjs methods proxies", ->
    describe "aabb", ->
      it "should proxy the function to physicsjs body", ->
        @model.aabb()
        expect(@spyBody.aabb).toHaveBeenCalled

  describe "physicsjs attributes proxies", ->
    describe "set", ->
      it "sets the an argument of the body", ->
        @model.set("mass", 100)
        expect(@spyBody.mass).toEqual 100
      
      it "fires the change event", ->
        handler = jasmine.createSpy "handler"
        @model.on "change", handler
        @model.set "mass", 39
        expect(handler).toHaveBeenCalled()

      it "fiers the change:attr event", ->
        handler = jasmine.createSpy "handler"
        @model.on "change:mass", handler
        @model.set "mass", 39
        expect(handler).toHaveBeenCalled()        

    describe "get", ->
      it "gets the argument of the body", ->
        @spyBody.mass = 100
        expect(@model.get("mass")).toEqual 100

    describe "state attributes", ->
      it "sets the state.pos.x of the physicsjs body", ->
        @model.set("state.pos.x", 50)
        expect(@spyBody.state.pos.x).toEqual 50

      it "does not fire change events", ->
        handler = jasmine.createSpy "handler"
        @model.on "change", handler
        @model.set "state.pos.x", 39
        expect(handler).not.toHaveBeenCalled()

      it "does not fire change:attr events", ->
        handler = jasmine.createSpy "handler"
        @model.on "change:state.pos.x", handler
        @model.set "state.pos.x", 39
        expect(handler).not.toHaveBeenCalled()