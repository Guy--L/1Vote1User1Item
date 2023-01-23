import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newitem", "voteitem" ]
  
  connect() {
  }

  newitemTargetConnected(element) {
    let ul = element.parentElement
    let page = ul.dataset.page
    let sort = ul.dataset.sort
    let idrange = JSON.parse(ul.dataset.range)
    
    if (sort==0) {
      ul.removeChild(element)
      if (idrange[0]!=0 || idrange[1]==0) {   // don't insert new record in voted range
        return
      }
      let unvoted = [...ul.querySelectorAll('li')].filter(item => item.dataset.item > 0)[0]
      ul.insertBefore(element, unvoted)
    }
    else if (page>1) {
      ul.removeChild(element)
      return
    }
    element.classList.remove('d-none')
    ul.removeChild(ul.lastElementChild)
    ul.dataset.range = JSON.stringify([ul.firstElementChild.dataset.item, ul.lastElementChild.dataset.item])
  }

  voteitemTargetConnected(element) {
    if (element.dataset.voters.includes(element.parentElement.dataset.user)) {
      element.getElementsByTagName('button')[0].innerText = 'rescind your vote'
    }
  }
}
