CollectionView = require "./.tmp/scripts/lib/gamebone/collection_view"

describe "CollectionView", ->
  beforeEach ->
    # create a spy class - a spy on the constuctor that returns a spy object
    window.TestModelView = jasmine.createSpy().andCallFake ->
      spyObj = jasmine.createSpyObj "testModelView", ["create", "update", "render"]
      spyObj.render.andReturn {}
      spyObj
    class @TestView extends CollectionView
      modelView: window.TestModelView

    @model1 = new Backbone.Model
    @model2 = new Backbone.Model

    @collection = new Backbone.Collection [@model1, @model2]

  describe "create", ->
    beforeEach ->
      @view = new @TestView 
        collection: @collection
      @view._ensureElement()
      @view.create()
      
    it "creates a model view for each model", ->
      expect(_.keys(@view.childViews).length).toEqual 2
      expect(@view._getModelView(@model1).render).toHaveBeenCalled()
      expect(@view._getModelView(@model2).render).toHaveBeenCalled()

    it "creates a model view for each new model added to the collection", ->
      model3 = new Backbone.Model
      @collection.add model3
      expect(_.keys(@view.childViews).length).toEqual 3
      expect(@view._getModelView(model3).render).toHaveBeenCalled()

    it "removes the model view of a removed model from the collection", ->
      @collection.remove @model1
      expect(_.keys(@view.childViews).length).toEqual 1      

    describe "update", ->
      it "calls the update function of each of the child views", ->
        @view.update()
        expect(@view._getModelView(@model1).update).toHaveBeenCalled()
        expect(@view._getModelView(@model2).update).toHaveBeenCalled()

    describe "render", ->
      it "cals the render function of each of the child views", ->
        @view.render()
        expect(@view._getModelView(@model1).render).toHaveBeenCalled()
        expect(@view._getModelView(@model2).render).toHaveBeenCalled()