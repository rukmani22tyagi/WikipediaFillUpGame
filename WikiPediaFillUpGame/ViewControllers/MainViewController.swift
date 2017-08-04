//
//  MainViewController.swift
//  WikiPediaFillUpGame
//
//  Created by Rukmani  on 02/08/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

struct Options {
    var tag: Int
    var option: String
    
    init(_tag: Int, _option: String) {
        tag = _tag
        option = _option
    }
}

class MainViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var paragraphLabel: ActiveLabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var optionsMainView: UIView!
    @IBOutlet weak var OptionViewHeightConstraint: NSLayoutConstraint!
    
    var sentences = [String]()
    var optionsToFill: [Options] = []
    var selectedOption = Options(_tag: 0, _option: "")
    var position = 0
    var correct = 0
    var wrong = 0
    var para = ""
    
    //MARK: UIController Methods
    override func viewDidLoad() {
        self.para = paragraph
        self.optionsMainView.isHidden = true
        configureActiveLabel()
        getSentences()
        replaceWordsWithBlanks()
        shuffleReplacedWords()
        updateParagraph()
    }
    
    func hidOptionView() {
        self.optionsMainView.isHidden = true
    }
    
    func configureActiveLabel() {
        let customType = ActiveType.custom(pattern: "__________")
        paragraphLabel.enabledTypes = [customType]
        
        paragraphLabel.customColor[customType] = UIColor.red
        paragraphLabel.customSelectedColor[customType] = UIColor.green
        
        
        paragraphLabel.handleCustomTap(for: customType) { element, pos in
            self.position = pos
            self.optionsMainView.isHidden = false
        }
    }
    
    //To get sentences from the paragraph separated by .
    func getSentences() {
        self.sentences = para.components(separatedBy: ".")
        self.sentences.removeLast()
    }
    
    //Replacing a word in a sentence by blanks - word at approx middle position in sentence is replcaed
    func replaceWordsWithBlanks() {
        for index in 0..<10 {
            var words = [String]()
            words = sentences[index].components(separatedBy: [" ", ",", ":", "(", ")", "-", "?"])
            
            let blankPos = words.count / 2
            var word = words[blankPos]
            if word.characters.count < 2 {
                word = words[blankPos + 1]
            }
            let option = Options(_tag: index, _option: word)
            optionsToFill.append(option)
            sentences[index] = sentences[index].stringByReplacingFirstOccurrence(of: word, with: "__________")
        }
        self.optionsTableView.reloadData()
    }
    
    //To Shuffle the array of replaced words using a random number to swap
    func shuffleReplacedWords() {
        if optionsToFill.count < 2 {
            return
        }
        for index in 0..<optionsToFill.count {
            let num = Int(arc4random_uniform(UInt32(optionsToFill.count)))
            swap(firstPos: index, secondPos: num)
        }
    }
    
    //Swap two words in array
    func swap(firstPos: Int, secondPos: Int) {
        let temp = optionsToFill[firstPos]
        optionsToFill[firstPos] = optionsToFill[secondPos]
        optionsToFill[secondPos] = temp
    }
    
    func updateParagraph() {
        self.paragraphLabel.text = ""
        if sentences.count >= noOfSentencesRequired {
            for index in 0..<noOfSentencesRequired {
                self.paragraphLabel.text = self.paragraphLabel.text! + sentences[index] + "."
            }
        }
    }
    func updateUI() {
        let range = NSRange(location: position, length: blank.characters.count)
        if let nsString = self.paragraphLabel.text as NSString? {
            self.paragraphLabel.text = nsString.replacingCharacters(in: range, with: "\(selectedOption.option)")
        }
    }
    
    @IBAction func backgroundButtonTapped(_ sender: UIButton) {
        self.optionsMainView.isHidden = true
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        self.sentences.removeAll()
        getSentences()
        for index in 0..<noOfSentencesRequired {
            var words = [String]()
            words = sentences[index].components(separatedBy: [" ", ",", ":", "(", ")", "-", "?"])
            
            let blankPos = words.count / 2
            var word = words[blankPos]
            if word.characters.count < 2 {
                word = words[blankPos + 1]
            }
            
            if let i = optionsToFill.inde
            
            let exists = optionsToFill.contains(where:  { optionInList in
                return (optionInList.option == word)
            })
            
            if exists {
                
            }
            
            let filteredOption = optionsToFill.filter { $0.option == word }
            if filteredOption.first?.tag == index {
                
            }
//            for existingOption in optionsToFill {
//                if existingOption.option == word {
//                    if index == existingOption.tag {
//                        correct += 1
//                    } else {
//                        wrong += 1
//                    }
//                    break
//                }
//            }
            print("Correct: ",correct)
            print("Wrong: ",wrong)
        }
        

    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionsToFill.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.optionsToFill[indexPath.row].option
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.optionsMainView.isHidden = true
        selectedOption = optionsToFill[indexPath.row]
        updateUI()
    }
}

//To replace First Occurence in string
extension String
{
    func stringByReplacingFirstOccurrence(
        of target: String, with replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
