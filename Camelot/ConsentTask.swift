//
//  ConsentTask.swift
//  Camelot
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import ResearchKit

public var ConsentTask: ORKOrderedTask {
  
  var steps = [ORKStep]()
  
  let consentDocument = ConsentDocument
  let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
  steps += [visualConsentStep]
  
  let signature = consentDocument.signatures!.first as! ORKConsentSignature
  
  let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
  
  reviewConsentStep.text = "Review Consent!"
  reviewConsentStep.reasonForConsent = "Consent to join study"
  
  steps += [reviewConsentStep]
  
  return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
