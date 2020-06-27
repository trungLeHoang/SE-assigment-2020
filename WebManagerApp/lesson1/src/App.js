import React, { Component } from 'react';
import {BrowserRouter as Router, Route} from 'react-router-dom'

import Home from './components/Home'
import ManagerPage from './Manager'
import './App.css';

class App extends Component {
    render() {
        return(
            <Router>
                <Route 
                    path='/' 
                    exact component={Home}/>
                <Route 
                    path='/manager' 
                    exact component={ManagerPage}/>
            </Router>
        );
    }
}

export default App;
