PIXI = require 'pixi'
require('es6-promise').polyfill()

module.exports = class AssetPreloader
  @loadAudioAssets: (assetes) ->
    loaded = 0
    createjs.Sound.alternateExtensions = ["wav"];

    promise = new Promise (resolve, reject) ->
      createjs.Sound.addEventListener "fileload", (e) ->
        loaded += 1
        if loaded == assetes.length
          resolve()

      createjs.Sound.registerManifest assetes, "audio/"

  @loadGraphicAssets: (assets) ->
    new Promise (resolve, reject) ->
      assetLoader = new PIXI.AssetLoader assets

      assetLoader.addEventListener "onComplete", ->
        resolve()

      assetLoader.load()

  @loadFonts: (fontsData) ->
    if isCocoonJS()
      return Promise.resolve()
    promises = _(fontsData).map (fontData) =>
      @loadFont fontData

    Promise.all promises

  @loadFont: (fontData) ->
    font = new Font()
    font.src = fontData.src
    font.fontFamily = fontData.fontFamily

    promise = new Promise (resolve, reject) ->
      font.onload = ->
        resolve()

      font.onerror = (msg) ->
        reject msg

    promise

  @loadAssets: (graphicAssets, audioAssets) ->
    Promise.all [@loadAudioAssets audioAssets, @loadGraphicAssets graphicAssets]
