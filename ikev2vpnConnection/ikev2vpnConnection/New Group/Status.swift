//
//  ViewController.swift
//  ikev2vpnConnection
//
//  Created by jrs on 21/05/19.
//  Copyright © 2019 jyoti ranjan swain. All rights reserved.
//

import UIKit

enum Status: String {
    case connected
    case errorConnecting
    case disconnected
    case connecting
    case disconnecting
    
    var description: String {
        switch self {
        case .connected:
            return "connected"
        case .errorConnecting:
            return "Error connecting"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .disconnecting:
            return "Disconnecting"
        }
    }
}

