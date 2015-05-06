//
//  SurveyTask.swift
//  Camelot
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
  
  var steps = [ORKStep]()
  
  let instructionStep = ORKInstructionStep(identifier: "IntroStep")
  instructionStep.title = "The Questions Three"
  instructionStep.text = "Who would cross the Bridge of Death must answer me these questions three, ere the other side they see."
  steps += [instructionStep]
  
  let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
  nameAnswerFormat.multipleLines = false
  let nameQuestionStepTitle = "What is your name?"
  let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
  steps += [nameQuestionStep]
  
  let questQuestionStepTitle = "What is your quest?"
  let textChoices = [
    ORKTextChoice(text: "Create a ResearchKit App", value: 0),
    ORKTextChoice(text: "Seek the Holy Grail", value: 1),
    ORKTextChoice(text: "Find a shrubbery", value: 2)
  ]
  let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
  let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
  steps += [questQuestionStep]
  
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
  let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
  steps += [colorQuestionStep]
  
  let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
  summaryStep.title = "Right. Off you go!"
  summaryStep.text = "That was easy!"
  steps += [summaryStep]
  
  return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
