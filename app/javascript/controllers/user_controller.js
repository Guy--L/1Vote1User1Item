import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newitem" ]
  
  connect() {
  }

  newitemTargetConnected(element) {
    element.parentElement.id = element.parentElement.id.slice(0,-3) + 'user_' + this.element.dataset.user
  }
}
