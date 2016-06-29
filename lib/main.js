'use babel';

import { CompositeDisposable } from 'atom';
import JumpToFrame from './jump-to-frame';

export default {

  subscriptions: null,

  activate(state) {

    this.jumpToFrame = new JumpToFrame();
    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(
      atom.commands.add('atom-workspace', 'vtt-helper:jump-to-frame-by-number',
        () => this.jumpToFrame.jumpToFrameNum()
      )
    );
  },

  deactivate() {
    this.subscriptions.dispose();
    this.jumpToFrame.deactivate();
  }

};
