import { Controller } from "@hotwired/stimulus"

// Handles adding/removing custom social link fields
export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const index = new Date().getTime()
    const template = this.templateTarget.innerHTML.replace(/NEW_INDEX/g, index)
    this.containerTarget.insertAdjacentHTML("beforeend", template)
  }

  remove(event) {
    event.preventDefault()
    const field = event.target.closest("[data-custom-link]")
    if (field) {
      field.remove()
    }
  }
}
