//
//  TeacherView.swift
//  NO PROXY
//
//  Created by Siddhartha on 11/8/17.
//  Copyright © 2017 Siddhartha Dhar Choudhury. All rights reserved.
//

import UIKit

class TeacherView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var errMessage : String = ""
    
    var course : [String] = Array()
    
    var subcode : [String] = Array()
    
    var batch : [String] = Array()
    
    var slot : [String] = Array()
    
    var hour : [String] = Array()
    
    var tid = "0"
    
    var name = ""
    
    //Outlets.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tidLabel: UILabel!
    @IBOutlet weak var doTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var slotHourTextField: UITextField!
    @IBOutlet weak var table1: UITableView!
    @IBOutlet weak var table2: UITableView!
    @IBOutlet weak var otpLabel: UILabel!
    //Ends here.
    
    //Action to generate OTP.
    
    @IBAction func refreshOTP(_ sender: Any) {
        
        otpLabel.text = ""
        
    }
    
    @IBAction func generateOTP(_ sender: Any) {
        
        if(doTextField.text != "" && courseTextField.text != "" && slotHourTextField.text != "") {
            
            let course = courseTextField.text
            let courseArr = course?.components(separatedBy: " ")
            let subjectCode = courseArr![1]
            let batch = courseArr![2]
            let Slot = slotHourTextField.text
            let slotArr = Slot?.components(separatedBy: " ")
            let slot = slotArr![0]
           
            let url1 = "http://frankhartpoems-com.stackstaging.com/testdata.php?tid="+tid
            
            let url2 = "&batch="+batch+"&slot="+slot
            
            let url3 = "&subcode="+subjectCode+"&log=4"
            
            let url = URL(string: url1+url2+url3)!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            let status = jsonResult["otpgen"] as? Int
                            
                            let otp = jsonResult["normalOTP"] as? Int
                            
                            DispatchQueue.main.sync(execute: {
                                
                                if(status == 0) {
                                    
                                    let alert = UIAlertController(title: "Error!!", message: "Same OTP exists generate again!", preferredStyle: .alert)
                                    
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    
                                    alert.addAction(ok)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                } else {
                                    
                                    let alert = UIAlertController(title: "Success!!", message: "OTP generated successfully!", preferredStyle: .alert)
                                    
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    
                                    alert.addAction(ok)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    self.doTextField.text = ""
                                    self.courseTextField.text = ""
                                    self.slotHourTextField.text = ""
                                    self.otpLabel.text = String(describing: otp!)
                                    
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
            
            let alert = UIAlertController(title: "Error!!", message: "Complete the form!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    //Ends here.
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == doTextField) {
            
            var dorder = 0;
            
            if(doTextField.text != "") {
                
                dorder = Int(doTextField.text!)!
                
            }
            if(dorder == 0) {
                
                let alert = UIAlertController(title: "Error!!", message: "Enter day order first!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else if(dorder < 1 || dorder > 5) {
                
                let alert = UIAlertController(title: "Error!!", message: "Invalid Day Order!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let url = URL(string: "http://frankhartpoems-com.stackstaging.com/testdata.php?tid="+tid+"&do="+doTextField.text!+"&log=3")!
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                self.course = (jsonResult["course"] as? [String])!
                                
                                self.subcode = (jsonResult["subcode"] as? [String])!
                                
                                self.batch = (jsonResult["batch"] as? [String])!
                                
                                self.slot = (jsonResult["slot"] as? [String])!
                                
                                self.hour = (jsonResult["hour"] as? [String])!
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    self.table1.reloadData()
                                    self.table2.reloadData()
                                    
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
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == doTextField) {
            
            table1.isHidden = true
            table2.isHidden = true
            
        }else if(textField == courseTextField) {
            
            table1.isHidden = false
            table2.isHidden = true
            
        } else if(textField == slotHourTextField) {
            
            table2.isHidden = false
            table1.isHidden = true
            
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int = 0
        
        if(tableView == table1) {
            
            count = course.count
            
        } else if(tableView == table2) {
            
            count = slot.count
            
        }
        
        return count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == table1) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell")
            cell!.textLabel!.text = course[indexPath.row] + ", Batch: " + batch[indexPath.row]
            
        } else if(tableView == table2) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell1")
            cell!.textLabel!.text = "Slot: " + slot[indexPath.row] + ", Hour: " + hour[indexPath.row]
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == table1) {
            
            courseTextField.text = course[indexPath.row] + " " + subcode[indexPath.row] + " " + batch[indexPath.row]
            table1.isHidden = true
            
        } else if(tableView == table2) {
            
            slotHourTextField.text = slot[indexPath.row] + " " + hour[indexPath.row]
            table2.isHidden = true
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = name
        tidLabel.text = tid
        
        otpLabel.text = ""
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
