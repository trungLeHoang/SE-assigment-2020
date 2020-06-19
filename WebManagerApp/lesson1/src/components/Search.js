import React, { Component } from 'react';
import './Search.css'

class Search extends Component {
    onChange = (event) => {
        this.props.onChange(event);
    }

    hiddenSearch = () => {
        this.props.hiddenSearch();
    }

    render(){
        return(
            <div className='search'>
                <div className="input-group mb-3">
                    <input 
                        type="text" 
                        className="form-control" 
                        placeholder="Search by OrderID or UserID"
                        name="txtSearch"
                        onChange={this.onChange}
                    />
                    <div className="input-group-prepend">
                        <span
                            className="input-group-text"
                            onClick={this.hiddenSearch}
                        >X</span>
                    </div>
                </div>
            </div>
        )
    }
}

export default Search;