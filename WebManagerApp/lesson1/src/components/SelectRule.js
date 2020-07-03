import React, { Component } from 'react';
import ClassNames from 'classnames'
import './SelectRule.css'

class SelectRule extends Component {
    onClick = (event) => {
        this.props.onClick(event);
    }

    render(){
        const {isChoosing} = this.props;

        return(
        <div className='SelectRule'>
            <button 
                    type="button"
                    name='order'
                    className={ClassNames('btn button btn-lg btn-block',{ 
                        'active': isChoosing === 'order'})}
                    onClick={this.onClick}>
                    ORDER
            </button> 
            <button 
                type="button"
                name='report'
                className={ClassNames('btn button btn-lg btn-block',{ 
                    'active': isChoosing === 'report'})}
                onClick={this.onClick}>
                REPORT
            </button>    
        </div>
        );
    }
}

export default SelectRule;
