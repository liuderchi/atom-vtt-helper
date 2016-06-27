{$, TextEditorView, View } = require 'atom-space-pen-views'

module.exports =
class jumpToFrameView extends View
  onConfrimCb: null,
  modalPanel: null,  # NOTE from atom.workspace.addModalPanel()
  editor: null,  # NOTE from atom.workspace.getActiveTextEditor()

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
    console.log 'jumpToFrameView destroying'

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
    if isNaN frameNum then @error.text('Invalid input'); return
    @close()
    if (@onConfrimCb != null) then @onConfrimCb(frameNum) else console.warn '[vtt-helper] onConfrimCb is null'

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
