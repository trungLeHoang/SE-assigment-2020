//
//  SignUp.swift
//  SFCS
//
//  Created by Đặng Nhật Quân on 6/30/20.
//  Copyright © 2020 Đặng Nhật Quân. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import SDWebImageSwiftUI


//Login view
struct login : View {
    var googleSignIn = GIDSignIn.sharedInstance()
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        
        
        
        ZStack{
            
            Color("Dark").edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .topTrailing) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                         Image("delivery")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 200, height:  200)
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color("Yellow"))
                            .padding(.top, 35)
                            
                        
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .foregroundColor(Color("Yellow"))
                        .padding()
                            
                            .background(RoundedRectangle(cornerRadius: 10).stroke(self.email != "" ? Color("Yellow") : Color.white,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                        .foregroundColor(Color("Yellow"))
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                        .foregroundColor(Color("Yellow"))
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.white)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.pass != "" ? Color("Yellow") : Color.white,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.reset()
                                
                            }) {
                                
                                Text("Forget password ? ")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Yellow"))
                            }
                        }
                        .padding(.top, 20)
                        
                        Button(action: {
                            
                            self.verify()
                            getnOrder()
                        }) {
                            
                            Text("Log in")
                                .foregroundColor(.black)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        HStack(spacing:  15) {
                            
                            Rectangle()
                                .frame(width:80,height: 2)
                                .foregroundColor(Color.white)
                            
                            Text("by another account")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                 .background(Color("Dark"))
                            
                            Rectangle()
                            .frame(width:80,height: 2)
                            .foregroundColor(Color.white)
                            
                        }
                        .padding(.top)
                        
                        HStack(spacing: 20){
                            
                            Button(action: {
                                GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                                GIDSignIn.sharedInstance()?.signIn()
                            }){
                                
                               Image("google")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50,height:50)
                                
                            }
                            .padding(.top)
                            
                        }
                        .padding(.top,-20)
                        
                        
                        HStack(spacing: 5){
                            
                            Text("New user ? ")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .background(Color("Dark"))
                            
                            Button(action: {
                                self.show.toggle()
                            }){
                                
                               Text("Register here")
                                .fontWeight(.bold)
                                .foregroundColor(Color("Yellow"))
                                
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    
                }
                
                
            }
            
            if self.alert{
                
                errorView(alert: self.$alert, error: self.$error)
            }
        }
    
    }
    
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            userEmail = self.email
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                UserDefaults.standard.setValue(self.email, forKeyPath: "userEmail")
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

//Sign up view
struct signUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                Color("Dark").edgesIgnoringSafeArea(.all)
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        
                        Image("Signup-logo")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 200, height:  200)
                            
                        
                        Text("Register a new account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Yellow"))
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.email != "" ? Color("Yellow") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .foregroundColor(.white)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                    .foregroundColor(.white)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.pass != "" ? Color("Yellow") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.revisible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.repass != "" ? Color("Yellow") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            
                            self.register()
                        }) {
                            
                            Text("Register")
                                .foregroundColor(.black)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                }
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Yellow"))
                }
                .padding()
            }
            
            if self.alert{
                
                    errorView(alert: self.$alert, error: self.$error)
                    
            
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func register(){
        
        if self.email != ""{
            
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("success")
                    self.error = "Register succesfully"
                    self.alert.toggle()
                    
                    
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else{
                
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}

//Error noti when login fail
struct errorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Yellow"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color("Grey"))
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
