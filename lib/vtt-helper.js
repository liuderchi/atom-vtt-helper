'use babel';

import jumpToFrameView from './jump-to-frame-view';
import { CompositeDisposable } from 'atom';

export default {


  jumpToFrameView: null,
  subscriptions: null,

  activate(state) {

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(
      atom.commands.add('atom-workspace', 'vtt-helper:jump-to-frame-by-number',
        () => this.goToFrameNum()
      )
    );
  },

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
