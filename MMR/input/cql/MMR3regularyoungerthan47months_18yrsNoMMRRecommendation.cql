library "MMR3regularyoungerthan47months_18yrsNoMMRRecommendation" version '1.0.0'

/*
Purpose: Recommend first MMR dose for school-age children
- Patient age: 47 months (3y 11m) to < 18 years
- Patient must have no valid MMR doses on record
- Action: Administer 1st dose now
- Schedule: 2nd dose >= 4 weeks after 1st dose
*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include MMR_Common_Library version '1.0.0' called Common

context Patient

// Age eligibility: 47 months to < 18 years
define "Age Eligibility Range in Months":
  Interval[47 months, 216 months)  // 18 years = 216 months

define "Patient Age in Months":
  AgeInMonths()

define "Patient Age in Range":
  "Patient Age in Months" in "Age Eligibility Range in Months"

// Valid MMR doses (given at >= 12 months of age)
define "Valid MMR Doses":
  Common."MMR Immunizations" I
    let doseDate: Coalesce(
      ToDate(I.occurrence as FHIR.dateTime),
      ToDate(I.occurrence as FHIR.string)
    )
    where months between ToDate(Patient.birthDate.value) and doseDate >= 12

define "Has No Valid MMR Doses":
  not exists("Valid MMR Doses")

// Population criteria
define "In Population":
  "Patient Age in Range"
    and "Has No Valid MMR Doses"

// Clinical recommendations
define "Recommendation 1":
  if "In Population" then
    'Administer 1st dose MMR'
  else
    null

define "Recommendation 2":
  if "In Population" then
    'Schedule 2nd dose MMR >= 4 weeks after 1st dose'
  else
    null
