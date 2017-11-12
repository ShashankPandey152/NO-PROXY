//
//  ViewController.swift
//  NO PROXY
//
//  Created by Siddhartha on 11/8/17.
//  Copyright © 2017 Siddhartha Dhar Choudhury. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Outlets.
    @IBOutlet weak var logEmail: UITextField!
    @IBOutlet weak var logPassword: UITextField!
    @IBOutlet weak var logSubmit: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    //Ends here.
    
    var errMessage : String = ""
    
    var id : String = ""
    var name: String = ""
    
    @IBAction func LoginSubmit(_ sender: Any) {
        
        if(logEmail.text != "" && logPassword.text != "") {
            
            if(isValidEmail(testStr: logEmail.text!)) {
                
                let url = URL(string: "http://frankhartpoems-com.stackstaging.com/testdata.php?email="+logEmail.text!+"&pass="+logPassword.text!+"&log=1")!
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let login = jsonResult["login"] as? Int
                                
                                let accountType = jsonResult["accountType"] as? Int
                                
                                self.id = (jsonResult["id"] as? String)!
                                
                                self.name = (jsonResult["name"] as? String)!
                            
                                var logged = 0
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    if(login == 0) {
                                        
                                        self.errMessage = "Account does not exist!"
                                        let alert = UIAlertController(title: "Error!!", message: self.errMessage, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else if(login == 1) {
                                        
                                        logged = 1
                                        
                                        self.errMessage = "Login successful!"
                                        let alert = UIAlertController(title: "Success!!", message: self.errMessage, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                                            
                                            if(logged == 1) {
                                                
                                                if(accountType == 1) {
                                                    
                                                    UserDefaults.standard.set(self.logEmail.text, forKey: "Email")
                                                    UserDefaults.standard.set(self.logPassword.text, forKey: "Password")
                                                    UserDefaults.standard.synchronize()
                                                    
                                                    self.performSegue(withIdentifier: "segue2", sender: nil)
                                                    
                                                } else if(accountType == 2) {
                                                    
                                                    UserDefaults.standard.set(self.logEmail.text, forKey: "Email")
                                                    UserDefaults.standard.set(self.logPassword.text, forKey: "Password")
                                                    UserDefaults.standard.synchronize()
                                                    
                                                    self.performSegue(withIdentifier: "segue1", sender: nil)
                                                    
                                                }
                                                
                                            }
                                            
                                        })
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else if(login == 2) {
                                        
                                        self.errMessage = "Wrong credentials!"
                                        let alert = UIAlertController(title: "Error!!", message: self.errMessage, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    
                                })
                                
                            } catch {
                                
                                print("JSON Processing Failed")
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                task.resume()
                
            } else {
                
                errMessage = "Invalid email address!"
                let alert = UIAlertController(title: "Error!!", message: errMessage, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        } else {
            
            let alert = UIAlertController(title: "Error!!", message: "Complete the form.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //Ends here.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segue2") {
            
            let studentViewController = segue.destination as! StudentView
            
            studentViewController.regno = id
            
            studentViewController.name = name
            
            
            
        } else if(segue.identifier == "segue1") {
            
            let teacherViewController = segue.destination as! TeacherView
            
            teacherViewController.tid = id
            
            teacherViewController.name = name
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.logEmail.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.logEmail.layer.borderWidth = CGFloat(Float(2.0))
        self.logEmail.layer.cornerRadius = CGFloat(Float(10.0))
        self.logPassword.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.logPassword.layer.borderWidth = CGFloat(Float(2.0))
        self.logPassword.layer.cornerRadius = CGFloat(Float(10.0))
        
        let emailObject = UserDefaults.standard.object(forKey: "Email")
        let passwordObject = UserDefaults.standard.object(forKey: "Password")
        
        if let email = emailObject as? String  {
            
            logEmail.text = email
            
        }
        
        if let password = passwordObject as? String {
            
            logPassword.text = password
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

}

