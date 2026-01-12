import { Controller } from "@hotwired/stimulus"

// Handles inline editing toggle behavior
export default class extends Controller {
  static targets = ["display", "form"]

  toggle() {
    this.displayTarget.classList.toggle("hidden")
    this.formTarget.classList.toggle("hidden")
  }

  cancel() {
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }

  reset() {
    // Called after successful form submission via Turbo
    // The Turbo Frame will replace the content automatically
  }
}
