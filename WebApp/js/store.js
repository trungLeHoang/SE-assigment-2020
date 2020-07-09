
let carts = document.getElementsByClassName('add-to-cart');

let products = [
	{
		id: 0,
		name: 'White Rice',
		tag: 'whiterice',
		cName: 'meal',
		price: 20000,
		image: 'whiterice',
		inCart: 0
	},
	{
		id: 1,
		name: 'Fried Potato',
		tag: 'friedpotato',
		cName: 'extra',
		price: 20000,
		image: 'friedpotato',
		inCart: 0
	},
	{
		id: 2,
		name: 'France Flan',
		tag: 'franceflan',
		cName: 'dessert',
		price: 25000,
		image: 'franceflan',
		inCart: 0
	},
	{
		id: 3,
		name: 'Fresh Milk',
		tag: 'freshmilk',
		cName: 'drink',
		price: 20000,
		image: 'freshmilk',
		inCart: 0
	},
	{
		id: 4,
		name: 'Coffee',
		tag: 'coffee',
		cName: 'drink',
		price: 30000,
		image: 'coffee',
		inCart: 0
	},
	{
		id: 5,
		name: 'Green tea',
		tag: 'greentea',
		cName: 'drink',
		price: 10000,
		image: 'greentea',
		inCart: 0
	},
	{
		id: 6,
		name: 'Bubble milk tea',
		tag: 'bubblemilktea',
		cName: 'drink',
		price: 45000,
		image: 'bubblemilktea',
		inCart: 0
	},
	{
		id: 7,
		name: 'Hamburger',
		tag: 'hamburger',
		cName: 'fastfood',
		price: 30000,
		image: 'hamburger',
		inCart: 0
	}
];



function priceText(number){
	var totalC = "";
		if (number == 0) totalC = "0";
		else{
			totalC = ".000";
			var k = number / 1000;
			if (k > 1000){
				var m = k / 1000;
				m = m | 0;
				k = k - m * 1000;
				totalC = k.toString() + totalC;
				while (totalC.length != 7){
					totalC = "0" + totalC;
				}
				totalC = m.toString() + "." + totalC;
			} else{
				totalC = k.toString() + totalC;
			}
		}
	return totalC;
}

for (let i = 0; i < carts.length; i++){
	carts[i].addEventListener('click', () =>{
		cartNumbers(products[i]);
		totalCost(products[i]);
		alert("Add product to cart successfully!")
	})
}



function onLoadCartNumbers(){
	let productNumbers = localStorage.getItem('cartNumbers');
	
	if (productNumbers){
		document.getElementById("cartNumber").textContent = productNumbers;
	}
}

function cartNumbers(product){
	let productNumbers = localStorage.getItem('cartNumbers');
	productNumbers = parseInt(productNumbers);
	if(productNumbers) {
		localStorage.setItem('cartNumbers', productNumbers + 1);
	}
	else{
		localStorage.setItem('cartNumbers', 1);
	}
	onLoadCartNumbers()
	setItems(product);
}

let productCount = 0;
function setItems(product){
	let cartItems = localStorage.getItem('productsInCart');
	cartItems = JSON.parse(cartItems);
	
	if(cartItems != null){
		if (cartItems[product.tag] == undefined){
			cartItems = {
				...cartItems,
				[product.tag]: product
			}
		}
		cartItems[product.tag].inCart += 1;
	}
	else{
		product.inCart = 1;
		cartItems = {
			[product.tag]: product
		}
	}
	
	localStorage.setItem("productsInCart", JSON.stringify(cartItems));
}

function totalCost(product){
	let cartCost = localStorage.getItem('totalCost');
	if (cartCost != null){
		cartCost = parseInt(cartCost);
		localStorage.setItem("totalCost", cartCost + product.price);
	} else{
		localStorage.setItem("totalCost", product.price);
	}
}

