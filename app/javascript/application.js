// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

// Initialize Bootstrap tooltips and popovers
document.addEventListener("turbo:load", () => {
  // Initialize dropdowns
  const dropdowns = document.querySelectorAll('.dropdown-toggle')
  dropdowns.forEach(dropdown => {
    new bootstrap.Dropdown(dropdown)
  })
})
