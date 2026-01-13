import { Controller } from "@hotwired/stimulus"
import Cropper from "cropperjs"

/**
 * Handles image cropping for profile picture uploads.
 *
 * Targets:
 *   input: The file input element
 *   preview: The preview image element
 *   container: The cropping container (hidden initially)
 *   form: The form element to submit
 *   currentPreview: The current profile picture display (hidden when cropping)
 *
 * Values:
 *   aspectRatio: The aspect ratio for cropping (default: 1 for square)
 *   outputSize: The output dimensions in pixels (default: 400)
 *   outputQuality: JPEG quality 0-1 (default: 0.9)
 */
export default class extends Controller {
  static targets = ["input", "preview", "container", "form", "currentPreview"]
  static values = {
    aspectRatio: { type: Number, default: 1 },
    outputSize: { type: Number, default: 400 },
    outputQuality: { type: Number, default: 0.9 }
  }

  connect() {
    this.cropper = null
    this.originalFile = null
  }

  disconnect() {
    this.destroyCropper()
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    if (!file || !file.type.startsWith("image/")) return
    this.originalFile = file
    this.showCropperInterface(file)
  }

  showCropperInterface(file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      this.containerTarget.classList.remove("hidden")
      if (this.hasCurrentPreviewTarget) {
        this.currentPreviewTarget.classList.add("hidden")
      }
      this.previewTarget.src = e.target.result
      this.previewTarget.onload = () => this.initCropper(this.previewTarget)
    }
    reader.readAsDataURL(file)
  }

  initCropper(img) {
    this.destroyCropper()
    this.cropper = new Cropper(img, {
      aspectRatio: this.aspectRatioValue,
      viewMode: 1,
      dragMode: "move",
      cropBoxMovable: false,
      cropBoxResizable: false,
      guides: false,
      center: true,
      background: false,
      responsive: true,
      checkOrientation: true
    })
  }

  destroyCropper() {
    if (this.cropper) {
      this.cropper.destroy()
      this.cropper = null
    }
  }

  zoomIn() {
    if (this.cropper) this.cropper.zoom(0.1)
  }

  zoomOut() {
    if (this.cropper) this.cropper.zoom(-0.1)
  }

  cancel() {
    this.destroyCropper()
    this.containerTarget.classList.add("hidden")
    if (this.hasCurrentPreviewTarget) {
      this.currentPreviewTarget.classList.remove("hidden")
    }
    this.inputTarget.value = ""
  }

  async submit(event) {
    event.preventDefault()
    if (!this.cropper) return

    const canvas = this.cropper.getCroppedCanvas({
      width: this.outputSizeValue,
      height: this.outputSizeValue,
      fillColor: "#fff",
      imageSmoothingEnabled: true,
      imageSmoothingQuality: "high"
    })

    const blob = await new Promise(resolve => {
      canvas.toBlob(resolve, "image/jpeg", this.outputQualityValue)
    })

    const croppedFile = new File([blob], this.originalFile.name, { type: "image/jpeg" })
    const dataTransfer = new DataTransfer()
    dataTransfer.items.add(croppedFile)
    this.inputTarget.files = dataTransfer.files

    this.formTarget.requestSubmit()
  }
}
