import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shopping-cart"
export default class extends Controller {
  static targets = ["floatingCart", "cartCount"]
  static values = { items: Object }

  connect() {
    this.itemsValue = {}
    this.loadFromLocalStorage()
    this.updateCartDisplay()
  }

  increaseQuantity(event) {
    const itemId = event.params.itemId
    const itemName = event.params.itemName
    const itemPrice = parseFloat(event.params.itemPrice)
    
    if (!this.itemsValue[itemId]) {
      this.itemsValue[itemId] = {
        id: itemId,
        name: itemName,
        price: itemPrice,
        quantity: 0
      }
    }
    
    this.itemsValue[itemId].quantity++
    this.updateQuantityDisplay(itemId)
    this.updateCartDisplay()
    this.saveToLocalStorage()
    this.showAddToCartAnimation()
  }

  decreaseQuantity(event) {
    const itemId = event.params.itemId
    
    if (this.itemsValue[itemId] && this.itemsValue[itemId].quantity > 0) {
      this.itemsValue[itemId].quantity--
      
      if (this.itemsValue[itemId].quantity === 0) {
        delete this.itemsValue[itemId]
      }
    }
    
    this.updateQuantityDisplay(itemId)
    this.updateCartDisplay()
    this.saveToLocalStorage()
  }

  updateQuantityDisplay(itemId) {
    const quantityElement = this.element.querySelector(`[data-shopping-cart-target="quantity${itemId}"]`)
    const decreaseBtn = this.element.querySelector(`[data-shopping-cart-target="decreaseBtn${itemId}"]`)
    const quantity = this.itemsValue[itemId]?.quantity || 0
    
    if (quantityElement) {
      quantityElement.textContent = quantity
    }
    
    if (decreaseBtn) {
      decreaseBtn.disabled = quantity === 0
    }
  }

  updateCartDisplay() {
    const totalItems = Object.values(this.itemsValue).reduce((sum, item) => sum + item.quantity, 0)
    
    if (totalItems > 0) {
      this.floatingCartTarget.classList.remove("hidden")
      this.cartCountTarget.textContent = totalItems
    } else {
      this.floatingCartTarget.classList.add("hidden")
    }
  }

  showCart() {
    if (Object.keys(this.itemsValue).length === 0) {
      alert('Your cart is empty! Add some items first.')
      return
    }
    
    // Navigate to order form with current cart items
    const cartData = encodeURIComponent(JSON.stringify(this.itemsValue))
    window.location.href = `/orders/new?cart=${cartData}`
  }

  showAddToCartAnimation() {
    // Simple animation feedback
    this.floatingCartTarget.style.transform = 'scale(1.1)'
    setTimeout(() => {
      this.floatingCartTarget.style.transform = 'scale(1)'
    }, 200)
  }

  saveToLocalStorage() {
    localStorage.setItem("cartItems", JSON.stringify(this.itemsValue))
  }

  loadFromLocalStorage() {
    const stored = localStorage.getItem("cartItems")
    if (stored) {
      try {
        this.itemsValue = JSON.parse(stored)
        Object.keys(this.itemsValue).forEach(itemId => {
          this.updateQuantityDisplay(itemId)
        })
      } catch (e) {
        console.error('Error loading cart from localStorage:', e)
        this.itemsValue = {}
      }
    }
  }

  clearCart() {
    this.itemsValue = {}
    localStorage.removeItem("cartItems")
    
    // Update all quantity displays
    Object.keys(this.itemsValue).forEach(itemId => {
      this.updateQuantityDisplay(itemId)
    })
    
    this.updateCartDisplay()
  }
}
