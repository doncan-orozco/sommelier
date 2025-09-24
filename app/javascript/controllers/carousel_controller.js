import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["slide", "indicator"]
  
  connect() {
    this.currentSlide = 0
    this.startAutoplay()
  }
  
  disconnect() {
    this.stopAutoplay()
  }
  
  goToSlide(event) {
    const slideIndex = parseInt(event.target.dataset.slide)
    this.showSlide(slideIndex)
    this.stopAutoplay()
    // Restart autoplay after user interaction
    setTimeout(() => this.startAutoplay(), 5000)
  }
  
  showSlide(index) {
    // Hide all slides
    this.slideTargets.forEach((slide, i) => {
      if (i === index) {
        slide.classList.add('active')
        slide.style.opacity = '1'
      } else {
        slide.classList.remove('active')
        slide.style.opacity = '0'
      }
    })
    
    // Update indicators
    this.indicatorTargets.forEach((indicator, i) => {
      if (i === index) {
        indicator.classList.add('active', 'bg-white')
        indicator.classList.remove('bg-white/50')
      } else {
        indicator.classList.remove('active', 'bg-white')
        indicator.classList.add('bg-white/50')
      }
    })
    
    this.currentSlide = index
  }
  
  nextSlide() {
    const nextIndex = (this.currentSlide + 1) % this.slideTargets.length
    this.showSlide(nextIndex)
  }
  
  startAutoplay() {
    if (this.slideTargets.length > 1) {
      this.autoplayInterval = setInterval(() => {
        this.nextSlide()
      }, 4000)
    }
  }
  
  stopAutoplay() {
    if (this.autoplayInterval) {
      clearInterval(this.autoplayInterval)
    }
  }
}
