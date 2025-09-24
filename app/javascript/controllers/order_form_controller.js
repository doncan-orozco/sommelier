import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-form"
export default class extends Controller {
  static targets = [
    "orderItems", 
    "orderTotal", 
    "orderForm", 
    "emptyState", 
    "itemsInput", 
    "submitButton",
    "successModal",
    "successMessage"
  ]
  
  connect() {
    this.loadCartItems()
  }
  
  loadCartItems() {
    const cartData = this.getCartFromURL() || this.getCartFromStorage()
    
    if (!cartData || Object.keys(cartData).length === 0) {
      this.showEmptyState()
      return
    }
    
    this.cartItems = cartData
    this.displayOrderItems()
    this.showOrderForm()
  }
  
  getCartFromURL() {
    const urlParams = new URLSearchParams(window.location.search)
    const cartParam = urlParams.get('cart')
    
    if (cartParam) {
      try {
        return JSON.parse(decodeURIComponent(cartParam))
      } catch (e) {
        console.error('Error parsing cart from URL:', e)
        return null
      }
    }
    return null
  }
  
  getCartFromStorage() {
    try {
      const stored = localStorage.getItem('cartItems')
      return stored ? JSON.parse(stored) : null
    } catch (e) {
      console.error('Error loading cart from storage:', e)
      return null
    }
  }
  
  displayOrderItems() {
    let itemsHTML = ''
    let total = 0
    const itemsArray = []
    
    Object.values(this.cartItems).forEach(item => {
      const subtotal = item.price * item.quantity
      total += subtotal
      
      itemsArray.push({
        id: item.id,
        quantity: item.quantity
      })
      
      itemsHTML += `
        <div class="flex justify-between items-center p-4 border-b last:border-b-0">
          <div class="flex-1">
            <h4 class="font-medium text-lg">${item.name}</h4>
            <div class="flex items-center mt-2 space-x-4">
              <span class="bg-gray-100 px-3 py-1 rounded-full">Qty: ${item.quantity}</span>
              <span class="text-green-600 font-medium">$${item.price.toFixed(2)} each</span>
            </div>
          </div>
          <div class="text-right">
            <div class="text-xl font-bold text-green-600">$${subtotal.toFixed(2)}</div>
            <button class="text-red-500 hover:text-red-700 text-sm mt-1" 
                    data-action="click->order-form#removeItem" 
                    data-item-id="${item.id}">
              Remove
            </button>
          </div>
        </div>
      `
    })
    
    this.orderItemsTarget.innerHTML = itemsHTML
    this.orderTotalTarget.innerHTML = `
      <div class="flex justify-between items-center text-2xl font-bold">
        <span>Total:</span>
        <span class="text-green-600">$${total.toFixed(2)}</span>
      </div>
    `
    
    // Set the items data for form submission
    this.itemsInputTarget.value = JSON.stringify(itemsArray)
  }
  
  removeItem(event) {
    const itemId = event.target.dataset.itemId
    delete this.cartItems[itemId]
    
    if (Object.keys(this.cartItems).length === 0) {
      this.showEmptyState()
      this.clearCartFromStorage()
    } else {
      this.displayOrderItems()
      this.updateCartInStorage()
    }
  }
  
  clearOrder() {
    if (confirm('Are you sure you want to clear your entire order?')) {
      this.cartItems = {}
      this.clearCartFromStorage()
      this.showEmptyState()
    }
  }
  
  submitOrder(event) {
    event.preventDefault()
    
    const form = event.target
    const formData = new FormData(form)
    
    // Disable submit button
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.textContent = '⏳ Placing Order...'
    
    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.showSuccessModal(data.message)
        this.clearCartFromStorage()
        
        // Redirect after showing success
        setTimeout(() => {
          if (data.redirect_url) {
            window.location.href = data.redirect_url
          } else {
            window.location.href = '/'
          }
        }, 2000)
      } else {
        throw new Error(data.errors ? data.errors.join(', ') : 'Order failed')
      }
    })
    .catch(error => {
      console.error('Order submission error:', error)
      alert(`Error: ${error.message}`)
    })
    .finally(() => {
      // Re-enable submit button
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.textContent = '🚀 Confirm Order'
    })
  }
  
  showOrderForm() {
    this.emptyStateTarget.style.display = 'none'
    this.orderFormTarget.style.display = 'block'
  }
  
  showEmptyState() {
    this.orderFormTarget.style.display = 'none'
    this.emptyStateTarget.style.display = 'block'
  }
  
  showSuccessModal(message) {
    this.successMessageTarget.textContent = message
    this.successModalTarget.classList.remove('hidden')
    this.successModalTarget.classList.add('flex')
  }
  
  closeSuccessModal() {
    this.successModalTarget.classList.add('hidden')
    this.successModalTarget.classList.remove('flex')
  }
  
  updateCartInStorage() {
    localStorage.setItem('cartItems', JSON.stringify(this.cartItems))
  }
  
  clearCartFromStorage() {
    localStorage.removeItem('cartItems')
  }
}
