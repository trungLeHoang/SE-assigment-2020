import React, { Component } from 'react';
import Header from './components/Header';
import SelectRule from './components/SelectRule'
import Order from './components/Order'
import Search from './components/Search'

import './Manager.css';

class Manager extends Component {
  constructor(){
    super();
    this.state = {
      isChoosing : 'order',
      isSearching: false,
      isSorting: false,
      orderList: [
        {ID: '1234', userID: 'HUNG', item: 4, amount: '999.000', time: '16 : 30', isDone: true},
        {ID: '6789', userID: 'SANG', item: 8, amount: '888.000', time: '17 : 00', isDone: false},
        {ID: '1297', userID: 'HUNG', item: 2, amount: '120.000', time: '16 : 59', isDone: true},
        {ID: '2843', userID: 'SANG', item: 3, amount: '150.000', time: '2 : 30', isDone: false},
        {ID: '8246', userID: 'HUNG', item: 1, amount: '20.000', time: '4 : 44', isDone: true},
        {ID: '4321', userID: 'HUNG', item: 4, amount: '999.000', time: '16 : 30', isDone: false},
        {ID: '9876', userID: 'SANG', item: 8, amount: '888.000', time: '17 : 00', isDone: true},
        {ID: '3621', userID: 'HUNG', item: 2, amount: '120.000', time: '16 : 59', isDone: true},
        {ID: '4152', userID: 'SANG', item: 3, amount: '150.000', time: '2 : 30', isDone: false},
        {ID: '3162', userID: 'HUNG', item: 1, amount: '20.000', time: '4 : 44', isDone: true}
      ],
      searchedList: []
    };

    this.onSearchButton = this.onSearchButton.bind(this);
    this.onClickButton = this.onClickButton.bind(this);
    this.hiddenSearch = this.hiddenSearch.bind(this);
    this.onChangeSearchInput = this.onChangeSearchInput.bind(this);
    this.sortOrder = this.sortOrder.bind(this);
    this.onSortOrder = this.onSortOrder.bind(this);
  }

  /* Clicked to search */
  onSearchButton = (event) => {
    this.setState({
      isSearching: true
    });
  }
 
  /* Choose tab header */
  onClickButton = (event) => {
    this.setState({
      isChoosing: event.target.name
    });
  }

  /* When typing on search <input> */
  onChangeSearchInput = (event) => {
    const value = event.target.value;
    const searchedList = this.state.orderList.filter(item => {
      return item.ID.indexOf(value) !== -1 || item.userID.indexOf(value) !== -1 ? item : ''; 
    });

    this.setState({
      searchedList: searchedList
    });
  }

  /* Return empty for Searched List, and hide search bar */
  hiddenSearch = () => {
    this.setState({
      searchedList: [],
      isSearching: false
    });
  }

  /* Restaurant completed the order */
  onCompleOrder = (itemID) => {
    /* Sort searchedList when in Sorting mode */
    if(this.state.isSorting === true && this.state.isSearching === true){
        const changeIsDoneOrderList = this.state.searchedList.map((item) => {
            if(item.ID === itemID){
              item.isDone = true;
              return item;
            }
            else return item;
          });
      
        this.setState({
            searchedList: changeIsDoneOrderList
        });
        this.onSortSearch();
    }
    
    else {
        const changeIsDoneOrderList = this.state.orderList.map((item) => {
            if(item.ID === itemID){
              item.isDone = true;
              return item;
            }
            else return item;
          });
      
        this.setState({
            orderList: changeIsDoneOrderList
        });
        
        /* Sort orderList when not in Sorting mode */
        if(this.state.isSorting === true && this.state.isSearching === false)
            this.onSortOrder();
    }
    
  }

  onSortOrder = () => {
    const sortedList = this.sortOrder(this.state.orderList);

    this.setState({
      isSorting: true,
      orderList: sortedList
    });
  }

  onSortSearch = () => {
    const sortedList = this.sortOrder(this.state.searchedList);

    this.setState({
      isSorting: true,
      searchedList: sortedList
    });
  }

  sortOrder = (Array) => {
    var sortedList = [];
    const isDoneOrder = [];

    Array.map(item => {
      if(item.isDone === true)
        return isDoneOrder.push(item);
      else return sortedList.push(item);  /* Let not done order on top */
    });

    return sortedList.concat(isDoneOrder);
  }

  render(){
    const {isChoosing, isSearching, orderList, searchedList} = this.state;
    const list = isSearching ? searchedList : orderList;

    const listOrder = list.map((order, index) => (
      <Order
        key={index}
        ID= {order.ID} 
        item= {order.item}
        amount= {order.amount}
        time= {order.time}
        isDone= {order.isDone}
        onComplete= {this.onCompleOrder}
      />
    ));

    return(
      <div>
        <Header onSearch={this.onSearchButton} onSorted= {this.onSortOrder}/>
        <SelectRule isChoosing= {isChoosing} onClick={this.onClickButton}/>
        {
          isSearching === true && 
          <Search 
            onChange={this.onChangeSearchInput}
            hiddenSearch={this.hiddenSearch}/>
        }
        {
          isChoosing === 'order' &&
          <div className='OrderList'>  
            {listOrder}
          </div>
        }
      </div>
    );
  }
}

export default Manager;
