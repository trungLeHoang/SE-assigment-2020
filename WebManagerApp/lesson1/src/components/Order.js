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

    console.log(event.target);

  }

  render(){
    const {ID, item, amount, time, isDone} = this.props;
    const {showOrder} = this.state;
    return(
      <div>
            {
              /* show list order, when not show Order */
              showOrder === false && <div className= {classNames('contain',{
                'onGoing': isDone === false })}
                onClick= {this.showOrder}>
                  <div className='left-component'>
                      <p className='ID'>#{ID}</p>
                      <p className='item'>{item} item | {amount}đ</p>
                  </div>
                  <div className='right-component'>
                      <p className='pickup'>PICK UP</p>
                      <p className='time'>{time}</p>   
                  </div>     
              </div>
            }
      </div>
    );
  }
}

export default Order;
