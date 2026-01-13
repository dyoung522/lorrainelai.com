import { Controller } from "@hotwired/stimulus"

// Removes flash message from DOM after CSS animation completes
export default class extends Controller {
  remove() {
    this.element.remove()
  }
}
