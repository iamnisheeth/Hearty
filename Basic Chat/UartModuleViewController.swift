//
//  UartModuleViewController.swift
//  Basic Chat
//
//  Created by Trevor Beaton on 12/4/16.
//  Copyright © 2016 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreBluetooth

class UartModuleViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    //UI
//    @IBOutlet weak var baseTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var switchUI: UISwitch!
    @IBOutlet weak var viewTap: UIScrollView!
    
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")

    var swipeGesture  = UISwipeGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    var heartyState = "text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // SWIPE GESTURE
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UartModuleViewController.swipwView(_:)))
            scrollView.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            scrollView.isUserInteractionEnabled = true
            scrollView.isMultipleTouchEnabled = true
        
        // TAP Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(UartModuleViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewTap.addGestureRecognizer(tapGesture)
        viewTap.isUserInteractionEnabled = true

        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
//        self.baseTextView.delegate = self
        self.inputTextField.delegate = self
        //Base text view setup
//        self.baseTextView.layer.borderWidth = 3.0
//        self.baseTextView.layer.borderColor = UIColor.blue.cgColor
//        self.baseTextView.layer.cornerRadius = 3.0
//        self.baseTextView.text = ""
        //Input Text Field setup
        self.inputTextField.layer.borderWidth = 2.0
        self.inputTextField.layer.borderColor = UIColor.blue.cgColor
        self.inputTextField.layer.cornerRadius = 3.0
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.baseTextView.text = ""
        
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        // peripheralManager?.stopAdvertising()
        // self.peripheralManager = nil
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func singleTap(gesture: UITapGestureRecognizer) {
        print("single tap called")
    }

    func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        if (heartyState != "text" ){
        print("---- * ---- * --- single tap called --- * ---")
        // send respective commands to hearty
        let ctrlchar = "D"
        writeValue(data: ctrlchar)
        }
    }
    func swipwView(_ sender : UISwipeGestureRecognizer){
        var controlchar = "s"
        if (heartyState != "text" ){
        UIView.animate(withDuration: 1.0) {
            if sender.direction == .right {
                print(" -- R I G H T --")
                 controlchar = "S"
            }else if sender.direction == .left{
                print(" -- L E F T --")
                controlchar = "A"
            }else if sender.direction == .up{
                print(" --   U   P  --")
                controlchar = "W"
            }else if sender.direction == .down{
                print(" -- D  O W  N --")
                controlchar = "Z"
            }
            self.scrollView.layoutIfNeeded()
            self.scrollView.setNeedsDisplay()
        }
        // send respective commands to hearty
        writeValue(data: controlchar)
        }
    }
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            let appendString = "\n"
            let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
            let myAttributes2 = [NSFontAttributeName: myFont!, NSForegroundColorAttributeName: UIColor.red]
            let attribString = NSAttributedString(string: "[Incoming]: " + (characteristicASCIIValue as String) + appendString, attributes: myAttributes2)
            let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
//            self.baseTextView.attributedText = NSAttributedString(string: characteristicASCIIValue as String , attributes: myAttributes2)
            
            newAsciiText.append(attribString)
            
            self.consoleAsciiText = newAsciiText
//            self.baseTextView.attributedText = self.consoleAsciiText
            
        }
    }
    
    @IBAction func clickSendAction(_ sender: AnyObject) {
        outgoingData()
        
    }
    
    
    
    func outgoingData () {
        let appendString = "\n"
        
        let inputText = inputTextField.text
        
        let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
        let myAttributes1 = [NSFontAttributeName: myFont!, NSForegroundColorAttributeName: UIColor.blue]
        
        switch inputText {
        case "snake"  :
            heartyState = "snake"
        case "tetris" :
            heartyState = "tetris"
            
        case "exit" :
           heartyState = "text"
        default:
             heartyState = "text"
        }
        writeValue(data: inputText!)
        
        let attribString = NSAttributedString(string: "[Outgoing]: " + inputText! + appendString, attributes: myAttributes1)
        let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
        newAsciiText.append(attribString)
        
        consoleAsciiText = newAsciiText
//        baseTextView.attributedText = consoleAsciiText
        //erase what's in the text field
        inputTextField.text = ""
        
    }
    
    // Write functions
    func writeValue(data: String){
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        //change the "data" to valueString
        print("Trying to write this :")
        if let blePeripheral = blePeripheral{
            if let txCharacteristic = txCharacteristic {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
    
    func writeCharacteristic(val: Int8){
        var val = val
        let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    
    //MARK: UITextViewDelegate methods
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if textView === baseTextView {
//            //tapping on consoleview dismisses keyboard
//            inputTextField.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }
    
    //This on/off switch sends a value of 1 and 0 to the Arduino
    //This can be used as a switch or any thing you'd like
//    @IBAction func switchAction(_ sender: Any) {
//        if switchUI.isOn {
//            print("On ")
//            writeCharacteristic(val: 1)
//        }
//        else
//        {
//            print("Off")
//            writeCharacteristic(val: 0)
//            print(writeCharacteristic)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        outgoingData()
        return(true)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }
}

