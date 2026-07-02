import { Application } from "@hotwired/stimulus"
import { registerPhlexKitControllers } from "phlex_kit/controllers"

const application = Application.start()
window.Stimulus = application
registerPhlexKitControllers(application)
