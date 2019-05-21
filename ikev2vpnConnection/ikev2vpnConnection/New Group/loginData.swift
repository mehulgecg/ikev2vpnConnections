//
//  ViewController.swift
//  ikev2vpnConnection
//
//  Created by jrs on 21/05/19.
//  Copyright © 2019 jyoti ranjan swain. All rights reserved.
//

import Foundation

class Config {
    let certificate : String
    let serverAddress : String
    init(certificateData : String, serverAddressData : String ) {
        certificate = certificateData
        serverAddress = serverAddressData
    }
}
class LoginData {
    var data = [Config]()
    init() {
        //You can directly put this values in vpn class if you have few locations. but if you have mulitple locations then maitaining a different class will be usefull
        data.append(Config(certificateData: "Replace this with your certificate", serverAddressData: "Your Server id"))
    }
}

