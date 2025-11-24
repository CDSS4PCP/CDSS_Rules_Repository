library "MMR10MedicalContraPrecautionMMRRecommendation" version '1.0.0'

include "MMR_Common_Library" version '1.0.0' called Common

using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers


context Patient

// Check if patient has exactly one MMR dose
define "MMR_Vaccine_OneDose":
  Count(Common."MMR Immunizations") = 1

define "InPopulation":
   MMR_Vaccine_OneDose and exists(Common."Pregnancy Conditions")


   /*
   rationale
   If patient does not have MMR or MMRV records and patient is pregnant, schedule 1st dose of MMR after pregnancy and 2nd dose after 4 weeks of the 1st dose

   */



define "Recommendation1":
    if InPopulation then
        'Schedule/administer 2nd dose after pregnancy, >= 4 wk of 1st dose'
    else null

