import React, { Component } from 'react';
import Header from './components/Header';
import SelectRule from './components/SelectRule'
import Order from './components/Order'
import Search from './components/Search'
import ShowReport from './components/ShowReport'

import firebase from 'firebase/app'
import firebaseConfig from './firebaseConfig'
import './Manager.css';

import 'firebase/database'
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
var dbOnl = [];

/* Update data for new day */
var schedule = require('node-schedule'); 
schedule.scheduleJob('0 0 0 * * *', function(){
  const Time = new Date();
  const thisDay = (Time.getMonth() + 1).toString() + (Time.getDate() < 10 ? '0' + Time.getDate() : Time.getDate()).toString();
  const url_nOrder = 'nOrder';
  const url_orderList = 'orderList';
  const url_dataByDate = 'dataByDate';
  
  firebase.database().ref(url_nOrder + '/nOrder').set(-1);
  firebase.database().ref(url_nOrder + '/orderID').set(Number(thisDay + '000'));
  firebase.database().ref(url_orderList).set([]);
  firebase.database().ref(url_dataByDate + '/' + thisDay).set(dbOnl);
});

class Manager extends Component {
  constructor(){
    super();
    this.state = {
      isChoosing : 'order',
      isSearching: false,
	    isSorting: false,
	    showReport: false,
      orderList: [],
      searchedList: [],
      itemListReport: []
    };

    this.onSearchButton = this.onSearchButton.bind(this);
    this.onClickButton = this.onClickButton.bind(this);
    this.hiddenSearch = this.hiddenSearch.bind(this);
    this.onChangeSearchInput = this.onChangeSearchInput.bind(this);
    this.sortOrder = this.sortOrder.bind(this);
    this.onSortOrder = this.onSortOrder.bind(this);
  }

  componentDidMount(){    
    const db = firebase.database().ref().child('orderList');

    db.on('value', snap => {
      //console.log('value', snap.val())
      if(snap.val()){
        dbOnl = snap.val();
        this.setState({
          orderList: snap.val().reverse()
        });
      }
      if(this.state.isSorting){
        if(this.state.isSearching)
          this.onSortSearch(); 
        else this.onSortOrder();
      }

      var newItemListReport = [];
      for(const order of this.state.orderList){
        for(const dish of order.itemList)
          newItemListReport.push(dish);
      }     
      this.setState({itemListReport: newItemListReport});
    });

    db.on('child_added', snap => {
      //console.log('child_added ', snap.val())
      dbOnl.push(snap.val());
      this.setState({
        orderList: [
          ...this.state.orderList,
          snap.val()
      ]
      });
    });
  }

/*				Show Order section				*/
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
      const ID = item.ID.toString();
      const userID = item.userID.toString();
      return ID.indexOf(value) !== -1 || userID.indexOf(value) !== -1 ? item : ''; 
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
    /* Set isDone of order on firebase by index */
    var indexDB;
    var url = 'orderList/';
    dbOnl.map((item, index) => {
      if(item.ID === itemID){
        indexDB = index;
        item.isDone = true;
      }
      return 0;
    });

    url += indexDB + '/isDone';
    firebase.database().ref(url).set(true);

    /* Sort order when in sorting mode - in local */
    const newOrderList = this.state.orderList.map((item) => {
      if(item.ID === itemID){
        item.isDone = true;
      }
      return item;
    });

    this.setState({
      orderList: newOrderList
    })

    if(this.state.isSorting){
      if(this.state.isSearching)
        this.onSortSearch(); 
      else this.onSortOrder();
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
      else return sortedList.push(item);  
    });

    return sortedList.concat(isDoneOrder); /* Let not done order on top */
  }

  render(){
    var listOrder;
    const {isChoosing, isSearching, orderList, searchedList} = this.state;
    const list = isSearching ? searchedList : orderList;
    
    if(list){
      listOrder = list.map((order, index) => (
        <Order
          key={index}
          ID= {order.ID}
          itemList={order.itemList}
          isDone= {order.isDone}
          userID= {order.userID}
          onComplete= {this.onCompleOrder}
        />
      ));
  	}

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
        {
          isChoosing === 'report' &&
          <ShowReport 
            itemListReport= {this.state.itemListReport}
            dbReport= {firebase.database().ref('/Report')}/>
        }
      </div>
    );
  }
}

export default Manager;