function displayCart(){
	let cartItems = localStorage.getItem("productsInCart");
	cartItems = JSON.parse(cartItems);
	let tBody = document.getElementById('Customdata');
	let cartCost = localStorage.getItem('totalCost');
	let checkOut = document.getElementById('checkout');
	cartCost = parseInt(cartCost);
	
	if (cartItems){
		tBody.innerHTML = '';
		Object.values(cartItems).map(item => {
			var itemTotal = priceText(item.price * item.inCart);
			tBody.innerHTML += `<tr>
                                    <td class="shoping__cart__item">
                                        <img src="img/product/${item.image}.jpg" alt="" width=30%>
                                        <h5>${item.name}</h5>
                                    </td>
                                    <td class="shoping__cart__price">
                                       ${item.price/1000}.000₫
                                    </td>
                                    <td class="shoping__cart__quantity">
                                        <div class="quantity">
											<div class="pro-qty">
												<button class="dec-btn" onclick="decPro(this)">-</button>
												<input type="text" value="${item.inCart}">
												<button class="inc-btn" onclick="incPro(this)">+</button>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="shoping__cart__total">
                                        ${itemTotal + "₫"}
                                    </td>
									<td class="shoping__cart__item__close">
										<span class="icon_close" type="button" onclick="delRow(this)"></span>
                                    </td>
								</tr>`
		});
		var totalC = priceText(cartCost);
		
		checkOut.innerHTML = `	<li>Subtotal <span>${totalC + "₫"}</span></li>
                            	<li>Total <span>${totalC + "₫"}</span></li>`
	}
}



function delRow(x){
	if (confirm('Are you sure you want to remove this product from cart?')) {
		var rowIndex = x.parentElement.parentElement.rowIndex;
		let cartItems = localStorage.getItem("productsInCart");
		cartItems = JSON.parse(cartItems);

		updateCartNumbers(- cartItems[Object.keys(cartItems)[rowIndex - 1]].inCart);
		updateTotalCost(cartItems[Object.keys(cartItems)[rowIndex - 1]], - cartItems[Object.keys(cartItems)[rowIndex - 1]].inCart);
		delete cartItems[Object.keys(cartItems)[rowIndex - 1]];

		document.getElementById("myTable").deleteRow(rowIndex);
		localStorage.setItem("productsInCart", JSON.stringify(cartItems));
		displayCart();
	} else {
	// Do nothing!
	}
}

function incPro(x){
	var rowIndex = x.parentElement.parentElement.parentElement.parentElement.rowIndex;
	let cartItems = localStorage.getItem("productsInCart");
	cartItems = JSON.parse(cartItems);

	updateCartNumbers(1);
	updateTotalCost(cartItems[Object.keys(cartItems)[rowIndex - 1]], 1);

	localStorage.setItem("productsInCart", JSON.stringify(cartItems));
	displayCart();
}
	   
function decPro(x){
	var rowIndex = x.parentElement.parentElement.parentElement.parentElement.rowIndex;
	let cartItems = localStorage.getItem("productsInCart");
	cartItems = JSON.parse(cartItems);
	if (cartItems[Object.keys(cartItems)[rowIndex - 1]].inCart == 1){
		alert("Quantity cannot be lower than one! \nPlease use right button to remove product instead.");
	}
	else{
		updateCartNumbers(-1);
		updateTotalCost(cartItems[Object.keys(cartItems)[rowIndex - 1]], -1);
	
		localStorage.setItem("productsInCart", JSON.stringify(cartItems));
		displayCart();
	}
}

function updateCartNumbers(number){
	let productNumbers = localStorage.getItem('cartNumbers');
	productNumbers = parseInt(productNumbers) + number;
	localStorage.setItem('cartNumbers', productNumbers);
	onLoadCartNumbers();
}

function updateTotalCost(product, number){
	let cartCost = localStorage.getItem('totalCost');
	cartCost = parseInt(cartCost) + product.price * number;
	localStorage.setItem('totalCost', cartCost);
	product.inCart += number;
}

function removeAll(){
	if (confirm('Remove all products from cart?')) {
		localStorage.clear();
		displayCart();
	}
	location.reload();
}
onLoadCartNumbers();
displayCart();
