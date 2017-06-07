import UIKit
import Foundation

class MergerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentsTableView: UITableView!
    
    
    //input from the previous view
    var originalData = Dictionary<String, Double>()
    var contents: [(String, Double)] = [(String, Double)]()
    var oldhhi: Double = 0
    var oldcr4: Double = 0
    
    //merge button
    @IBOutlet weak var mergeButton: UIButton!
    
    //output
    @IBOutlet weak var oldhhiLabel: UITextField!
    @IBOutlet weak var oldcr4Label: UITextField!
    @IBOutlet weak var oldConcentrationLabel: UITextField!
    @IBOutlet weak var newhhiLabel: UITextField!
    @IBOutlet weak var newcr4Label: UITextField!
    @IBOutlet weak var newConcentrationLabel: UITextField!
    @IBOutlet weak var analysisLabel: UITextView!
    @IBOutlet weak var errorMsg: UILabel!
    
    //other variables for calculation
    var selectedContents = [(String, Double)]()
    var selectedKeys = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var (emailClient, share) = contents[indexPath.row]
        cell.textLabel?.text = "\(emailClient) - Share: \(share)%"
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldhhiLabel.text = String(oldhhi)
        oldcr4Label.text = String(oldcr4)
        oldConcentrationLabel.text = self.getConcentration(hhi: oldhhi)
        newhhiLabel.isUserInteractionEnabled = false
        newcr4Label.isUserInteractionEnabled = false
        newConcentrationLabel.isUserInteractionEnabled = false
        oldhhiLabel.isUserInteractionEnabled = false
        oldcr4Label.isUserInteractionEnabled = false
        analysisLabel.isUserInteractionEnabled = false
        mergeButton.isEnabled = true
        contentsTableView.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedKeys.append(contents[indexPath.row].0)
        //        selectedContents.append((contents[indexPath.row].0, contents[indexPath.row].1))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedKeys = selectedKeys.filter { $0 != contents[indexPath.row].0}
    }
    
    @IBAction func merge(_ sender: Any) {
        print("# in the array: \(selectedKeys.count)")
        if (selectedKeys.count > 1) {
            
        var newhhiVal: Double = 0
        var newcr4Val: Double = 0
        var mergedShare: Double = 0
        var nameWithBiggestShare: String = ""
        
        //merge cells
        
        //assigning values based on selected keys
        for key in selectedKeys {
            selectedContents.append((key,originalData[key]!))
        }
        
        selectedContents = selectedContents.sorted(by: sortCompanyData)
        
        //save the content name with the biggest share
        nameWithBiggestShare = selectedContents[0].0
        
        //merge shares
        for i in 0...selectedContents.count - 1 {
            print("selectedContents[i].1 \(selectedContents[i].1)")
            mergedShare += selectedContents[i].1
        }
        
        //delete selected from the original contents
        var temp: Dictionary<String, Double> = Dictionary<String, Double>()
        temp = originalData
        
        for key in selectedKeys {
            temp.removeValue(forKey: key)
        }
        
        //add new data into temp
        temp[nameWithBiggestShare] = mergedShare
        
        //get new company list
        contents = temp.sorted(by: self.sortCompanyData)
        
        //calculate new hhi
        for (_, value) in contents {
            newhhiVal += (value * value)
        }
        newhhiLabel.text = String(newhhiVal)
        
        //make a string array that has top 4 companies name
        var top4ContentNames = [String]()
        for (key, _) in contents {
            top4ContentNames.append(key)
        }
        
        //make a double array that has top 4 companies value
        var top4Value = [Double]()
        for (_, value) in contents {
            top4Value.append(value)
        }
        
        //get top 4 value to calculate cr4
            if (top4Value.count > 3) {
                for i in 0...3 {
                    newcr4Val += top4Value[i]
                }
            } else if (top4Value.count < 4) {
                for i in 0...top4Value.count - 1 {
                    newcr4Val += top4Value[i]
                }
            }

        newcr4Label.text = String(newcr4Val)
        
        contents.removeAll()
        
            if (top4ContentNames.count > 3 && top4Value.count > 3) {
                for i in 0...3 {
                    contents.append((top4ContentNames[i], top4Value[i]))
                }
            } else if (top4Value.count < 4) {
                for i in 0...top4Value.count - 1 {
                    contents.append((top4ContentNames[i], top4Value[i]))
                }
            }

            
        analysisLabel.text = self.getAnalysis(oldhhi: oldhhi, newhhi: newhhiVal)
        
        //get new concentration
        newConcentrationLabel.text = self.getConcentration(hhi: newhhiVal)
        
        //disabling the merge button
        mergeButton.isEnabled = false
        
        //refresh the tableview
        contentsTableView.reloadData()
            
        } else {
            errorMsg.text = "Select 2 or more contents"
        }
    }
    
    func sortCompanyData(first: (key: String, value: Double), second: (key: String, value: Double)) -> Bool {
        return first.value > second.value
    }
    
    
    func getConcentration(hhi: Double) -> String {
        var retVal: String = ""
        
        if (hhi < 1500) {
            retVal = "Unconcentrated"
        } else if (hhi >= 1500 && hhi <= 2500) {
            retVal = "Moderately concentrated"
        } else if (hhi > 2500) {
            retVal = "Highly concentrated"
        }
        return retVal
    }
    
    func getAnalysis(oldhhi: Double, newhhi: Double) -> String {
        var retVal:String = ""
        let difference:Double = newhhi - oldhhi
        if (difference > 0) {
            if (difference < 100) {
                retVal = "The merger is unlikely to have adverse competitive effects and ordinarily require no further analysis."
            } else if (difference > 100) {
                retVal = "The merger potentially raises significant competitive concerns and warrants scrutiny."
            } else if (difference > 200) {
                retVal = "The merger will be presumed to be likely to enhance market power."
            }
        }
        return retVal
    }
    
}
