import UIKit

class AppViewController: UIViewController {
    
    var data: Dictionary<String, Double> = Dictionary<String, Double>()
    var companyDataSorted: [(String, Double)] = [(String, Double)]()
    var hhi: Double = 0
    var cr4: Double = 0
    
    //output
    @IBOutlet weak var hhiOutput: UITextField!
    @IBOutlet weak var cr4Output: UITextField!
    @IBOutlet weak var indicationOutput: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    
    //input
    //email client names
    @IBOutlet weak var contentName1: UITextField!
    @IBOutlet weak var contentName2: UITextField!
    @IBOutlet weak var contentName3: UITextField!
    @IBOutlet weak var contentName4: UITextField!
    @IBOutlet weak var contentName5: UITextField!
    @IBOutlet weak var contentName6: UITextField!
    @IBOutlet weak var contentName7: UITextField!
    @IBOutlet weak var contentName8: UITextField!
    
    //share
    @IBOutlet weak var share1: UITextField!
    @IBOutlet weak var share2: UITextField!
    @IBOutlet weak var share3: UITextField!
    @IBOutlet weak var share4: UITextField!
    @IBOutlet weak var share5: UITextField!
    @IBOutlet weak var share6: UITextField!
    @IBOutlet weak var share7: UITextField!
    @IBOutlet weak var share8: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hhiOutput.isUserInteractionEnabled = false
        cr4Output.isUserInteractionEnabled = false
        indicationOutput.isUserInteractionEnabled = false
        share1.keyboardType = UIKeyboardType.numberPad
        share2.keyboardType = UIKeyboardType.numberPad
        share3.keyboardType = UIKeyboardType.numberPad
        share4.keyboardType = UIKeyboardType.numberPad
        share5.keyboardType = UIKeyboardType.numberPad
        share6.keyboardType = UIKeyboardType.numberPad
        share7.keyboardType = UIKeyboardType.numberPad
        share8.keyboardType = UIKeyboardType.numberPad
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateNums(_ sender: Any) {
        errorMsg.text = ""
        
        //check if the form is filled
        if (contentName1.text != "" && share1.text != "") {
            //make a Dictionary (NSSet)
            
            //first input
            if (contentName1.text != "" && share1.text != "") {
                data[contentName1.text!] = Double(share1.text!)
            } else if (contentName1.text == "" && share1.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName1.text != "" && share1.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //second input
            if (contentName2.text != "" && share2.text != "") {
                data[contentName2.text!] = Double(share2.text!)
            } else if (contentName2.text == "" && share2.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName2.text != "" && share2.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //third input
            if (contentName3.text != "" && share3.text != "") {
                data[contentName3.text!] = Double(share3.text!)
            } else if (contentName3.text == "" && share3.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName3.text != "" && share3.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //fourth input
            if (contentName4.text != "" && share4.text != "") {
                data[contentName4.text!] = Double(share4.text!)
            }  else if (contentName4.text == "" && share4.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName4.text != "" && share4.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //fifith input
            if (contentName5.text != "" && share5.text != "") {
                data[contentName5.text!] = Double(share5.text!)
            } else if (contentName5.text == "" && share5.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName5.text != "" && share5.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //sixth input
            if (contentName6.text != "" && share6.text != "") {
                data[contentName6.text!] = Double(share6.text!)
            } else if (contentName6.text == "" && share6.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName6.text != "" && share6.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //seventh input
            if (contentName7.text != "" && share7.text != "") {
                data[contentName7.text!] = Double(share7.text!)
            } else if (contentName7.text == "" && share7.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName7.text != "" && share7.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            //eighth input
            if (contentName8.text != "" && share8.text != "") {
                data[contentName8.text!] = Double(share8.text!)
            } else if (contentName8.text == "" && share8.text != "") {
                errorMsg.text = "Fill in a pair of blanks."
            } else if (contentName8.text != "" && share8.text == "") {
                errorMsg.text = "Fill in a pair of blanks."
            }
            
            let sortedData = data.sorted(by: sortCompanyData)
            
            companyDataSorted = sortedData
            
            //make a string array that has top 4 companies name
            var top4ContentNames = [String]()
            for (key, _) in sortedData {
                top4ContentNames.append(key)
            }
            
            //make a double array that has top 4 companies value
            var top4Value = [Double]()
            for (_, value) in sortedData {
                top4Value.append(value)
            }
            
            //calculate HHI
            for (_, value) in sortedData {
                hhi += value * value
            }
            hhiOutput.text = String(hhi)
            
            //get top 4 value to calculate cr4
            
            if (top4Value.count > 4) {
                for i in 0...3 {
                    cr4 += top4Value[i]
                }
            } else if (top4Value.count < 4) {
                for i in 0...top4Value.count - 1 {
                    cr4 += top4Value[i]
                }
            }

            cr4Output.text = String(cr4)
            
            companyDataSorted.removeAll()
            
            if (top4Value.count > 3 && top4ContentNames.count > 3) {
                for i in 0...3 {
                    companyDataSorted.append((top4ContentNames[i], top4Value[i]))
                }
            } else {
                for i in 0...top4ContentNames.count - 1 {
                    companyDataSorted.append((top4ContentNames[i], top4Value[i]))
                }
            }
            
            //decide the indication
            if (hhi < 1500) {
                indicationOutput.text = "Unconcentrated"
            } else if (hhi >= 1500 && hhi <= 2500) {
                indicationOutput.text = "Moderately concentrated"
            } else if (hhi > 2500) {
                indicationOutput.text = "Highly concentrated"
            }
        } else {
            errorMsg.text = "Fill in at least one pair of inputs"
        }
    }
    
    
    func sortCompanyData(first: (key: String, value: Double), second: (key: String, value: Double)) -> Bool {
        return first.value > second.value
    }
    
    @IBAction func goToMerge(_ sender: Any) {
        
        if (hhiOutput.text != "" && cr4Output.text != "" && indicationOutput.text != "") {
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mergerViewController = segue.destination as! MergerViewController
        mergerViewController.originalData = data
        mergerViewController.contents = companyDataSorted
        mergerViewController.oldhhi = hhi
        mergerViewController.oldcr4 = cr4
    }
    
}
