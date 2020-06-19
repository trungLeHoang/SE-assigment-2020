import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import SDWebImageSwiftUI


var OrderID = 618001

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
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
                if self.status{
                    Mainscreen(cart: self.$cart, account: self.$account)
                    if self.account {
                        NavigationLink(destination: AccountScreen(account: self.$account), isActive: self.$account) {
                            
                            Text("")
                        }
                        .hidden()
                    }
                    
                    else if self.cart {
                        
                       GeometryReader{_ in
                           
                           CartView()
                           
                       }.background(
                           
                           Color.black.opacity(0.55)
                               .edgesIgnoringSafeArea(.all)
                               .onTapGesture {
                                   
                                   self.cart.toggle()
                           }
                       
                       
                       )
                    }
                    
            
                }
               
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
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

struct AccountScreen : View {
    
    
    @Binding var account : Bool
    var body: some View {
    
         ZStack{
                   
                ZStack(alignment: .topLeading) {
                       
                    GeometryReader{_ in
                           
                        VStack{
                                Text("This is account manager screen")
                            
                            Button(action: {
                                
                                self.account.toggle()
                                
                            }) {
                                
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(Color("Color"))
                            }
                            .padding()
        
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Mainscreen : View {
    @Binding var cart : Bool
    @Binding var account : Bool
        @State var menu = 0
        @State var page = 0
    
    @State var nOrder = getNumberOfOrder()
            
        var body: some View{
            
            
          ZStack {
                    
                    Color("Color").edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        
                        ZStack{
                            
                            HStack (spacing: 10) {
                                
                                Button(action: {
                                    self.cart.toggle()
                                 }) {
                                     
                                     Image("market")
                                         .renderingMode(.original)
                                     .resizable()
                                         .frame(width:35 , height:35)
                                        .padding()
                                         
                                 }
                                .background(Color.white)
                                .cornerRadius(25)
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    try! Auth.auth().signOut()
                                    UserDefaults.standard.set(false, forKey: "status")
                                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                }) {
                                    
                                    Image("log-off")
                                        .renderingMode(.original)
                                    .resizable()
                                        .frame(width:35 , height:35)
                                        .padding()
                                    
                                }
                                .background(Color.white)
                                .cornerRadius(25)
                              
                                
                                Button(action: {
                                    self.account.toggle()
                                    self.nOrderCheck()
                                 }) {
                                     
                                     Image("person")
                                         .renderingMode(.original)
                                     .resizable()
                                         .frame(width:35 , height:35)
                                    .padding()
                                         
                                 }
                                .background(Color.white)
                                .cornerRadius(25)
                              
                            }
                            .padding(.horizontal)
                            
                            Text("Menu")
                                .font(.system(size: 22))
                        }
                        
                        
                        GeometryReader{g in
                            
                            // Simple Carousel List....
                            // Using GeomtryReader For Getting Remaining Height...
                            
                            Carousel(width: UIScreen.main.bounds.width, page: self.$page, menu: self.$menu, height: g.frame(in: .global).height)
                        }
                        
                        
                        PageControl(menu: self.$menu, page: self.$page)
                        .padding(.top, 20)
                                            
                        
                        
                    }
                    .padding(.vertical)
                }
            }

    func nOrderCheck() {
        
        print("check start")
        print(self.nOrder.nOrder)
        print("Int")
        print(OrderID)
        print("String")
        print(String(OrderID))
        print("check end")
        
    }
}
    
struct Login : View {
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
            
            ZStack(alignment: .topTrailing) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        Image("logo")
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
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
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.reset()
                                
                            }) {
                                
                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                            }
                        }
                        .padding(.top, 20)
                        
                        Button(action: {
                            
                            self.verify()
                            
                        }) {
                            
                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        HStack(spacing:  15) {
                            
                            Rectangle()
                                .frame(width:80,height: 2)
                                .background(Color.black.opacity(0.7))
                            
                            Text("by another account")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.7))
                            
                            Rectangle()
                            .frame(width:80,height: 2)
                            .background(Color.black.opacity(0.7))
                            
                        }
                        .padding(.top)
                        
                        HStack(spacing: 20){
                            
                            Button(action: {
                                GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
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
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.7))
                            
                            Button(action: {
                                self.show.toggle()
                            }){
                                
                               Text("Register here")
                                .fontWeight(.bold)
                                .foregroundColor(Color("Color"))
                                
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    
                }
                
                
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    
    }
    
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
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

