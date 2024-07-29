// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require rails-ujs
//= require turbolinks
//= require_tree .

document.addEventListener('input', async (e) => {
    if(e.target.dataset.productId) {
        const productId = e.target.dataset.productId;
        const quantity = e.target.value;

        const formData = new FormData();
		formData.append('product_id', productId);
		formData.append('quantity', quantity);
		
        const options = {
			method: 'POST',
			body: JSON.stringify({ product_id: productId, quantity: quantity }),
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            }
		}
		const respuesta = await fetch('/shopping_cart/update', options);
		const datos = await respuesta.json();
    }
});