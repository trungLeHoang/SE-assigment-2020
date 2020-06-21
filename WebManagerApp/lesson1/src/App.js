import React, { Component } from 'react';
import {BrowserRouter as Router, Route} from 'react-router-dom'
import ManagerPage from './Manager'
import './App.css';

class App extends Component {
    render() {
        return(
            <Router>
                <Route path='/' component={Home} exact/>
                <Route path='/manager' component={ManagerPage} exact/>
            </Router>
        );
    }
}

const Home = () => {
    return (
        <div className='heading'>
            <div className='navigation-heading'>
                <nav className="navbar navbar-expand-lg navbar-light bg-light">
                    <a className="navbar-brand" href='/'>Home Page</a>
                    <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span className="navbar-toggler-icon"></span>
                    </button>
                    <div className="collapse navbar-collapse" id="navbarNav">
                        <ul className="navbar-nav">
                            <li className="nav-item active">
                                <a className="nav-link" href="/order">Order <span className="sr-only">(current)</span></a>
                            </li>
                            <li className="nav-item">
                                <a className="nav-link" href="/manager">Manager<span className="sr-only">(current)</span></a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </div>
        </div>
    );
}

export default App;
