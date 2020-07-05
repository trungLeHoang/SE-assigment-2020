import React, { Component } from 'react';
import Report from './Report'

import './ShowReport.css'

var dbReport;
const Time = new Date();

const HMSecondsColon = (Time.getHours() < 10 ? '0' + Time.getHours() : Time.getHours()).toString() 
+ ':' + (Time.getMinutes() < 10 ? '0' + Time.getMinutes() : Time.getMinutes()).toString() 
+ ':' + (Time.getSeconds() < 10 ? '0' + Time.getSeconds() : Time.getSeconds()).toString();

const DMYear = Time.getDate().toString() + (Time.getMonth() + 1).toString() + Time.getFullYear().toString();
const DMYearSlash = Time.getDate().toString() + '/' + (Time.getMonth() + 1).toString() + '/' + Time.getFullYear().toString();

class ShowReport extends Component {
	_isMounted = false;

	constructor(props){
		super(props);
		this.state = {
			createReport: false,
			showReport: false,
			shortenListReport: [],
			itemListReport: [],
			listReport: []
		};
	}

	componentDidMount(){
		this._isMounted = true;
		dbReport = this.props.dbReport;
		dbReport.on('value', snap => {
			if(this._isMounted)
				this.setState({ listReport: snap.val()}); //Get all report
		})
	}

	componentWillUnmount(){
		this._isMounted = false;
	}

	onCreateReport = () => {
		var shortenListReport = [];
		var newList = JSON.parse(JSON.stringify(this.props.itemListReport));
		
		for(var i = 0; i < newList.length; i++){
		const item = newList[i];
		const index = shortenListReport.findIndex(ele => ele.name === item.name);

		if(index === -1)
			shortenListReport = [...shortenListReport, item];
		else
			shortenListReport[index].quantity += item.quantity;
		}
		
		/* set data on database */
		const Time = new Date();
		const HMSeconds = (Time.getHours() < 10 ? '0' + Time.getHours() : Time.getHours()).toString() 
		+ (Time.getMinutes() < 10 ? '0' + Time.getMinutes() : Time.getMinutes()).toString() 
		+ (Time.getSeconds() < 10 ? '0' + Time.getSeconds() : Time.getSeconds()).toString();

		dbReport.child(DMYear + '/' + HMSeconds).set(shortenListReport);

		/* Set State */
		this.setState({
			createReport: true,
			shortenListReport
		});
	}

	onShowReport = () => {
		var listReportJSX = [];
		const {listReport} = this.state;
		
		Object.keys(listReport).map((date, i1) => {
			const listDate = listReport[date];

			Object.keys(listDate).map((time, i2) => {
				const timeColon = time.substr(0,2) + ':' + time.substr(2,2) + ':' + time.substr(4,2);
				
				const orderList = listDate[time];
					listReportJSX = [
						<Report 
							key={10*i1 + i2}
							time={timeColon}
							date={date}
							itemList={orderList}
						/>,
						...listReportJSX,
					];
				return 0;
			});
			
			const dateSlash =  date.substr(0, date.length - 5)
				+ '/' + date.substr(date.length - 5, 1)
				+ '/' + date.substr(-4);
				
			listReportJSX = [
				<div className= 'contain centering red'>
					<h1>{dateSlash}</h1>	
				</div>,
				...listReportJSX,
			]
			return 0;
		});

		this.setState({
			showReport: true,
			listReportJSX
		});
		
	}

	onHiddenReport = () => {
		this.setState({
		createReport: false
		});
	}

	render(){
		var numItemReport = 0, totalPriceReport = 0, listDishesJSX;
		const {listReportJSX, shortenListReport} = this.state;
		
		/* List all dishes was ordered, and get number of items and total amount */
		if(shortenListReport){
			/* Find out number of items and amount, gain item list */
			listDishesJSX = shortenListReport.map((item, index) => {
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
				{	this.state.showReport === false &&
					<div className='showReport'>
						<div className="btn1 btn-report" onClick={this.onCreateReport}>Create a new report</div>
						<div className="btn2 btn-report" onClick={this.onShowReport}>View older report</div>
					</div> 
				}
				{
				this.state.createReport === true &&
				<div className='showOrder'>
					<div className='heading'>
						<div className='ID'>#{DMYearSlash}</div>
						<span
							className="input-group-text btn-hidden"
							onClick={this.onHiddenReport}
						>X</span>
					</div>

					<div className='user-info'>
						<div className='left'>
						<p>Manager: Sang</p>
						<p>Time created: {HMSecondsColon}</p>
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
				{
					this.state.showReport === true && <div className='OrderList'>
						{listReportJSX}
					</div>
				}
		</div>
		);
	}
}

export default ShowReport;
