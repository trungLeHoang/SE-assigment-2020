import React, { Component } from 'react';
import { Button } from 'reactstrap';
import './Header.css'

class Header extends Component {
  onSearch = (event) => {
    this.props.onSearch(event);
  }

  onSorted = () => {
    this.props.onSorted();
  }

  render(){
    return(
        <div className='heading'>
            <div className="dropdown open">
              <button className="btn button dropdown-toggle" type="button" id="triggerId" data-toggle="dropdown" aria-haspopup="true"
                  aria-expanded="false">
              </button>
              <div className="dropdown-menu" aria-labelledby="triggerId">
                <button 
                  className="dropdown-item"
                  name='search'
                  onClick={this.onSearch}
                  >Search Order
                </button>
                <button 
                  className="dropdown-item"
                  name='search'
                  onClick={this.onSorted}
                  >Sorted Order
                </button>
                <button className="dropdown-item disabled" href="#">Disabled action</button>
              </div>
            </div>
            <span className='span'>Order</span>
            <Button className='button'>
                HELP
            </Button>
        </div>
    );
  }
}

export default Header;