struct SignUp : View {
    
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
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        Image("Signup-logo")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 200, height:  200)
                            
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
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
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
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
                        .background(RoundedRectangle(cornerRadius: 10).stroke(self.repass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            
                            self.register()
                        }) {
                            
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
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
                        .foregroundColor(Color("Color"))
                }
                .padding()
            }
            
            if self.alert{
                
                    ErrorView(alert: self.$alert, error: self.$error)
                    
            
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

struct ErrorView : View {
    
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
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

struct PageControl : UIViewRepresentable {
    
    @Binding var menu : Int
    @Binding var page : Int
    
    func makeUIView(context: Context) -> UIPageControl {
        
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        
        view.numberOfPages = data.count
        
        
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        
        // Updating Page Indicator When Ever Page Changes....
        
        DispatchQueue.main.async {
            print(self.page)
            uiView.currentPage = self.page
        }
    }
}

struct Listt : View {
    @EnvironmentObject var categories : getCategoriesData

    @Binding var page : Int
    @Binding var menu : Int
    
    var body: some View{
        
        HStack(spacing: 0){
            
            
                ForEach(data){i in
                    // Mistakenly Used Geomtry Reader...
                    
                    Card(page: self.$page, width: UIScreen.main.bounds.width, data: i)
                }
            }
            
        }
    }

struct Card : View {
    
    @Binding var page : Int
    var width : CGFloat
    var data : Type
    @State var show = false
    
    var body: some View{
        
        VStack{
            
            VStack {
                
                Text(self.data.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top,20)
                
                Text(self.data.cName)
                    .foregroundColor(.gray)
                    .padding(.vertical)
                
                Spacer(minLength: 0)
                
                Image(self.data.image)
                .resizable()
                .frame(width: self.width - (self.page == self.data.id ? 100 : 150), height: (self.page == self.data.id ? 250 : 200))
                    .cornerRadius(20)
                
                Text(self.data.price)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 20)
                
                Button(action: {
                   self.show.toggle()
                    
                }) {
                    
                    Text("Add to cart+")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                }
                .background(Color("Color"))
                .clipShape(Capsule())
                .padding(.top, 20)
                
                
                Spacer(minLength: 0)
                
                // For Filling Empty Space....
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.top, 25)
            .padding(.vertical, self.page == data.id ? 0 : 25)
            .padding(.horizontal, self.page == data.id ? 0 : 25)
            
            // Increasing Height And Width If Currnet Page Appears...
        }
        .frame(width: self.width)
        .animation(.default)
        .sheet(isPresented: self.$show) {
                       
            OrderView(data: self.data,show: self.$show)
               }
    }
}

struct Carousel : UIViewRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        
        return Carousel.Coordinator(parent1: self)
    }
    
    var width : CGFloat
    @Binding var page : Int
    @Binding var menu : Int
    var height : CGFloat
    
    func makeUIView(context: Context) -> UIScrollView{
        
        // ScrollView Content Size...
        
        
       
            
            let total = width * CGFloat(data.count)
            let view = UIScrollView()
            view.isPagingEnabled = true
            //1.0  For Disabling Vertical Scroll....
            view.contentSize = CGSize(width: total, height: 1.0)
            view.bounces = true
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            view.delegate = context.coordinator
            
            let view1 = UIHostingController(rootView: Listt(page: self.$page, menu: self.$menu))
            view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
            view1.view.backgroundColor = .clear
            
            view.addSubview(view1.view)
            
           return view
        
        
        // Now Going to  embed swiftUI View Into UIView...
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        
        
        var parent : Carousel
        
        init(parent1: Carousel) {
            
        
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            // Using This Function For Getting Currnet Page
            // Follow Me...
            
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            
            self.parent.page = page
        }
    }
}
 

                


//Part cart


struct Loader : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
        
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {
        
        
    }
}

struct OrderView : View {
    
    var data : Type
    @State var cash = false
    @State var quick = false
    @State var quantity = 0
    @Binding var show : Bool

    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        VStack( spacing: 15){
            
           
            
                Image(self.data.image)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .padding()
                                .offset(x: 0,y: 0)
            
            
            
            VStack(alignment: .leading, spacing: 25) {
                
                Text(data.name).fontWeight(.heavy).font(.title)
                Text(data.price).fontWeight(.heavy).font(.body)
                
                Toggle(isOn : $cash){
                    
                    Text("Cash On Delivery")
                }
                
                Toggle(isOn : $quick){
                    
                    Text("Quick Delivery")
                }
                
                Stepper(onIncrement: {
                    
                    self.quantity += 1
                    
                }, onDecrement: {
                
                    if self.quantity != 0{
                        
                        self.quantity -= 1
                    }
                }) {
                    
                    Text("Quantity \(self.quantity)")
                }
                
                Button(action: {
                    
                    if self.quantity >= 1 {
                        let db = Firestore.firestore()
                        db.collection(String(OrderID))
                            .document()
                            .setData(["item":self.data.name,"quantity":self.quantity,"quickdelivery":self.quick,"cashondelivery":self.cash,"pic":self.data.image]) { (err) in
                                
                                if err != nil{
                                    
                                    print((err?.localizedDescription)!)
                                    return
                                }
                                
                                // it will dismiss the recently presented modal....
                                
                                self.presentation.wrappedValue.dismiss()
                            }
                    }
                        self.show.toggle()
                    
                    
                    
                }) {
                    
                    Text("Add To Cart")
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                    
                }.background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(20)
                
            }.padding()
            
            Spacer()
        }
    }
}

struct CartView : View {
    
