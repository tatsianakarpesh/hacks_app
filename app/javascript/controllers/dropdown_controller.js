import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Initialize dropdown when controller connects
    this.dropdown = new bootstrap.Dropdown(this.element)
  }

  disconnect() {
    // Clean up dropdown when controller disconnects
    if (this.dropdown) {
      this.dropdown.dispose()
    }
  }
}
