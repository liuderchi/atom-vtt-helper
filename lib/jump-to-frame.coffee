{$, TextEditorView, View } = require 'atom-space-pen-views'


class JumpToFrame
  jumpToFrameView: null

  deactivate: ->
    @jumpToFrameView.destroy()

  toggleView: ->
    return unless editor = atom.workspace.getActiveTextEditor()
    return console.warn('[vtt-helper] NOT VALID VTT CONTENT') if (editor.getText().slice(0,6) != 'WEBVTT')

    #  NOTE init view/panel
    if (@jumpToFrameView == null)
      @jumpToFrameView = new JumpToFrameView()    # call initialize()
      @jumpToFrameView.modalPanel = atom.workspace.addModalPanel({
        item: @jumpToFrameView,
        visible: false
      })

    @jumpToFrameView.toggle()

  jumpToNearFrame: (backward=false) ->
    return unless editor = atom.workspace.getActiveTextEditor()
    return console.warn('[vtt-helper] NOT VALID VTT CONTENT') if (editor.getText().slice(0,6) != 'WEBVTT')

    re = new RegExp(/^(\d)+$/g)
    cursor = editor.getCursorBufferPosition()
    _focusToMatchObj = (matchObj) ->
      editor.setCursorBufferPosition matchObj.range.start
      editor.scrollToBufferPosition matchObj.range.start, {center: true}

    if backward
      editor.scanInBufferRange re, [[0,0], [cursor.row, 0]], _focusToMatchObj
    else
      editor.backwardsScanInBufferRange re, [[cursor.row+1, 0], [cursor.row+20, 0]], _focusToMatchObj


class JumpToFrameView extends View
  modalPanel: null,  # NOTE from atom.workspace.addModalPanel()

  @content: ->
    @div class: 'package-generator', =>
      @subview 'miniEditor', new TextEditorView(mini: true, placeholderText: 'Enter frame number')
      @div class: 'error', outlet: 'error'
      @div class: 'message', outlet: 'message'

  initialize: ->
    @miniEditor.on 'blur', => @close()
    atom.commands.add @element,
      'core:confirm': => @confirm()
      'core:cancel': => @close()

  destroy: ->
    console.log 'JumpToFrameView destroying'

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()  # trigger blur
    else
      @storeFocusedElement()
      @message.text("Enter frame number to jump to")
      @modalPanel.show()
      @miniEditor.focus()

  confirm: ->
    frameNum = parseInt(@miniEditor.getText())
    return @error.text('Invalid input') if isNaN frameNum
    @close()
    return unless editor = atom.workspace.getActiveTextEditor()
    re = new RegExp("^" + frameNum + "\r?\n", "g")
    editor.scan re, (matchObj) ->
      editor.setCursorBufferPosition matchObj.range.start
      editor.scrollToBufferPosition matchObj.range.start, {center: true}

  close: ->
    miniEditorFocused = @miniEditor.hasFocus()
    @miniEditor.setText('')
    @error.text('')
    @modalPanel.hide()
    @restoreFocus() if miniEditorFocused

  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')

  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.views.getView(atom.workspace).focus()


module.exports = JumpToFrame
