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
    const {ID, item, amount, time, isDone} = this.props;
    const {showOrder} = this.state;
    return(
      <div>
            {
              /* show list order, when not show Order */
              <div className= {classNames('contain',{
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
            {
              showOrder === true && 
              <div className='showOrder'>
                <div className='title-order'>
                      <p className='ID'>#{ID}</p>
                      <div className='contain-hidden'><span
                          className="input-group-text btn-hidden"
                          onClick={this.hiddenOrder}
                      >X</span>
                      </div>
                  </div>
                  <div className='right-component'>
                      <p className='time'>{time}</p>   
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
