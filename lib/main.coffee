{ CompositeDisposable } = require 'atom'
JumpToFrame = require './jump-to-frame'

module.exports =
class Main
  @subscriptions: null

  @activate: (state) ->
    @jumpToFrame = new JumpToFrame()
    @subscriptions = new CompositeDisposable()
    @subscriptions.add(
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-frame-by-number',
        () => @jumpToFrame.toggleView()
      ),
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-next-frame',
        () => @jumpToFrame.jumpToNearFrame()
      ),
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-previous-frame',
        () => @jumpToFrame.jumpToNearFrame(backward=true)
      )
    )

  @deactivate: ->
    @subscriptions.dispose()
    @jumpToFrame.deactivate()
