import React, { Component } from 'react';

import './Home.css'

class Home extends Component {
    constructor(){
        super();
        this.state = {
            txtName : '',
            txtPass : '',
            authentication :[
                { user: 'admin', pass: 'admin' },
                { user: '0911421350 ', pass: 'admin' },
                { user: 'sang', pass: 'admin' }],
            isLogged: false,
            errors : []
        }

        this.onSubmit = this.onSubmit.bind(this);
        this.onChange = this.onChange.bind(this);
    }

    onSubmit(event){
        event.preventDefault();
        const {txtName, txtPass, authentication} = this.state; 
        /* Check account */
        var errors = [];
        if(txtName.length === 0)
            errors.push('Please enter your Username');

        if(txtPass.length === 0)
            errors.push('Please enter your Password');

        if(errors.length === 0)
            for(let index = 0; index < authentication.length; index++) {
                if(authentication[index].user === txtName){
                    if(authentication[index].pass !== txtPass){
                        errors.push('Wrong password');
                        break;
                    }
                    else break;
                }
                else if(index === authentication.length - 1){
                    errors.push('Cannot found your Username');
                }
            }

        this.setState({ errors, isLogged: true });
    }

    onChange(event){
        const target = event.target;
        const {name, value} = target;

        this.setState({
            [name]: value
        })
    }
    
    render(){
        const listError = this.state.errors.map((err, index) => {
            return <div className="alert alert-danger" key={index}>
            {err}
          </div>
        })
        return (
        <div className='root'>
            <div className='heading'>
                <div className='navigation-heading'>
                    <nav className="navbar navbar-expand-lg navbar-light bg-turquoise">
                        <a className="navbar-brand" href='/'>HomePage</a>
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
            <div className='loginForm'>
                <div className='header'>Login</div>
                
                <form className="form-group" onSubmit={this.onSubmit}>
                    <label >Username</label>
                    <input 
                        type="text" 
                        className="form-control" 
                        name="txtName"
                        onChange={this.onChange}
                        autoComplete='on'/>
                    <label>Password</label>
                    <input 
                        type="password" 
                        className="form-control" 
                        name="txtPass" 
                        autoComplete='on'
                        onChange={this.onChange}/>

                    <button type="submit" className="btn">Login</button>
                </form>
                {
                    this.state.errors.length > 0 && <div className='errors'> {listError} </div>
                }  
            </div>
        </div>
        );
    }
}

export default Home;