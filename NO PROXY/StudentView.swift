//
//  StudentView.swift
//  NO PROXY
//
//  Created by Siddhartha on 11/8/17.
//  Copyright © 2017 Siddhartha Dhar Choudhury. All rights reserved.
//

import UIKit

class StudentView: UIViewController, UITextFieldDelegate {
    
    var regno = "0"
    var name = "nil"
    
    //Outlets for labels and text fields.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var regnoLabel: UILabel!
    @IBOutlet weak var subcodeTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    //Ends here.
    
    @IBAction func submitButton(_ sender: Any) {
        
        var errMsg : String = ""
        var error : Int = 0
        
        if(subcodeTextField.text != "" && otpTextField.text != "" && passwordTextField.text != "") {
            
            if((subcodeTextField.text?.count)! < 7) {
                
                errMsg += "\nInvalid Subject Code!"
                error += 1
                
            }
            
            if(!isValidOTP(value: otpTextField.text!)) {
                
                errMsg += "\nInvalid OTP!"
                error += 1
                
            }
            
            if(error > 0) {
                
                let alert = UIAlertController(title: "Error!!", message: errMsg, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let url1 = "http://frankhartpoems-com.stackstaging.com/testdata.php?regno="+regno+"&subcode="
                let url2 = subcodeTextField.text?.uppercased()
                let url3 = "&otp="+otpTextField.text!+"&pass="+passwordTextField.text!+"&log=2"
                
                let url = URL(string: url1+url2!+url3)!
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let attendance = jsonResult["attendance"] as? Int
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    if(attendance == 1) {
                                        
                                        errMsg = "Attendance marked successfully!"
                                        let alert = UIAlertController(title: "Success!!", message: errMsg, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        self.subcodeTextField.text = ""
                                        self.otpTextField.text = ""
                                        self.passwordTextField.text = ""
                                        self.teacherLabel.text = ""
                                        
                                    } else if(attendance == 2) {
                                        
                                        errMsg = "Wrong Password!"
                                        let alert = UIAlertController(title: "Error!!", message: errMsg, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else if(attendance == 3) {
                                        
                                        errMsg = "Wrong OTP!"
                                        let alert = UIAlertController(title: "Error!!", message: errMsg, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else if(attendance == 4) {
                                        
                                        errMsg = "Wrong OTP and Password!"
                                        let alert = UIAlertController(title: "Error!!", message: errMsg, preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else if(attendance == 5) {
                                        
                                        errMsg = "OTP has expired!"
                                        let alert = UIAlertController(title: "Error!!", message: errMsg, preferredStyle: .alert)
                                        
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
                
            }
            
        } else {
            
            let alert = UIAlertController(title: "Error!!", message: "Complete the form.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func isValidOTP(value: String) -> Bool {
        let PHONE_REGEX = "[0-9]{6}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        teacherLabel.text = ""
        regnoLabel.text = "Reg No: " + regno
        nameLabel.text = "Name: " + name
        
        self.subcodeTextField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.subcodeTextField.layer.borderWidth = CGFloat(Float(2.0))
        self.subcodeTextField.layer.cornerRadius = CGFloat(Float(10.0))
        self.otpTextField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.otpTextField.layer.borderWidth = CGFloat(Float(2.0))
        self.otpTextField.layer.cornerRadius = CGFloat(Float(10.0))
        self.passwordTextField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.passwordTextField.layer.borderWidth = CGFloat(Float(2.0))
        self.passwordTextField.layer.cornerRadius = CGFloat(Float(10.0))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == otpTextField) {
            
            let url1 = "http://frankhartpoems-com.stackstaging.com/testdata.php?regno="+regno+"&subcode="
            let url2 = subcodeTextField.text?.uppercased()
            let url3 = "&otp="+otpTextField.text!+"&pass=&log=2"
            
            let url = URL(string: url1+url2!+url3)!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            let tname = jsonResult["tname"] as? String
                            
                            DispatchQueue.main.sync(execute: {
                                
                                self.teacherLabel.text = tname
                                
                            })
                            
                        } catch {
                            
                            print("JSON Processing Failed")
                            
                        }
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
