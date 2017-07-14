//
//  ViewController.swift
//  LaraCrypt
//
//  Created by Fardad Co
//  Copyright © 2017 Fardad Co. All rights reserved.
//

import UIKit
import LaraCrypt

class ViewController: UIViewController {

    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var keyTextView: UITextView!
    @IBOutlet var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func encryptionButtonClicked(_ sender: UIButton) {
        resultTextView.text = LaraCrypt().encrypt(Message: messageTextView.text, Key: keyTextView.text)
        
        let decrypted:String = LaraCrypt().decrypt(Message: resultTextView.text, Key: keyTextView.text)
        
        print(decrypted)
        
    }

}

