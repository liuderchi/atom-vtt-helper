'use babel';

import { CompositeDisposable } from 'atom';
import * as vttHelper from './vtt-helper' ;

export default {

  subscriptions: null,

  activate(state) {

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(
      atom.commands.add('atom-workspace', 'vtt-helper:jump-to-frame-by-number',
        () => vttHelper.goToFrameNum()
      )
    );
  },

  deactivate() {
    this.subscriptions.dispose();
    vttHelper.deactivate();
  }

};
