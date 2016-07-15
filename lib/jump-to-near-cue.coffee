module.exports =

class JumpToNearCue
  jumpToNearCue: (backward=false) ->
    return unless editor = atom.workspace.getActiveTextEditor()
    return atom.notifications.addInfo('Invalid vtt content') if (editor.getText().slice(0,6) != 'WEBVTT')

    re = new RegExp(/-->/g)
    cursor = editor.getCursorBufferPosition()
    _focusToMatchObj = (matchObj) ->
      editor.setCursorBufferPosition [matchObj.range.start.row, 0]
      editor.scrollToBufferPosition matchObj.range.start, {center: true}

    if backward
      editor.scanInBufferRange re, [[0,0], [cursor.row, 0]], _focusToMatchObj
    else
      editor.backwardsScanInBufferRange re, [[cursor.row+1, 0], [cursor.row+20, 0]], _focusToMatchObj
