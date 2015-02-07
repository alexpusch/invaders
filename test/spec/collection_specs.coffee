Collection = require "./.tmp/scripts/lib/gamebone/collection"
Model = require "./.tmp/scripts/lib/gamebone/model"

describe "Collection", ->
  describe "onForever", ->
    beforeEach ->
      @model1 = new Model
      @model2 = new Model
      @collection = new Collection [@model1, @model2]

      @fn = jasmine.createSpy()
      @collection.onForever @fn

    it "applies a function on each of the collections models", ->
      expect(@fn).toHaveBeenCalledWith @model1
      expect(@fn).toHaveBeenCalledWith @model2

    it "applies a function on each model added to the collection", ->
      model3 = new Model
      @collection.add model3
      expect(@fn).toHaveBeenCalledWith model3