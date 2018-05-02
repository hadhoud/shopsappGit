

import UIKit

class Res_data : Codable {
    
    let status : String?
    let message : String?
    let auth_token : String?
    let user_infos : [userinfo]?
    let shops : [userinfo]?
    let user : [userinfo]?
   let advertisements : [ads]?
    let categories : [category]?
    
    init(status: String, message : String ,auth_token : String ,user_infos : [userinfo],user : [userinfo], shops : [userinfo],advertisements : [ads],categories : [category]) {
        self.status = status
        self.message = message
        self.auth_token = auth_token
        self.user_infos = user_infos
        self.user = user_infos
        self.shops = shops
        self.advertisements = advertisements
        self.categories = categories
    }
    
}


class ads :Codable {
    let id :Int?
    let description : String?
    let name : String?
    let image : String?
    let link : String?
    let sequence : Int?
    let timer : Int?
    let startDate : String?
    let endDate : String?
    let modiefiedDate : String?
    let user : user?
    init(id : Int , description:String ,name : String ,image : String,link : String,sequence : Int,timer : Int,startDate : String,endDate : String,modiefiedDate : String,user : user) {
     self.id = id
        self.description = description
        self.name = name
        self.image = image
        self.link = link
        self.sequence = sequence
        self.timer = timer
        self.startDate = startDate
        self.endDate = endDate
        self.modiefiedDate = modiefiedDate
        self.user = user
    }
    
}
class user : Codable {
    let id: Int?
    let username : String?
    init(id : Int , username : String) {
       self.id = id
        self.username = username
    }
}
class category: Codable {
    
    let id : Int?
    let description : String?
    let isApproved : Int?
    let name : String?
    let lstProducts : [product]?
    init(id : Int, description : String , isApproved : Int, name : String , lstProducts : [product]) {
        self.id = id
        self.description = description
        self.name = name
        self.isApproved = isApproved
        self.lstProducts = lstProducts
    }
    
}

class product: Codable {
    var id :Int?
    let title : String?
    let logo : String?
    let description : String?
    let price : String?
    init(id : Int , title : String , logo :String , description : String , price : String) {
        self.id = id
        self.title = title
        self.description = description
        self.logo = logo
        self.price = price
    }
}

class userinfo : Codable {
    
    let id : Int?
    let authToken : String?
    let googleToken : String?
    let shopName : String?
    let generalDescription : String?
    let isApproved : Int?
    let isDeleted : Int?
    let isRejected : Int?
    let logo : String?
    let latitude : Double?
    let longitude : Double?
    let phone : String?
    let mobile : String?
    let whatsapp: String?
    let email : String?
    let website : String?
    let address : String?
    let username : String?
    let passwd : String?
    let lstCategories : [category]?
    init(id : Int ,authToken : String,googleToken : String,shopName : String,generalDescription : String,isApproved : Int,isDeleted : Int,isRejected : Int,logo : String,latitude : Double,longitude : Double,phone : String,mobile : String,whatsapp: String,email : String,website : String,address : String,username : String,passwd : String,lstCategories : [category]) {
        self.id = id
        self.authToken = authToken
        self.googleToken = googleToken
        self.shopName = shopName
        self.generalDescription = generalDescription
        self.isApproved = isApproved
        self.isDeleted = isDeleted
        self.isRejected = isRejected
        self.logo = logo
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.mobile = mobile
        self.whatsapp = whatsapp
        self.email = email
        self.website = website
        self.address = address
        self.username = username
        self.passwd = passwd
        self.lstCategories = lstCategories
    }
}

///*************************  registration classes*******************

class registration: Codable {
    
    let shopname : String?
    let description : String?
    let logo : [Int8]?
    let latitude : Double?
    let longitude : Double?
    let username: String?
    let password : String?
    let phone : String?
    let mobile : String?
    let whatsapp: String?
    let email : String?
    let website : String?
    let address : String?
    let googleToken : String?
    let categories : [categories]?
    
    init(shopname : String , description :String , logo : [Int8], latitude : Double, longitude : Double,username: String ,password : String ,phone : String , mobile : String , whatsapp : String , email : String , website : String , address : String , googletoken : String , categories : [categories]) {
        self.shopname = shopname
        self.description = description
        self.logo = logo
        self.latitude = latitude
        self.longitude = longitude
        self.username = username
        self.password = password
        self.phone = phone
        self.mobile = mobile
        self.whatsapp = whatsapp
        self.email = email
        self.website = website
        self.address = address
        self.googleToken = googletoken
        self.categories = categories
        
    }
}
class categories : Codable {

    var name : String?
    var products : [products]?
    init(name : String ,products : [products]? = nil) {
        self.name = name
        self.products = products ?? []
    }
}
class products : Codable{
    
    var title : String?
    var logo : [Int8]?
    var description : String?
    var price : Int?
    init( title:String, logo: [Int8], description:String, price:Int) {
        self.title = title
        self.logo = logo
        self.description = description
        self.price = price
    }
}
class category_save: Codable {
    
    let auth_token : String?
    let name : String?
    let products : [products]?
    init(auth_token : String , name : String , products : [products]) {
       self.auth_token = auth_token
        self.name = name
        self.products = products
    }
    
}

// used in signup add product
class productme {
    var title: String
    var id: Int
    var price: String
    var description: String
    var img: UIImage
    init?(id:Int , title: String,price: String,img: UIImage , description: String)
    {
        self.title = title
        self.price = price
        self.id = id
        self.img = img
        self.description = description
    }
}
    class product_save : Codable {
        let auth_token : String?
        var id: String?
        var title : String?
        var logo : [Int8]?
        var description : String?
        var price : Int?
        var categoryName: String?
        init(auth_token: String , id: String , title: String, logo: [Int8], description:String, price:Int , categoryName: String) {
            self.id = id
            self.title = title
            self.logo = logo
            self.description = description
            self.price = price
            self.categoryName = categoryName
            self.auth_token = auth_token
        }
        
    }



