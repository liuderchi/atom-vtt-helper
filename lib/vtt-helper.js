'use babel';

import VttHelperView from './vtt-helper-view';
import jumpToFrameView from './jump-to-frame-view';
import { CompositeDisposable } from 'atom';

export default {

  vttHelperView: null,
  modalPanel: null,
  jumpToFrameView: null,
  subscriptions: null,

  activate(state) {
    this.vttHelperView = new VttHelperView(state.vttHelperViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.vttHelperView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(
      atom.commands.add('atom-workspace', 'vtt-helper:toggle',
        () => this.toggle()
      ),
      atom.commands.add('atom-workspace', 'vtt-helper:Jump To Frame By Number',
        () => this.goToFrameNum()
      )
    );
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.jumpToFrameView.destroy();
    this.vttHelperView.destroy();
  },

  serialize() {
    return {
      vttHelperViewState: this.vttHelperView.serialize()
    };
  },

  toggle() {
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
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
