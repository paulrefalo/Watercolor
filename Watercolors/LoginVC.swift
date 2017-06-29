//
//  LoginVC.swift
//  Watercolors
//
//  Created by Paul ReFalo on 6/3/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if (FBSDKAccessToken.current() != nil) {
            self.dismiss(animated: true, completion: nil)
        } else {
            presentInitialVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "watercolor background")!)
        coverView.alpha = 0
        
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is currently logged in with FB")
            print("Logged in as: ", FBSDKAccessToken.current().userID)
            
            // page setup when logged in.  Set: welcome/hello text, toggle skip/cancel button
            if let firstName = UserDefaults.standard.string(forKey: "userFirstName") {
                topLabel.text = "Hi, \(firstName)!"
            }
        } else {
            emitter()  // start emitter
        }
        
        reconfigurePage()

        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]

        loginButton.frame = CGRect(x: 16, y: 200, width: view.frame.width - 32, height: 50)

        view.addSubview(loginButton)
        

        loginButton.delegate = self
        
    }
    
    func reconfigurePage() {
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in with FB
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Jiji")!)
            coverView.alpha = 0.7
            cancelButton.setTitle("Cancel", for: .normal)
        } else {
            // User NOT logged in
            topLabel.text = "Welcome!"
            view.backgroundColor = UIColor(patternImage: UIImage(named: "watercolor background")!)
            coverView.alpha = 0
            cancelButton.setTitle("Skip", for: .normal)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
        reconfigurePage()
        presentInitialVC()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("*** Logged in as: ", FBSDKAccessToken.current().userID)

            presentInitialVC()
            
            // Firebase Login
            self.firebaseLogin()

        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err as Any)
                return
            } else {
                print(result as Any)
                let fbDetails = result as! NSDictionary
                print(fbDetails)
                if let name: String = fbDetails["name"] as? String {
                    
                    let fullNameArray = name.components(separatedBy: " ")
                    
                    let firstName = fullNameArray[0]
                    let surname = fullNameArray[1]
                    
                    UserDefaults.standard.set(name, forKey: "fullUserName")
                    UserDefaults.standard.set(firstName, forKey: "userFirstName")
                    UserDefaults.standard.set(surname, forKey: "userSurname")
                    
                    print("*** First is:", firstName)
                    print("*** Surname is:", surname)
                    
                    self.topLabel.text = "Hi, \(firstName)!"

                }
                if let id: String = fbDetails["id"] as? String {
                    print("*** Id is:  ", id)
                    UserDefaults.standard.set(id, forKey: "userID")
                }
                if let email: String = fbDetails["email"] as? String {
                    print("*** Email is:  ", email)
                    UserDefaults.standard.set(email, forKey: "userEmail")
                }
                
//                for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//                    print("\(key) = \(value) \n")
//                }
            }
        }
    }
    
    func presentInitialVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }

    
    func firebaseLogin() {
        
        if let accessTokenString = FBSDKAccessToken.current().tokenString {
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                if error != nil {
                    print("!!!!!!! Error on Firebase Login")
                    return
                } else {
                    print("******* Successful Firebase Login as: ", user as Any)
                }
            })
            
        }
        
    }
    
    func emitter() {
        let emitter = Emitter.get(image: #imageLiteral(resourceName: "canvas"))
        emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 2.0)
        view.layer.addSublayer(emitter)
    }
    


}
