JumpToFrameView = require './jump-to-frame-view'  # NOTE no curly brackets

class JumpToFrame
  jumpToFrameView: null

  deactivate: ->
    this.jumpToFrameView.destroy()

  jumpToFrameNum: ->
    return unless editor = atom.workspace.getActiveTextEditor()

    if (editor.getText().slice(0,6) != 'WEBVTT')
      return console.warn('[vtt-helper] NOT VALID VTT CONTENT')

    #  NOTE init view/panel
    if (this.jumpToFrameView == null)
      this.jumpToFrameView = new JumpToFrameView()
      this.jumpToFrameView.modalPanel = atom.workspace.addModalPanel({
        item: this.jumpToFrameView,
        visible: false
      })

    this.jumpToFrameView.toggle()

module.exports = JumpToFrame
