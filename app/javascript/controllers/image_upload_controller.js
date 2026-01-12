import { Controller } from "@hotwired/stimulus"

// Handles image preview before upload
export default class extends Controller {
  static targets = ["preview", "input"]

  preview() {
    const file = this.inputTarget.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        // If preview is an img element, update src
        if (this.previewTarget.tagName === "IMG") {
          this.previewTarget.src = e.target.result
        } else {
          // Replace placeholder div with img
          const img = document.createElement("img")
          img.src = e.target.result
          img.className = this.previewTarget.className
          img.dataset.imageUploadTarget = "preview"
          this.previewTarget.replaceWith(img)
        }
      }
      reader.readAsDataURL(file)
    }
  }
}
