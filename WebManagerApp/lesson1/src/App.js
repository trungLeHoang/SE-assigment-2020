import React, {Component} from 'react';
import {BrowserRouter as Router, Route, Redirect} from 'react-router-dom'
import Cookies from 'js-cookie'
import md5 from 'md5'

import Home from './components/Home'
import ManagerPage from './Manager'
import './App.css';

class App extends Component {
    constructor(){
        super();
        this.state = {
            auth: false
        }
        
        this.onLogin = this.onLogin.bind(this);
    }

    ProtectManager = () => {
        return Cookies.get('user') ? 
            <ManagerPage/>    
            : <Redirect to='/'/>
    }

    onLogin = (txtName) => {
        this.setState({ auth: true });
        Cookies.set("user", md5(txtName), {expires: 1});
    }

    render(){
        return(
            <Router>
                <Route 
                    path='/' 
                    exact component={() => <Home onLogin= {this.onLogin} isLogged={this.state.auth}/>}
                />
                <Route
                    path='/manager'
                    exact component={this.ProtectManager}
                />
            </Router>
        );
    }
}

export default App;
