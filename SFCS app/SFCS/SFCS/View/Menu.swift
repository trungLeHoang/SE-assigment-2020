//
//  Menu.swift
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



//Menu when clicking to the button at the left corner of the top
struct Menu : View {
    @Binding var foodmenu : Bool
    @Binding var size : CGFloat
    @Binding var cart : Bool
    @Binding var account : Bool
    @State var checkout = false
    @Binding var alert : Bool
    @Binding var error : String
    @State var aboutus = false
    @State var youraccount = false
    
    
    var body : some View{
        
        VStack{
            
            if self.checkout {
                NavigationLink(destination: CheckOutScreen(checkout: self.$checkout), isActive: self.$checkout) {
                    Text("")
                }
                .hidden()
            }
            else if self.foodmenu {
                NavigationLink(destination: FoodMenu(foodmenu: self.$foodmenu, cart: self.$cart, account: self.$account), isActive: self.$checkout) {
                    Text("")
                }
                .hidden()
                
                if self.aboutus {
                    NavigationLink(destination: ContactScreen(aboutus: self.$aboutus), isActive: self.$aboutus) {
                        Text("")
                    }
                    .hidden()
                }
                else if self.youraccount {
                    NavigationLink(destination: AccountScreen(youraccount: self.$youraccount), isActive: self.$youraccount) {
                        Text("")
                    }
                    .hidden()
                }
            }
            else if self.aboutus {
                NavigationLink(destination: ContactScreen(aboutus: self.$aboutus), isActive: self.$aboutus) {
                    Text("")
                }
                .hidden()
            }
            else if self.youraccount {
                NavigationLink(destination: AccountScreen(youraccount: self.$youraccount), isActive: self.$youraccount) {
                    Text("")
                }
                .hidden()
            }
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    self.size =  UIScreen.main.bounds.width / 1.6
                }) {
                    Text("X")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 15, height: 15)
                        .padding()
                }
                .background(Color("Yellow"))
                .foregroundColor(.white)
                .clipShape(Circle())
                .offset(x: -10,y:10)
            }
            
            HStack{
                Button(action: {
                    self.size = UIScreen.main.bounds.width / 1.6
                    self.foodmenu = false
                }) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.black)
                        .padding()
                                   
                    Text("Home")
                        .foregroundColor(Color.black)
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
                
           
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                Button(action: {
                    self.size =  UIScreen.main.bounds.width / 1.6
                    self.youraccount.toggle()
                }) {
                    Image("person")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                        
                    Text("Account").fontWeight(.heavy).foregroundColor(.black)
                            
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                Button(action: {
                    self.size = UIScreen.main.bounds.width / 1.6
                    self.foodmenu = true
                }) {
                    Image("wine")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    
                    Text("Full menu").fontWeight(.heavy).foregroundColor(.black)
                    
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                Button(action: {
                    self.size =  UIScreen.main.bounds.width / 1.6
                    self.checkout.toggle()
                }) {
                    Image("payment")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    
                    Text("Your order").fontWeight(.heavy).foregroundColor(.black)
                    
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                Button(action: {
                    self.size =  UIScreen.main.bounds.width / 1.6
                    self.aboutus.toggle()
                }) {
                    Image("question")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    
                    Text("About us").fontWeight(.heavy).foregroundColor(.black)
                    
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                 Button(action: {
                    if(UserDefaults.standard.bool(forKey: "haveOrder") == true){
                        self.alert.toggle()
                        self.error = "Please, log out your account after your order is done"
                    }
                    else {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }
                }) {
                    Image("logout")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    Text("Log out").fontWeight(.heavy).foregroundColor(.black)
                
                    Spacer()
                 }
                 .background(Color("Yellow"))
                 .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color("Dark"))
        .animation(.spring())

    }
}

//Food menu view by clicking "Full menu"
struct FoodMenu : View {
    
    @Environment(\.colorScheme) var scheme
    @Binding var foodmenu : Bool
    @Binding var cart : Bool
    @Binding var account : Bool
    @State var show = false
    @State var size = UIScreen.main.bounds.width / 1.6
    @State var data = Type(id: -1, name: "", cName: "", price: 0,image: "")
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
                VStack{
         
                    ZStack{
                        
                        HStack(spacing: 15){
                            
                            Button(action: {
                                self.size = 5
                                if (UserDefaults.standard.bool(forKey: "haveOrder") == true){
                                    getStatus()
                                }
                            }) {
                                Image("menu")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:35 , height:35)
                                    .padding()
                            }
                            .background(Color("Yellow"))
                            .cornerRadius(25)
                                
                            Spacer()
                                
                            Button(action: {
                                if (UserDefaults.standard.bool(forKey: "haveOrder") == true){
                                    getStatus()
                                }
                                
                                self.cart.toggle()
                            }) {
                                Image("buy")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:35 , height:35)
                                    .padding()
                            }
                            .background(Color("Yellow"))
                            .cornerRadius(25)
                        }
                        
                        Text("Menu")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Main meal")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(meal,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if UserDefaults.standard.bool(forKey: "haveOrder") != false {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .frame(width: (UIScreen.main.bounds.width/2)-50)
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Drink")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(drink,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if UserDefaults.standard.bool(forKey: "haveOrder") != false {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                                                   
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Extra")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(extra,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if UserDefaults.standard.bool(forKey: "haveOrder") != false {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Dessert")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(dessert,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if UserDefaults.standard.bool(forKey: "haveOrder") != false {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                                                   
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: self.$show) {
                    OrderView(data: self.data,show: self.$show)
                }
                   
                
               HStack{
                    Menu(foodmenu: self.$foodmenu, size: self.$size, cart: self.$cart, account: self.$account,alert: self.$alert,error: self.$error)
                        .cornerRadius(20)
                        .padding(.leading, -size)
                        .offset(x: -size)
                                                                                            
                    Spacer()
                }
                .animation(.spring())
                
                if self.alert{
                    errorView(alert: self.$alert, error: self.$error)
                }
            }
            .background(Color("Grey").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

//Checkout view/ Order information view by clicking "Full menu"
struct CheckOutScreen : View {
    
    @Binding var checkout : Bool
    
    var body: some View {
        
        NavigationView{
            ZStack {
                
                Color("Grey").edgesIgnoringSafeArea(.all)

                if UserDefaults.standard.bool(forKey: "haveOrder") != false {
                   
                    VStack(spacing: 10){
                       
                        VStack(spacing: 10) {
                            
                            Text("Your Order ID:")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(Color("Yellow"))
                            
                            Text(String(OrderID))
                                .fontWeight(.bold)
                                .frame(width: 75,height: 75)
                                .padding()
                                .background(Color("Yellow"))
                                .foregroundColor(Color.black)
                                .cornerRadius(75)
                              
                            VStack(alignment: .leading){
                                HStack {
                                    VStack(alignment: .leading){
                                        Text("Name: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                        
                                        Text("Pick up time: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                        
                                        Text("Payment type: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                        
                                        Text("Total: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                    }
                                    
                                    VStack(alignment: .leading){
                                        Text(UserDefaults.standard.string(forKey: "userEmail")!)
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                        Text( timeFormatter.string(from: tPickUp))
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                        Text(paymentType)
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                        Text(String(nTotal)+" VNĐ")
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width-50 )
                            .background(Color("Yellow"))
                            .cornerRadius(20)
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width-25,height: 410)
                        .background(Color("Dark"))
                        .cornerRadius(30)
                        .padding(.top,-60)
               
                        VStack(spacing: 10) {
                          
                            Text("Order's Status")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(Color("Yellow"))
                            
                            if status == "confirm" {
                                Image("accept")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200,height:200)
                                
                                Text("Your order is successfully confirm.")
                                    .foregroundColor(Color("Yellow"))
                            }
                            else if status == "cooking" {
                                Image("soup")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200,height:200)
                                
                                Text("Your order is preparing.")
                                    .foregroundColor(Color("Yellow"))
                            }
                            else if status == "finish" {
                                Image("dinner")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200,height:200)
                                
                                Text("Your order is done. Please pick up at the court")
                                    .foregroundColor(Color("Yellow"))
                            }
                          
                            HStack(spacing: 10){
                            
                                Rectangle()
                                    .frame(width:110,height: 10)
                                    .foregroundColor(Color("Yellow"))
                                    .cornerRadius(5)
                                
                                if status == "cooking" || status == "finish" {
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color("Yellow"))
                                        .cornerRadius(5)
                                }
                                else {
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                }
                                
                                if status == "finish"{
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color("Yellow"))
                                        .cornerRadius(5)
                                }
                                else {
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                }
                            }
                               
                            HStack(spacing: 10) {
                              
                                if status == "finish" {
                                    
                                    HStack(spacing: 5){
                                                        
                                        Image("back")
                                            .renderingMode(.original)
                                            .resizable()
                                            .frame(width:15 , height:15)
                                            .padding(.vertical)
    
                                        Text("Return")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.black)
                                            .padding(.vertical)
                                    }
                                    .frame(width: ((UIScreen.main.bounds.width-50)/3)-5)
                                    .background(Color("Grey"))
                                    .cornerRadius(10)
                                }
                                else {
                                    Button(action: {
                                        self.checkout.toggle()
                                    }){
                                        HStack(spacing: 5){
                                            Image("back")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width:15 , height:15)
                                                .padding(.vertical)
                                                
                                            Text("Return")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.black)
                                                .padding(.vertical)
                                        }
                                        .frame(width: ((UIScreen.main.bounds.width-50)/3)-5)
                                        .background(Color("Yellow"))
                                        .cornerRadius(10)
                                    }
                                    .frame(width: ((UIScreen.main.bounds.width-50)/3)-5)
                                    .background(Color("Yellow"))
                                    .cornerRadius(10)
                                }
                                
                                if status != "finish" {
                                    Text("Not done yet")
                                        .padding()
                                        .frame(width: 2*((UIScreen.main.bounds.width-50)/3)-5)
                                        .foregroundColor(Color.white)
                                        .background(Color("Grey"))
                                        .cornerRadius(10)
                                }
                                else {
                                    Button(action: {
                                        UserDefaults.standard.setValue(false, forKeyPath: "haveOrder")
                                        self.checkout.toggle()
                                    }){
                                        Text("Done")
                                            .fontWeight(.bold)
                                            .frame(width: 2*((UIScreen.main.bounds.width-50)/3)-5)
                                            .padding(.vertical)
                                            .foregroundColor(Color.black)
                                            .background(Color("Yellow"))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width-25,height: 410)
                        .background(Color("Dark"))
                        .cornerRadius(30)
                        
                        Spacer()
                    }
                }
                else {
                    VStack{
                        Spacer()
                        
                        Text("You don't have any order")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(Color.black)
                        
                        Button(action: {
                            self.checkout.toggle()
                        }){
                            HStack(spacing: 5){
                                Image("back")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:15 , height:15)
                                    .padding(.vertical)
                                    
                                Text("Return")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                            }
                            .frame(width: UIScreen.main.bounds.width-50)
                            .background(Color("Yellow"))
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)

    }
}

struct AccountScreen : View {
    
    @Binding var youraccount : Bool
    
    var body: some View {
        
       NavigationView{
        
            ZStack {
                
                Color("Grey").edgesIgnoringSafeArea(.all)

                VStack(spacing: 10){
                       
                    VStack(spacing: 10) {
                            
                        Text("Account Information")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(Color("Yellow"))
                            
                        Image("avatar")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 100,height: 100)
                          
                        VStack(alignment: .leading){
                            HStack {
                                VStack(alignment: .leading){
                                    Text("Email: ")
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                    Text("Name: ")
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                }
                                    
                                VStack(alignment: .leading){
                                    Text(UserDefaults.standard.string(forKey: "userEmail")!)
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                    Text("...")
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width-50)
                        .background(Color("Yellow"))
                        .cornerRadius(20)
                            
                        Spacer()
                            
                        Button(action: {
                            self.youraccount.toggle()
                        }){
                            HStack(spacing: 5){
                                Image("back")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:15 , height:15)
                                    .padding(.vertical)
                                             
                                    
                                Text("Return")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                            }
                            .frame(width: UIScreen.main.bounds.width-50)
                            .background(Color("Yellow"))
                            .cornerRadius(10)
                            .padding()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width-25,height: 820 )
                    .background(Color("Dark"))
                    .cornerRadius(30)
                    .padding(.top,-60)
               
                    Spacer()
                }
            }
       }
       .navigationBarBackButtonHidden(true)
       .navigationBarTitle("")
       .navigationBarHidden(true)
    }
}

struct ContactScreen : View {
    
    @Binding var aboutus : Bool
    
    var body: some View {
        
       NavigationView{
        
            ZStack {
                
                Color("Grey").edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10){
                       
                    VStack(spacing: 10) {
                            
                        Text("Develop Informatio")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Yellow"))
                            
                              
                        VStack(alignment: .leading){
                            VStack {
                                Text("SFCS iOS Application")
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(Color.black)
                                    
                                Text("is a part of SFCS ecosystem.")
                                    .padding()
                                    .foregroundColor(Color.black)
                                    
                                Image("delivery")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 100,height: 100)
                            
                                Text("Created bY ĐẶNG NHẬT QUÂN on June 7 2020.")
                                    .padding()
                                    .foregroundColor(Color.black)
                                    
                                Text("Copyright © 2020 Đặng Nhật Quân. All rights reserved.")
                                    .padding()
                                    .foregroundColor(Color.black)
                                    
                                Text("with the cooperation of")
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(Color.black)
                                    
                                HStack{
                                    Image("BKU-logo")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 75,height: 75)
                                    
                                    Image("CSE-logo")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 75,height: 75)
                                        
                                    Image("google")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 75,height: 75)
                                }
                                HStack{
                                    Image("momo")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 75,height: 75)
                                                                
                                    Image("fb")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 75,height: 75)
                                                                           
                                    Image("company")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 75,height: 75)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width-50,height: 700)
                        .background(Color("Yellow"))
                        .cornerRadius(20)
                                                   
                        Button(action: {
                            self.aboutus.toggle()
                        }){
                            HStack(spacing: 5){
                                Image("back")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:15 , height:15)
                                    .padding(.vertical)
                                             
                                Text("Return")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                            }
                            .frame(width: UIScreen.main.bounds.width-50)
                            .background(Color("Yellow"))
                            .cornerRadius(10)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width-25,height: 820 )
                    .background(Color("Dark"))
                    .cornerRadius(30)
                    .padding(.top,-60)
               
                       
                        
                    Spacer()
                }
            }
       }
       .navigationBarBackButtonHidden(true)
       .navigationBarTitle("")
       .navigationBarHidden(true)
    }
}
