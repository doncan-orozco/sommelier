import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="category-filter"
export default class extends Controller {
  
  filterCategory(event) {
    const categoryId = event.target.dataset.category
    const allSections = document.querySelectorAll('.category-section')
    const allTabs = document.querySelectorAll('.category-tab')
    
    // Update tab active state
    allTabs.forEach(tab => {
      tab.classList.remove('active', 'bg-green-500', 'text-white')
      tab.classList.add('bg-gray-200', 'text-gray-700')
    })
    
    event.target.classList.remove('bg-gray-200', 'text-gray-700')
    event.target.classList.add('active', 'bg-green-500', 'text-white')
    
    // Show/hide sections
    if (categoryId === 'all') {
      allSections.forEach(section => {
        section.style.display = 'block'
      })
    } else {
      allSections.forEach(section => {
        if (section.dataset.categoryId === categoryId) {
          section.style.display = 'block'
        } else {
          section.style.display = 'none'
        }
      })
    }
    
    // Smooth scroll to first visible section
    const firstVisible = document.querySelector('.category-section[style*="block"], .category-section:not([style])')
    if (firstVisible && categoryId !== 'all') {
      firstVisible.scrollIntoView({ 
        behavior: 'smooth', 
        block: 'start',
        inline: 'nearest'
      })
    }
  }
}
