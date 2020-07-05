import React, { Component } from 'react';

class Report extends Component {
constructor(props){
    super(props);
    this.state = {
    showReport: false
    };
}

showReport = (event) => {
    this.setState({
    showReport: true
    });
}

hiddenReport = () => {
    this.setState({
    showReport: false
    });
}

render(){
    const {time, date, itemList} = this.props;
    var listDishesJSX, numItemReport = 0, totalPriceReport = 0;

    if(itemList){
        /* Find out number of items and amount, gain item list */
        listDishesJSX = itemList.map((item, index) => {
            numItemReport += item.quantity;
            totalPriceReport += item.quantity * item.price;

            return <div className='dishes' key={index}>
                <span className='quantity'>{item.quantity}x</span>
                <span className='name'>{item.name}</span>
                <span className='price'>{item.price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ</span>
            </div>
        });
    }

    return(
    <div>
        {
            /* show list order, when not show Order */
            <div className= 'contain'
                onClick= {this.showReport}>
                <div className='left-component'>
                    <p className='ID centering'>#{time}</p>
                    <p className='item centering'> {numItemReport} item | {totalPriceReport.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ</p>
                </div>
            </div>
        }
        {
            this.state.showReport === true && 
            <div className='showOrder'>
                <div className='heading'>
                    <div className='ID'>#{date}</div>
                    <span
                        className="input-group-text btn-hidden"
                        onClick={this.hiddenReport}
                    >X</span>
                </div>

                <div className='user-info'>
                    <div className='left'>
                    <p>Manager: Sang</p>
                    <p>Time created: {time}</p>
                    </div>
                </div>

                <div className='menu'>
                    <div className='menu-title'>
                        <span>Conclusion</span>
                        <span className='menu-price'>{numItemReport} items</span>
                    </div>
                    
                    <div className='listDishes'>
                        {listDishesJSX}
                        <div className='dishes conclusion'>
                        <span className='name'>Total: </span>
                        <span className='price'>{totalPriceReport.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}đ</span>
                        </div>
                    </div>
                </div>
            </div>
        }
    </div>
    );
}
}

export default Report;
