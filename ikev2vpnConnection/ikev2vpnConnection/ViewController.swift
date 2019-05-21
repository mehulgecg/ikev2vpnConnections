//
//  ViewController.swift
//  ikev2vpnConnection
//
//  Created by jrs on 21/05/19.
//  Copyright © 2019 jyoti ranjan swain. All rights reserved.
//

import UIKit
import NetworkExtension
class ViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    //Assigning vpn class
     let vpnInstance = Vpn()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         vpnInstance.vpnDelegate = self
        
    }
    //Will act as connect/Disconnect
    @IBAction func connectTrig(_ sender: Any) {
        vpnInstance.connectVPN()
    }
    
    //Updating connection status
    var status: Status? {
        didSet {
            statusLabel.text = status?.description
            if status == Status.connecting {
                statusLabel.text = "Connecting"
            } else if status == Status.disconnecting {
                statusLabel.text = "Disconnecting"
            } else if status == Status.connected {
                statusLabel.text = "Connected"
            } else if status == Status.disconnected {
                statusLabel.text = "Disconnected"
            } else if status == Status.errorConnecting {
                statusLabel.text = "Error connecting"
            }
            
        }
    }
        
        @objc private func checkNEStatus(status: NEVPNStatus) {
        switch status {
        case .invalid:
        self.status = Status.errorConnecting
        case .disconnected:
        self.status = Status.disconnected
        case .connecting:
        self.status = Status.connecting
        case .connected:
        self.status = Status.connected
        case .reasserting:
        print("NEVPNConnection: Reasserting")
        case .disconnecting:
        self.status = Status.disconnecting
        default:
            print("Unexpected Error")
        }
        }
        
    }
    
    

extension ViewController: VpnDelegate {
    func setStatus(status: Status) {
        self.status = status
    }
    func checkNES(status: NEVPNStatus){
        self.checkNEStatus(status: status)
    }
}

