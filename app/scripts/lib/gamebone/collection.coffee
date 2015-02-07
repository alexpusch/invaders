Backbone = require 'backbone'

module.exports = class Collection extends Backbone.Collection
  onForever: (fn) ->
    @each (model) ->
      fn model

    @on "add", (model) ->
      fn model