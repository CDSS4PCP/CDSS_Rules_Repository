library "MMR12MedicalContraPrecautionMMRRecommendation_HIVImmunocompromised" version '1.0.0'

include "MMR_Common_Library" version '1.0.0' called Common

using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers

codesystem "CONDCLINSTATUS": 'http://terminology.hl7.org/CodeSystem/condition-clinical'


code "Condition Active code": 'active' from "CONDCLINSTATUS" display 'Active'

concept "Condition Active": { "Condition Active code" } display 'Active'

context Patient

define function ActiveCondition(CondList List<Condition>):
  CondList C
    where C.clinicalStatus ~ "Condition Active"
      and C.abatement is null

// Check for active HIV/AIDS conditions
define "HIV_or_AIDS_Condition":
  exists(ActiveCondition(Common."HIV AIDS Conditions"))

// Check for abnormal CD4 observations (Count < 200 or % < 15)
define "HIV_or_AIDS_Observation":
    exists(Common."Abnormal HIV AIDS Observations")


define "InPopulation":
   HIV_or_AIDS_Condition or "HIV_or_AIDS_Observation"

define "Recommendation1":
    if InPopulation then
        'DO NOT ADMINISTER OR SCHEDULE MMR'
    else
        null




