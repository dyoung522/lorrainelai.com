import { Controller } from "@hotwired/stimulus"

// Manages dark mode theme switching with system preference detection
// and localStorage persistence for user overrides.
export default class extends Controller {
  static targets = ["sunIcon", "moonIcon"]

  connect() {
    // Set up media query first (used by getCurrentTheme)
    this.mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")

    this.applyTheme()
    this.updateIcons()

    // Listen for system preference changes
    this.handleSystemChange = this.handleSystemChange.bind(this)
    this.mediaQuery.addEventListener("change", this.handleSystemChange)
  }

  disconnect() {
    this.mediaQuery.removeEventListener("change", this.handleSystemChange)
  }

  toggle() {
    const currentTheme = this.getCurrentTheme()
    const newTheme = currentTheme === "dark" ? "light" : "dark"

    localStorage.setItem("theme", newTheme)
    this.applyTheme()
    this.updateIcons()
  }

  handleSystemChange() {
    // Only apply system preference if user hasn't set a preference
    if (!localStorage.getItem("theme")) {
      this.applyTheme()
      this.updateIcons()
    }
  }

  getCurrentTheme() {
    const stored = localStorage.getItem("theme")
    if (stored) return stored

    return this.mediaQuery.matches ? "dark" : "light"
  }

  applyTheme() {
    const theme = this.getCurrentTheme()
    document.documentElement.classList.toggle("dark", theme === "dark")
  }

  updateIcons() {
    if (!this.hasSunIconTarget || !this.hasMoonIconTarget) return

    const isDark = this.getCurrentTheme() === "dark"
    // In dark mode, show sun (to switch to light); in light mode, show moon (to switch to dark)
    this.sunIconTarget.classList.toggle("hidden", !isDark)
    this.moonIconTarget.classList.toggle("hidden", isDark)
  }
}
