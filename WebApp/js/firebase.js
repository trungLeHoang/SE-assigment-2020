// Your web app's Firebase configuration
var firebaseConfig = {
    apiKey: "AIzaSyA7NyJDybYfTazOdhpdY6gFMTRALN0-6To",
    authDomain: "sfcs-f6a3c.firebaseapp.com",
    databaseURL: "https://sfcs-f6a3c.firebaseio.com",
    projectId: "sfcs-f6a3c",
    storageBucket: "sfcs-f6a3c.appspot.com",
    messagingSenderId: "1083895554233",
    appId: "1:1083895554233:web:7da97c90fd62304d9ffb68",
    measurementId: "G-0KCMX9EH26"
};
// Initialize Firebase
if (!firebase.apps.length) {
firebase.initializeApp(firebaseConfig);
}
firebase.analytics();
async function sendOrder(){
    let productNumbers = localStorage.getItem('cartNumbers');
    if (productNumbers == null || parseInt(productNumbers) == 0){
        alert("You must have at least 1 product in Cart!");
    }
    else{
        var today = new Date();
        var date = "";
        switch(today.getMonth() + 1){
            case 1: 
                date += "Jan "; break;
            case 2:
                date += "Feb "; break;
            case 3:
                date += "Mar "; break;
            case 4:
                date += "Apr "; break;
            case 5:
                date += "May "; break;
            case 6:
                date += "Jun "; break;
            case 7:
                date += "Jul "; break;
            case 8:
                date += "Aug "; break;
            case 9:
                date += "Sep "; break;
            case 10:
                date += "Oct "; break;
            case 11:
                date += "Nov "; break;
            case 12:
                date += "Dec "; break;                           
        }
        date += today.getDate() + ", " + today.getFullYear() + " at ";
        if (today.getHours() >= 0 && today.getHours() <= 12) date += today.getHours();
        else date += (today.getHours() - 12).toString();
        date += ":" + today.getMinutes() + ":" + today.getSeconds();
        
        if (today.getHours() <= 11) date += " AM";
        else date += " PM";

        let cartItems = localStorage.getItem("productsInCart");
        cartItems = JSON.parse(cartItems);
        var order = [];
        var nOrderRef = firebase.database().ref('nOrder/');
        var n = -1, orderID = -1;
        var snapshot = await nOrderRef.once('value');
        if(snapshot.exists()) {
            var Data = snapshot.val();
            n = Data.nOrder + 1;
            orderID = Data.orderID + 1;
            Object.assign(order, {ID: orderID});
        }
        firebase.database().ref('nOrder/').set(
            {
                nOrder: n,
                orderID: orderID
            });
        Object.assign(order, {isDone: false});
        var itemListi = [];
        for (var i = 0; i < Object.keys(cartItems).length; i++){
            var item = [];
            Object.assign(item, {name:cartItems[Object.keys(cartItems)[i]].name});
            Object.assign(item, {price:cartItems[Object.keys(cartItems)[i]].price});
            Object.assign(item, {quantity:cartItems[Object.keys(cartItems)[i]].inCart});
            itemListi.push(item);
        }
        Object.assign(order, {itemList: itemListi});
        Object.assign(order, {paymentType: "Cash"});
        Object.assign(order, {userID: ""});
        Object.assign(order, {date: date});
        Object.assign(order, {pickuptime: ""});
        Object.assign(order, {status: "waiting"});
        console.log("n = " + n + ", ID = ", orderID);
        firebase.database().ref('orderList/' + n).set(order);
        alert("Thank you for choosing our products! \nYour order is now being processed.(´・ω・`)")
        localStorage.clear();
        location.reload();
    }
    
}