library "MMR1regularyoungerthan12monthsNoMMRRecommendation" version '1.0.0'

/*
Purpose: No (routine) vaccine for infants under 12 months
- Age range < 12 months old
- No valid MMR doses on record
- Provides scheduling guidance for future doses
*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include MMR_Common_Library version '1.0.0' called Common

context Patient

// Age eligibility: Birth to < 12 months
define "Age Eligibility Range":
  Interval[0 months, 12 months)

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
  // No action at this visit (patient too young)
  null

define "Recommendation 2":
  if "In Population" then
    'Schedule 1st dose MMR at 12-15 months'
  else
    null