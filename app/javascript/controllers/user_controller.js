import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newitem", "voteitem" ]
  
  connect() {
  }

  newitemTargetConnected(element) {
    element.parentElement.id = element.parentElement.id.slice(0,-3) + 'user_' + this.element.dataset.user
  }

  voteitemTargetConnected(element) {
    if (element.dataset.voters.includes(element.parentElement.dataset.user)) {
      element.getElementsByTagName('button')[0].innerText = 'rescind your vote'
    }
  }
}
