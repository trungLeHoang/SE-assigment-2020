import SwiftUI

import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import SDWebImageSwiftUI

//UI
struct ContentView: View {
   
    var body: some View {
        
        Home()
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @State var account = false
    @State var cart = false
    @State var muilti = false
    @State var show = false
    @State var pickup = false
    @State var status = UserDefaults.standard.bool(forKey: "status")
    @State var checkout = false
    @State var mainscreen = false
    @State var foodmenu = false
  
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
                if self.status {
                    
                    
                    Mainscreen(foodmenu: self.$foodmenu, cart: self.$cart, account: self.$account)
                
                    if self.foodmenu {
                        FoodMenu(foodmenu: self.$foodmenu,cart: self.$cart, account: self.$account, show: self.show)
                        
                        if self.cart {
                                               
                            GeometryReader{_ in
                                                      
                                CartView(pickup: self.$pickup, cart: self.$cart)
                                                   
                                                      
                            }.background(
                                                      
                            Color.black.opacity(0.55)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                        self.cart.toggle()
                                }
                            )
                        }
                                           
                        if self.pickup {
                                      
                            NavigationLink(destination: pickUpScreen(pickup: self.$pickup,checkout: self.$checkout), isActive: self.$pickup) {
                                Text("")
                                                                                 
                            }
                            .hidden()
                        }
                    }
                    else {
                        if self.cart {
                            
                               GeometryReader{_ in
                                   
                                CartView(pickup: self.$pickup, cart: self.$cart)
                                
                                   
                               }.background(
                                   
                                   Color.black.opacity(0.55)
                                       .edgesIgnoringSafeArea(.all)
                                       .onTapGesture {
                                           
                                        self.cart.toggle()
                                   }
                               )
                        }
                    
                    
                        if self.pickup {
                   
                            NavigationLink(destination: pickUpScreen(pickup: self.$pickup,checkout: self.$checkout), isActive: self.$pickup) {
                                    Text("")
                                                              
                                }
                                .hidden()
                           
                        }
                    
                    }
                }
               
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: signUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

//orderView -> cardView -> Listt -> Carousel -> Mainscreen

// orderView -> button -> foodmenu

