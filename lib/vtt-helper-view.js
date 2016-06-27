'use babel';

export default class VttHelperView {

  constructor(serializedState) {
    // Create root element
    this.element = document.createElement('div');
    this.element.classList.add('vtt-helper');

    // Create message element
    const message = document.createElement('div');
    message.textContent = 'Welcome to vtt-helper!';
    message.classList.add('message', 'icon', 'icon-heart');
    this.element.appendChild(message);
  }

  // Returns an object that can be retrieved when package is activated
  serialize() {}

  // Tear down any state and detach
  destroy() {
    this.element.remove();
  }

  getElement() {
    return this.element;
  }

}
