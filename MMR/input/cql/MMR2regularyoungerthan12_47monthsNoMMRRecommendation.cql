library "MMR2regularyoungerthan12_47monthsNoMMRRecommendation" version '1.0.0'

/*
Purpose: Recommend first MMR dose for toddlers
- Patient age: 12 months to < 47 months (< 4 years)
- Patient must have no valid MMR doses on record
- Action: Administer 1st dose now
- Schedule: 2nd dose at 4-6 years
*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include MMR_Common_Library version '1.0.0' called Common

context Patient

// Age eligibility: 12 months to < 47 months (< 4 years)
define "Age Eligibility Range":
  Interval[12 months, 47 months)

define "Patient Age in Months":
  AgeInMonths()

define "Patient Age in Range":
  "Patient Age in Months" in "Age Eligibility Range"

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
    'Schedule 2nd dose MMR at 4-6 years'
  else
    null