    @ObservedObject var cartdata = getCartData()
    
    var body : some View{
        
        VStack {
            
           
                Text(self.cartdata.datas.count != 0 ? "Your cart" : "No Items In Cart")
                    .padding([.top,.leading])
           
            
            
            if self.cartdata.datas.count != 0{
                
                List {
                    
                    ForEach(self.cartdata.datas){i in
                        
                        HStack(spacing: 15){
                            
                            Image(i.pic)
                                .resizable()
                                .frame(width: 55, height: 55)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading){
                                
                                Text(i.name)
                                Text("\(i.quantity)")
                            }
                        }
                        .onTapGesture {
                            
                            UIApplication.shared.windows.last?.rootViewController?.present(textFieldAlertView(id: i.id), animated: true, completion: nil)
                        }
                        
                    }
                    .onDelete { (index) in
                        
                        let db = Firestore.firestore()
                        db.collection("cart").document(self.cartdata.datas[index.last!].id).delete { (err) in
                            
                            if err != nil{
                                
                                print((err?.localizedDescription)!)
                                return
                            }
                            
                            self.cartdata.datas.remove(atOffsets: index)
                        }
                    }
                    
                }
                
               
                Button(action:   {
                    OrderID += 1
                    
                }) {
                                   
                                   Text("Pay your order")
                                       .foregroundColor(.white)
                                       .padding(.vertical)
                                       .frame(width: 200)
                               }
                               .background(Color("Color"))
                               .cornerRadius(10)
                               .padding(.top)
                
            }
            

            
        }.frame(width: UIScreen.main.bounds.width - 110, height: UIScreen.main.bounds.height - 350)
       .background(Color("Color"))
        .cornerRadius(25)
    }
}

func textFieldAlertView(id: String)->UIAlertController{
    
    let alert = UIAlertController(title: "Update", message: "Enter The Quantity", preferredStyle: .alert)
    
    alert.addTextField { (txt) in
        
        txt.placeholder = "Quantity"
        txt.keyboardType = .numberPad
    }
    
    let update = UIAlertAction(title: "Update", style: .default) { (_) in
        
        let db = Firestore.firestore()
        
        let value = alert.textFields![0].text!
            
        db.collection("cart").document(id).updateData(["quantity":Int(value)!]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alert.addAction(cancel)
    
    alert.addAction(update)
    
    return alert
}


//Data

class getCartData : ObservableObject{
    
    @Published var datas = [cart]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection(String(OrderID)).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let name = i.document.get("item") as! String
                    let quantity = i.document.get("quantity") as! NSNumber
                    let pic = i.document.get("pic") as! String

                    self.datas.append(cart(id: id, name: name, quantity: quantity, pic: pic))
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let quantity = i.document.get("quantity") as! NSNumber
                    
                    for j in 0..<self.datas.count{
                        
                        if self.datas[j].id == id{
                            
                            self.datas[j].quantity = quantity
                        }
                    }
                }
            }
        }
    }
}

class getCategoriesData : ObservableObject{
    
    @Published var datas = [TypeCatogory]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection(String(OrderID)).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
               
                let id = i.document.documentID
                let name = i.document.get("name") as! String
                let cName = i.document.get("cName") as! String
                let price = i.document.get("price") as! String
                let image = i.document.get("image") as! String
                
                self.datas.append(TypeCatogory(id: id, name: name,cName: cName, price: price, image: image))
            }
        }
    }
}

class getNumberOfOrder : ObservableObject {
    
    @Published var nOrder = [number]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("Number of Order").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                let n = i.document.get("number") as! Int
              
                self.nOrder.append(number(nOrder: n))
            
            }
        }
    }
    
    
}
struct number  {
    
    var nOrder : Int
}

struct Type : Identifiable{
        var id : Int
          var name : String
          var cName : String
          var price : String
          var image : String
}

struct TypeCatogory: Identifiable {
    
    var id : String
    var name : String
    var cName : String
    var price : String
    var image : String
}

struct cart : Identifiable {
    
    var id : String
    var name : String
    var quantity : NSNumber
    var pic : String
}

var  data = [
    
    Type(id: 0, name: "White Rice", cName: "meal", price: "20.000 VNĐ",image: "rice"),
    
    Type(id: 1, name: "Fired Potatoe", cName: "extra", price: "20.000 VNĐ",image: "friedpotato"),
      
      Type(id: 2, name: "France Flan", cName: "dessert", price: "25.000 VNĐ",image: "dessert"),

    Type(id: 3, name: "Fresh Milk", cName: "drink", price: "20.000 VNĐ",image: "milk"),
    
    Type(id: 4, name: "Coffee", cName: "drink", price: "30.000 VNĐ",image: "coffee"),
    
    Type(id: 5, name: "Green tea", cName: "drink", price: "10.000 VNĐ",image: "greentea"),
    
    Type(id: 6, name: "Bubble milk tea", cName: "drink" , price: "45.000 VNĐ",image: "milktea"),
    
    
]



