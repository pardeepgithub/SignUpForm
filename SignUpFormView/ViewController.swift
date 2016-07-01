//
//  ViewController.swift
//  SignUpFormView
//
//  Created by Chetu India on 07/03/16.
//  Copyright © 2016 Chetu. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let signUpPlaceholderArray = ["First Name", "Last Name", "Mobile", "Email", "Password", "DOB", "Salary", "Dept", "Position", "Floor"]
    let signUpArray = ["first_name", "last_name", "mobile", "email", "password", "dob", "salary", "dept", "position", "floor"]
    var signUpDict = NSMutableDictionary()
    var isValidate = Bool()
    
    @IBOutlet weak var tableViewSignUp: UITableView!
    @IBOutlet weak var tableViewDropDown: UITableView!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    
    let imagePicker = UIImagePickerController()
    let numberToolbar: UIToolbar = UIToolbar()
    
    
    
    // MARK:  UIViewController class overrided method.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        for index in 0..<signUpArray.count {
            signUpDict.setValue("", forKey: signUpArray[index])
        }
        
        tableViewSignUp.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Hi inside of an viewWillAppear Method.")
        
        // Code to initialize and set view design.
        buttonSignUp.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableViewSignUp.separatorColor = UIColor.clearColor()
    }
    

    
    
    
    
    // MARK:  UITextField delegate methods.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
        if textField.tag == 0{
        }
        else if textField.tag == 3{
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableViewSignUp.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            
            let paths = tableViewSignUp.indexPathsForVisibleRows
            let firstRow = paths![0].row
            
            let actualXPosition = (textField.tag - firstRow + 1) * 70 + 70
            print("Actual x position: \(actualXPosition)")
            
            let xPoint = textField.frame.origin.x
            let yPoint = textField.frame.origin.y
            let width = textField.frame.size.width

            let frame: CGRect = CGRectMake(xPoint, 360, width, 120)
            self.setDropDownTableViewFrame(frame)
            
            print("Textfield x position: \(xPoint)")
            print("Textfield y position: \(yPoint)")
            print("Textfield width position: \(width)")
            
            self.view.endEditing(true)
            return false
        }
        else if textField.tag == 4{
            
            self.getImage()
            self.view.endEditing(true)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.tag == signUpPlaceholderArray.count-1 {
            textField.resignFirstResponder()
            return true
        }
        else {
            let paths = tableViewSignUp.indexPathsForVisibleRows
            var flag = false
            
            for path in paths! {
                if path.row == textField.tag+1{
                    flag = true
                    break;
                }
            }
            
            if flag{
                let indexpath: NSIndexPath = NSIndexPath(forRow: textField.tag+1, inSection: 0)
                let cell: SignUpTableViewCell = (tableViewSignUp.cellForRowAtIndexPath(NSIndexPath(forRow: textField.tag+1, inSection: 0)) as? SignUpTableViewCell!)!
                
                cell.textFieldEntries.becomeFirstResponder()
                tableViewSignUp.scrollToRowAtIndexPath(indexpath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            }
            else{
                let indexpath: NSIndexPath = paths![0]
                let cell: SignUpTableViewCell = (tableViewSignUp.cellForRowAtIndexPath(indexpath) as? SignUpTableViewCell!)!
                cell.textFieldEntries.becomeFirstResponder()
            }
            
            return false
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.tag == signUpPlaceholderArray.count-1{
            textField.returnKeyType = .Done
        }
        else{
            textField.returnKeyType = .Next
        }
        
        if textField.tag == 2{
            textField.keyboardType = UIKeyboardType.NumberPad
            
            // Code to add UIToolBar on keyboard type number for return key type
            numberToolbar.barStyle = UIBarStyle.BlackTranslucent
            numberToolbar.items=[
                UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "mobileNumberKeyboardDonePressed"),
            ]
            numberToolbar.sizeToFit()
            textField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
        }
        else if textField.tag == 3{
            textField.keyboardType = UIKeyboardType.EmailAddress
        }
        else{
            textField.keyboardType = UIKeyboardType.Default
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let value = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        signUpDict.setValue(value, forKey: signUpArray[textField.tag])
    }

    
    
    
    //MARK:  mobileNumberKeyboardDonePressed Method.
    func mobileNumberKeyboardDonePressed () {
        let indexpath: NSIndexPath = NSIndexPath(forRow: 2, inSection: 0)
        let cell: SignUpTableViewCell = (tableViewSignUp.cellForRowAtIndexPath(indexpath) as? SignUpTableViewCell!)!
        
        cell.textFieldEntries.resignFirstResponder()
    }
    
    
    
    //MARK:  setDropDownTableViewFrame Method.
    func setDropDownTableViewFrame(frame: CGRect){
        
        self.tableViewDropDown.frame = CGRectMake(self.view.frame.width+1, frame.origin.y , frame.size.width, 120)
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            self.tableViewDropDown.frame = frame
            self.tableViewDropDown.layer.cornerRadius = 5.0
            self.tableViewDropDown.reloadData()
            }, completion: { (finished: Bool) -> Void in
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
    }
    
    
    
    // MARK:  getImage Method.
    func getImage(){
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK:  openCamera Method.
    func openCamera(){

        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert:UIAlertController=UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                {
                    UIAlertAction in
            }
            
            // Add the actions
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK:  openGallary Method.
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    // MARK:  UIImagePickerControllerDelegate Methods.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        // let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        // myImageView.contentMode = .ScaleAspectFit //3
        // myImageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    // MARK:  UITableView DataSource and Delegate methods.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView == tableViewSignUp{
            return 70.0
        }
        else{
            return 40.0
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        if tableView == tableViewSignUp{
            return signUpPlaceholderArray.count
        }
        else{
            return 5
        }
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        if tableView == tableViewSignUp{
            let cell: SignUpTableViewCell = (tableView.dequeueReusableCellWithIdentifier("SignUpTableViewCell") as? SignUpTableViewCell!)!
            cell.contentView.backgroundColor = UIColor.clearColor()
            //cell.backgroundColor = cell.contentView.backgroundColor;
            cell.backgroundColor = cell.contentView.backgroundColor
            
            tableView.separatorColor = UIColor.clearColor()
            tableView.backgroundColor = UIColor.clearColor()
            
            cell.textFieldEntries.placeholder = signUpPlaceholderArray[indexPath.row]
            cell.textFieldEntries.tag = indexPath.row
            cell.titleLabel.text = signUpPlaceholderArray[indexPath.row]
            
            if signUpDict.valueForKey(signUpArray[indexPath.row]) as! String != ""{
                cell.textFieldEntries.text = signUpDict.valueForKey(signUpArray[indexPath.row]) as? String
            }
            
            // For secure password entry.
            if indexPath.row == 4 {
                cell.textFieldEntries.secureTextEntry = true
            }
            else {
                cell.textFieldEntries.secureTextEntry = false
            }
            return cell
        }
        else{

            let cell: DropDownTableViewCell = (tableView.dequeueReusableCellWithIdentifier("Cell") as? DropDownTableViewCell!)!
            cell.textLabel!.text = "detail"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == tableViewSignUp{
            print("tableViewSignUp")
        }
        else{
            print("tableViewDropDown")
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                
                self.tableViewDropDown.frame = CGRectMake(self.view.frame.width+1, self.tableViewDropDown.frame.origin.y, self.tableViewDropDown.frame.size.width, self.tableViewDropDown.frame.size.height)
                self.tableViewDropDown.layer.cornerRadius = 5.0
                self.tableViewDropDown.reloadData()
                
                }, completion: { (finished: Bool) -> Void in
                    // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
            })
        }
    }
    
    

    

    // MARK:  Memory management method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
