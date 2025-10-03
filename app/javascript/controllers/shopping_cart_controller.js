import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shopping-cart"
export default class extends Controller {
  static targets = ["floatingCart", "cartCount"]
  static values = { items: Object }

  connect() {
    this.loadFromLocalStorage()
    this.updateCartDisplay()
    this.initializeItemDisplays()
  }

  itemsValueChanged() {
    this.updateCartDisplay()
    this.saveToLocalStorage()
  }

  initializeItemDisplays() {
    const itemButtons = this.element.querySelectorAll('[data-action="click->shopping-cart#increaseQuantity"]')
    itemButtons.forEach(button => {
      const itemId = button.dataset.shoppingCartItemIdParam
      this.updateQuantityDisplay(itemId)
    })
  }

  increaseQuantity({ params }) {
    const { itemId, itemName, itemPrice: itemPriceString } = params;
    const itemPrice = parseFloat(itemPriceString);
    
    const currentItems = { ...this.itemsValue };

    if (!currentItems[itemId]) {
      currentItems[itemId] = {
        id: itemId,
        name: itemName,
        price: itemPrice,
        quantity: 0
      };
    }

    currentItems[itemId].quantity++;
    this.itemsValue = currentItems;

    this.updateQuantityDisplay(itemId);
    this.showAddToCartAnimation();
  }

  decreaseQuantity(event) {
    const itemId = event.params.itemId;
    const currentItems = { ...this.itemsValue };
    const item = currentItems[itemId];

    if (item && item.quantity > 0) {
      item.quantity--;

      if (item.quantity === 0) {
        delete currentItems[itemId];
      }
    }
    
    this.itemsValue = currentItems;
    this.updateQuantityDisplay(itemId);
  }

  updateQuantityDisplay(itemId) {
    const item = this.itemsValue[itemId];
    const quantity = item ? item.quantity : 0;

    const quantityElement = this.element.querySelector(`[data-shopping-cart-target="quantity${itemId}"]`);
    const decreaseBtn = this.element.querySelector(`[data-shopping-cart-target="decreaseBtn${itemId}"]`);
    
    if (quantityElement) {
      quantityElement.textContent = quantity;
    }
    
    if (decreaseBtn) {
      decreaseBtn.disabled = quantity === 0;
    }
  }

  updateCartDisplay() {
    const totalItems = Object.values(this.itemsValue).reduce((sum, item) => sum + item.quantity, 0);
    
    if (this.hasFloatingCartTarget && totalItems > 0) {
      this.floatingCartTarget.classList.remove("hidden");
      if (this.hasCartCountTarget) {
        this.cartCountTarget.textContent = totalItems;
      }
    } else if (this.hasFloatingCartTarget) {
      this.floatingCartTarget.classList.add("hidden");
    }
  }

  showAddToCartAnimation() {
    if (this.hasFloatingCartTarget) {
      this.floatingCartTarget.style.transform = 'scale(1.1)';
      setTimeout(() => {
        this.floatingCartTarget.style.transform = 'scale(1)';
      }, 200);
    }
  }

  saveToLocalStorage() {
    localStorage.setItem("cartItems", JSON.stringify(this.itemsValue));
  }

  loadFromLocalStorage() {
    const stored = localStorage.getItem("cartItems");
    if (stored) {
      try {
        this.itemsValue = JSON.parse(stored);
      } catch (e) {
        console.error('Error loading cart from localStorage:', e);
        this.itemsValue = {};
      }
    } else {
      this.itemsValue = {};
    }
  }
}