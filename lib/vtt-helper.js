'use babel';

import VttHelperView from './vtt-helper-view';
import { CompositeDisposable } from 'atom';

export default {

  vttHelperView: null,
  modalPanel: null,
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
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'vtt-helper:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.vttHelperView.destroy();
  },

  serialize() {
    return {
      vttHelperViewState: this.vttHelperView.serialize()
    };
  },

  toggle() {
    console.log('VttHelper was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
