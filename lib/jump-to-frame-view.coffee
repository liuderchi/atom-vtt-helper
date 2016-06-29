{$, TextEditorView, View } = require 'atom-space-pen-views'

module.exports =
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
