helpers = require '../helpers/helpers.js'
utils = require '../utils/utils.js'
ideHelpers = require '../helpers/idehelpers.js'
async = require 'async'
path = require 'path'
settingsSelector = '.kdtabhandle.settings'
settingsHeader = '.settings-pane .settings-header'
lineNumberToggleSelector = '.settings-pane li:nth-of-type(3) .settings-on-off'
fileTabSelector = '.ide-files-tab .kdtabhandle.files'
activeEditorSelector = '.pane-wrapper .kdsplitview-panel.panel-1 .kdtabpaneview.active .ace_content'
fileName = 'text.txt'
user = utils.getUser()

module.exports =

  openSettingsMenu: (browser, callback = -> ) ->
    browser
      .waitForElementVisible  settingsSelector, 20000
      .click settingsSelector
      .waitForElementVisible settingsHeader, 20000
      .pause 10, -> callback()


  enableAutoSave: (browser, callback) ->
    text = 'test enable AutoSave'
    @openSettingsMenu browser, =>
      @toogleOnOff browser, 1, ->
        browser
          .waitForElementVisible fileTabSelector, 20000
          .click fileTabSelector, ->
            ideHelpers.openFile browser, user, fileName, ->
            browser.pause 1000
            ideHelpers.setTextToEditor browser, text
            browser.pause 3000
            ideHelpers.closeFile browser, fileName, user
            ideHelpers.openFile browser, user, fileName, ->
              browser.pause 2000
              browser.assert.containsText activeEditorSelector, text
              ideHelpers.closeFile browser, fileName, user
              browser.pause 1, callback()


  toogleOnOff: (browser, index, callback) ->
    browser.waitForElementVisible toggleElementSelector(index), 20000
    browser.element 'css selector', toggleElementSelector(index) + '.off', (result) ->
      if result.status is 0
        browser.click toggleElementSelector(index)
    browser.pause 1, -> callback()


toggleElementSelector = (index) ->
  ".settings-pane li:nth-of-type(#{index}) .settings-on-off"
