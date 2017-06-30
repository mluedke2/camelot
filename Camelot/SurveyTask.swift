//
//  SurveyTask.swift
//  Camelot
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import ResearchKit

open class SurveyTask: NSObject, ORKTask {
  
  let introStepID = "intro_step"
  let nameStepID = "name_step"
  let questStepID = "quest_step"
  let colorStepID = "color_step"
  let summaryStepID = "summary_step"
  
  open var identifier: String { get { return "survey"} }
  
  open func step(before step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
    
    switch step?.identifier {
    case .some(nameStepID):
      return self.step(withIdentifier: introStepID)
      
    case .some(questStepID):
      return self.step(withIdentifier: nameStepID)
      
    case .some(colorStepID):
      return questStep(findName(result))
      
    case .some(summaryStepID):
      return self.step(withIdentifier: colorStepID)
      
    default:
      return nil
    }
  }
  
  open func step(after step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
    
    switch step?.identifier {
    case .none:
      return self.step(withIdentifier: introStepID)
      
    case .some(introStepID):
      return self.step(withIdentifier: nameStepID)
      
    case .some(nameStepID):
      return questStep(findName(result))
      
    case .some(questStepID):
      return self.step(withIdentifier: colorStepID)
      
    case .some(colorStepID):
      return self.step(withIdentifier: summaryStepID)
      
    default:
      return nil
    }
  }
  
  open func step(withIdentifier identifier: String) -> ORKStep? {
    switch identifier {
      
    case introStepID:
      let instructionStep = ORKInstructionStep(identifier: introStepID)
      instructionStep.title = "The Questions Three"
      instructionStep.text = "Who would cross the Bridge of Death must answer me these questions three, ere the other side they see."
      return instructionStep
      
    case nameStepID:
      let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
      nameAnswerFormat.multipleLines = false
      let nameQuestionStepTitle = "What is your name?"
      return ORKQuestionStep(identifier: nameStepID, title: nameQuestionStepTitle, answer: nameAnswerFormat)
      
    case questStepID:
      return questStep("")
      
    case colorStepID:
      let colorQuestionStepTitle = "What is your favorite color?"
      let colorTuples = [
        (UIImage(named: "red")!, "Red"),
        (UIImage(named: "orange")!, "Orange"),
        (UIImage(named: "yellow")!, "Yellow"),
        (UIImage(named: "green")!, "Green"),
        (UIImage(named: "blue")!, "Blue"),
        (UIImage(named: "purple")!, "Purple")
      ]
      var imageChoices:[ORKImageChoice] = []
      for (image, name) in colorTuples {
        imageChoices.append(ORKImageChoice(normalImage: image, selectedImage: nil, text: name, value: name as NSCoding & NSCopying & NSObjectProtocol))
      }
      let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(withImageChoices: imageChoices)
      return ORKQuestionStep(identifier: colorStepID, title: colorQuestionStepTitle, answer: colorAnswerFormat)
      
    case summaryStepID:
      let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
      summaryStep.title = "Right. Off you go!"
      summaryStep.text = "That was easy!"
      return summaryStep
      
    default:
      return nil
    }
  }
  
  func findName(_ result: ORKTaskResult) -> String? {
    
    if let stepResult = result.result(forIdentifier: nameStepID) as? ORKStepResult, let subResults = stepResult.results, let textQuestionResult = subResults[0] as? ORKTextQuestionResult {
      
      return textQuestionResult.textAnswer
    }
    return nil
  }
  
  func questStep(_ name: String?) -> ORKStep {
    
    var questQuestionStepTitle = "What is your quest?"
    
    if let name = name {
      questQuestionStepTitle = "What is your quest, \(name)?"
    }
    
    let textChoices = [
      ORKTextChoice(text: "Create a ResearchKit App", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
      ORKTextChoice(text: "Seek the Holy Grail", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
      ORKTextChoice(text: "Find a shrubbery", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    return ORKQuestionStep(identifier: questStepID, title: questQuestionStepTitle, answer: questAnswerFormat)
  }
}
