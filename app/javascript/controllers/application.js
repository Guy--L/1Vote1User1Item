import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "controllers"
import mrujs from "mrujs"

mrujs.start()
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


