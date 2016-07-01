{ CompositeDisposable } = require 'atom'
JumpToCue = require './jump-to-cue'

module.exports =
class Main
  @subscriptions: null

  @activate: (state) ->
    @jumpToCue = new JumpToCue()
    @subscriptions = new CompositeDisposable()
    @subscriptions.add(
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-cue-by-number',
        () => @jumpToCue.toggleView()
      ),
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-next-cue',
        () => @jumpToCue.jumpToNearCue()
      ),
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-previous-cue',
        () => @jumpToCue.jumpToNearCue(backward=true)
      )
    )

  @deactivate: ->
    @subscriptions.dispose()
    @jumpToCue.deactivate()
