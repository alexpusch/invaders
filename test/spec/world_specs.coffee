World = require "./.tmp/scripts/lib/gamebone/world"
Collection = require "./.tmp/scripts/lib/gamebone/collection"
PhysicsModel = require "./.tmp/scripts/lib/gamebone/physics_model"

describe "World", ->
  describe "addCollection", ->
    beforeEach ->
      class @.TestModel extends PhysicsModel
        physicsBody: "circle"
        physicsAttrs: 
          radius: 2

        constructor: ->
          super
          @update = jasmine.createSpy "update"

      @worldSpy = jasmine.createSpyObj "world", ["addBody", "removeBody", "step"]
      spyOn(Physics, "world").andReturn @worldSpy
      @world = new World

      @model1 = new @TestModel

      @model2 = new @TestModel

      @collection = new Collection [@model1, @model2]
      @world.addCollection @collection
      
    it "adds the collections models to the world", ->
      expect(@worldSpy.addBody).toHaveBeenCalledWith(@model1.body)
      expect(@worldSpy.addBody).toHaveBeenCalledWith(@model2.body)

    it "adds each model added to the collection to the world", ->
      model3 = new @TestModel
      @collection.add model3

      expect(@worldSpy.addBody).toHaveBeenCalledWith(model3.body)

    it "removes each model removed from the collection", ->
      @collection.remove @model1
      expect(@worldSpy.removeBody).toHaveBeenCalledWith @model1.body

    describe "update", ->
      it "updates each body from the collections added", ->
        @world.update()
        expect(@model1.update).toHaveBeenCalled()
        expect(@model2.update).toHaveBeenCalled()
