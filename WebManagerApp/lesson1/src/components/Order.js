	import React, { Component } from 'react';
	import classNames from 'classnames';
	import './Order.css'

	class Order extends Component {
	constructor(props){
		super(props);
		this.state = {
		showOrder: false
		};
	}

	showOrder = (event) => {
		this.setState({
		showOrder: true
		});
	}

	onComplete = (event) => {
		this.setState({
		showOrder: false
		});

		/* Change order color */
		this.props.onComplete(this.props.ID);
	}

	hiddenOrder = () => {
		this.setState({
		showOrder: false
		});
	}

	render(){
		const {ID, userID, itemList, isDone} = this.props;
		
		const {showOrder} = this.state;
		var numItem = 0, totalPrice = 0, listDishes;
		if(itemList){
			/* Find out number of items and amount, gain item list */
			listDishes = itemList.map((item, index) => {
				numItem += item.quantity;
				totalPrice += item.quantity * item.price;

				return <div className='dishes' key={index}>
					<span className='quantity'>{item.quantity}x</span>
					<span className='name'>{item.name}</span>
					<span className='price'>{item.price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ</span>
				</div>
			});
		}
		
		/* create pickup tiem */
		const Time = new Date();
		const HMSeconds = (Time.getHours() < 10 ? '0' + Time.getHours() : Time.getHours()).toString() 
		+ ':' + (Time.getMinutes() < 10 ? '0' + Time.getMinutes() : Time.getMinutes()).toString()

		return(
		<div>
				{
				/* show list order, when not show Order */
				<div className= {classNames('contain',{
					'onGoing': isDone === false })}
					onClick= {this.showOrder}>
					<div className='left-component'>
						<p className='ID'>#{ID}</p>
						<p className='item'> {numItem} item | {totalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ</p>
					</div>
					<div className='right-component'>
						<p className='pickup'>PICK UP</p>
						<p className='time'>{HMSeconds}</p>   
					</div>     
				</div>
				}
				{
				showOrder === true && 
				<div className='showOrder'>
				<div className='heading'>
					<div className='ID'>#{ID}</div>
					<span
					className="input-group-text btn-hidden"
					onClick={this.hiddenOrder}
					>X</span>
				</div>

					<div className='user-info'>
						<div className='left'>
						<p>User: {userID}</p>
						<p>Date: {HMSeconds}</p>
						</div>
						<div className='right'>
						{
							isDone === false && <p>Making</p>
						}
						{
							isDone && <p>Completed</p>
						}
						</div>
					</div>

				<div className='menu'>
					<div className='menu-title'>
					<span>Menu</span>
					<span className='menu-price'>{totalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ ({numItem})</span>
					</div>
					
					<div className='listDishes'>
					{listDishes}
					<div className='dishes conclusion'>
						<span className='name'>Total: </span>
						<span className='price'>{totalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ</span>
					</div>
					</div>

					</div>

					<button 
					type="button" 
					className="btn btn-info btn-order"
					onClick={this.onComplete}
					>Completed
					</button>
				</div>
				}
		</div>
		);
	}
	}

	export default Order;
