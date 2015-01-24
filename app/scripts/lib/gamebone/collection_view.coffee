View = require "./view"

module.exports = class CollectionView extends View
  # modelView: 

  constructor: (options) ->
    super
    {@collection} = options
    @childViews = {}

  update: ->
    @_forEachChildView (view) ->
      view.update()

  create: ->
    @collection.each (model) =>
      @_addModelView model
    
    @listenTo @collection, "add", (model) ->
      @_addModelView model      

    @listenTo @collection, "remove", (model) ->
      @_removeModelView model

  _addModelView: (model) ->
    modelView = @_createModelView model
    @childViews[model.cid] = modelView
    @el.addChild modelView.render()

  _removeModelView: (model) ->
    @el.removeChild @childViews[model.cid]
    delete @childViews[model.cid]

  _createModelView: (model) ->
    new @modelView
      model: model

  _getModelView: (model) ->
    @childViews[model.cid]

  _forEachChildView: (fn) ->
    _(@childViews).values().each fn