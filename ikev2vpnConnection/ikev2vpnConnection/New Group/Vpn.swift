//
//  ViewController.swift
//  ikev2vpnConnection
//
//  Created by jrs on 21/05/19.
//  Copyright © 2019 jyoti ranjan swain. All rights reserved.
//

import Foundation
import NetworkExtension
protocol VpnDelegate: class {
    func setStatus(status: Status)
    func checkNES(status: NEVPNStatus)
}
class Vpn {
    
    let vpnManager = NEVPNManager.shared();
    let vpnData = LoginData()
    weak var vpnDelegate: VpnDelegate?
    
    //Loading VPN Configuration
    var vpnLoadHandler: (Error?) -> Void { return
    { (error:Error?) in
        if ((error) != nil) {
            self.vpnDelegate?.setStatus(status: Status.errorConnecting)
            print("Could not load VPN Configurations")
            return;
        }
        let p = NEVPNProtocolIKEv2()
        p.authenticationMethod = NEVPNIKEAuthenticationMethod.none
        p.useExtendedAuthentication = true
        p.serverAddress = self.vpnData.data[0].serverAddress //replace it with your server address
        p.remoteIdentifier = self.vpnData.data[0].serverAddress //replace it with your remote id
        p.disconnectOnSleep = false
        
        let cert = self.vpnData.data[0].certificate  //Assign your certificate string to cert
        let tmpData = Data(base64Encoded: cert)!
        let certificate = SecCertificateCreateWithData(nil, tmpData as CFData)!
        let certificateData = SecCertificateCopyData(certificate) as Data
        
        p.identityData = certificateData
        let kcs = KeychainService()
        kcs.save(key: "VPN_PASSWORD", value: "your_password") //Add your password
        p.username = "user" //add your user name
        p.passwordReference = kcs.load(key: "VPN_PASSWORD")
        self.vpnManager.protocolConfiguration = p
        self.vpnManager.localizedDescription = "user"
        self.vpnManager.isEnabled = true
        self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        }
    }
    
    
    private var vpnSaveHandler: (Error?) -> Void { return
    { (error:Error?) in
        if (error != nil) {
            print("Could not save VPN Configurations")
            return
        } else {
            do {
                try self.vpnManager.connection.startVPNTunnel()
            } catch let error {
                print("Error starting VPN Connection \(error.localizedDescription)");
            }
        }
        }
    }
    
    
    public func connectVPN() {
        self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil , queue: nil) {
            notification in
            let nevpnconn = notification.object as! NEVPNConnection
            let status = nevpnconn.status
            self.vpnDelegate?.checkNES(status: status)
        }
    }
    public func disconnectVPN() -> Void {
        vpnManager.connection.stopVPNTunnel()
    }
}
