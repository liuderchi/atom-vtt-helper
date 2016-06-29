JumpToFrameView = require './jump-to-frame-view'  # NOTE no curly brackets

module.exports =
class JumpToFrame
  jumpToFrameView: null

  deactivate: ->
    @jumpToFrameView.destroy()

  jumpToFrameNum: ->
    return unless editor = atom.workspace.getActiveTextEditor()

    if (editor.getText().slice(0,6) != 'WEBVTT')
      return console.warn('[vtt-helper] NOT VALID VTT CONTENT')

    #  NOTE init view/panel
    if (@jumpToFrameView == null)
      @jumpToFrameView = new JumpToFrameView()
      @jumpToFrameView.modalPanel = atom.workspace.addModalPanel({
        item: @jumpToFrameView,
        visible: false
      })

    @jumpToFrameView.toggle()
