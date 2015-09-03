//
//  SurveyTask.swift
//  Camelot
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import ResearchKit

public class SurveyTask: NSObject, ORKTask {
  
  let introStepID = "intro_step"
  let nameStepID = "name_step"
  let questStepID = "quest_step"
  let colorStepID = "color_step"
  let summaryStepID = "summary_step"
  
  public var identifier: String { get { return "survey"} }
  
  public func stepBeforeStep(step: ORKStep?, withResult result: ORKTaskResult) -> ORKStep? {
    
    switch step?.identifier {
    case .Some(nameStepID):
      return stepWithIdentifier(introStepID)
      
    case .Some(questStepID):
      return stepWithIdentifier(nameStepID)
      
    case .Some(colorStepID):
      return questStep(findName(result))
      
    case .Some(summaryStepID):
      return stepWithIdentifier(colorStepID)
      
    default:
      return nil
    }
  }
  
  public func stepAfterStep(step: ORKStep?, withResult result: ORKTaskResult) -> ORKStep? {
    
    switch step?.identifier {
    case .None:
      return stepWithIdentifier(introStepID)
      
    case .Some(introStepID):
      return stepWithIdentifier(nameStepID)
      
    case .Some(nameStepID):
      return questStep(findName(result))
      
    case .Some(questStepID):
      return stepWithIdentifier(colorStepID)
      
    case .Some(colorStepID):
      return stepWithIdentifier(summaryStepID)
      
    default:
      return nil
    }
  }
  
  public func stepWithIdentifier(identifier: String) -> ORKStep? {
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
        imageChoices.append(ORKImageChoice(normalImage: image, selectedImage: nil, text: name, value: name))
      }
      let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
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
  
  func findName(result: ORKTaskResult) -> String? {
    
    if let stepResult = result.resultForIdentifier(nameStepID) as? ORKStepResult, let subResults = stepResult.results, let textQuestionResult = subResults[0] as? ORKTextQuestionResult {
      
      return textQuestionResult.textAnswer
    }
    return nil
  }
  
  func questStep(name: String?) -> ORKStep {
    
    var questQuestionStepTitle = "What is your quest?"
    
    if let name = name {
      questQuestionStepTitle = "What is your quest, \(name)?"
    }
    
    let textChoices = [
      ORKTextChoice(text: "Create a ResearchKit App", value: 0),
      ORKTextChoice(text: "Seek the Holy Grail", value: 1),
      ORKTextChoice(text: "Find a shrubbery", value: 2)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    return ORKQuestionStep(identifier: questStepID, title: questQuestionStepTitle, answer: questAnswerFormat)
  }
}
