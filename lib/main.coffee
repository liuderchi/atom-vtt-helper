{ CompositeDisposable } = require 'atom'
JumpToCue = require './jump-to-cue'
JumpToNearCue = require './jump-to-near-cue'

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
        () => new JumpToNearCue().jumpToNearCue()
      ),
      atom.commands.add(
        'atom-workspace',
        'vtt-helper:jump-to-previous-cue',
        () => new JumpToNearCue().jumpToNearCue(backward=true)
      )
    )

  @deactivate: ->
    @subscriptions.dispose()
    @jumpToCue.deactivate()
