'use babel';

import jumpToFrameView from './jump-to-frame-view';

export default {


  jumpToFrameView: null,
  subscriptions: null,

  deactivate() {
    this.subscriptions.dispose();
    this.jumpToFrameView.destroy();
  },

  serialize() {

  },

  goToFrameNum(){
    var editor = atom.workspace.getActiveTextEditor();
    if (editor) {

      if (editor.getText().slice(0,6) !== 'WEBVTT') {
        console.warn('[vtt-helper] NOT VALID VTT CONTENT');
        return;
      }

      // NOTE init view/panel
      if (this.jumpToFrameView == null) {

        this.jumpToFrameView = new jumpToFrameView();
        this.jumpToFrameView.modalPanel = atom.workspace.addModalPanel({
          item: this.jumpToFrameView,
          visible: false
        });

        this.jumpToFrameView.onConfrimCb = function(frameNum) {

          var re = new RegExp("^" + frameNum + "\r?\n", "g") ;
          editor.scan(re, function(matchObj){
            editor.setCursorBufferPosition(matchObj.range.start);
            editor.scrollToBufferPosition(matchObj.range.start, {center: true});
          });
        };
      }

      this.jumpToFrameView.toggle();
    }
  }

};
