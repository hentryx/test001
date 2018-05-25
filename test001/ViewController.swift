//
//  ViewController.swift
//  test001. prueba técnica para domicilios.com
//
//  Creado por Henry Bautista on 22/05/18.
//  Copyright © 2018 Henry Bautista. Derechos reservados.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    
    @IBOutlet weak var mainLogoXConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonXConstraint: NSLayoutConstraint!
    var animationPerformOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainLogoXConstraint.constant -= view.bounds.width
        loginButtonXConstraint.constant -= view.bounds.width
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!animationPerformOnce){
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.mainLogoXConstraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                self.loginButtonXConstraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            animationPerformOnce = true;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func butAction(_ sender: Any) {
        beginFaceID()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    func beginFaceID() {
        
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            
            if let laError = error {
                print("laError - \(laError)")
                return
            }
            
            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                switch laContext.biometryType {
                case .faceID: localizedReason = "Unlock using Face ID"; print("FaceId support")
                case .touchID: localizedReason = "Unlock using Touch ID"; print("TouchId support")
                case .none: print("No Biometric support")
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            let alertController = UIAlertController(title: "HB Map Test App", message:
                                "Bienvenido !", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default,handler: self.theAlertHandler))
                            
                            self.present(alertController, animated: true, completion: nil)
                            print("Exitoso")
                            
                        }                     }
                    
                })
            })
        }
        
    }
    func theAlertHandler(alert: UIAlertAction!){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "theSecondView")
        self.present(newViewController, animated: true, completion: nil)
    }


}

