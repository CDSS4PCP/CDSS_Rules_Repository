library "MMR4regular12months_4yrs_OneMMRRecommendation" version '1.0.0'

/*
Age [12 mo, 4 yr) and one MMR
- Schedule 2nd dose MMR
- null if 1st dose is give late. TODO: This is an error. 
  If the first does is given late, the 2nd dose should be given 
  4 weeks after the 1st dose AND after or on 4th birthday.
*/

using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers
include "MMR_Common_Library" version '1.0.0' called Common

context Patient

define "$Age1": 12

define "$Age1_unit": 'month'

define "$Age2": 4

define "$Age2_unit": 'year'

define "$Dose1AdminMinAge": 12

define "$Dose1AdminMinAge_unit": 'month'

define "$Dose1AdminMaxAge": 15

define "$Dose1AdminMaxAge_unit": 'month'

define "VaccineName":
    'Measles, Mumps, and Rubella Virus Vaccine'

define "Current Age in Lower Limit Units":
  Common.GetAge("$Age1_unit")

define "Current Age in Upper Limit Units":
  Common.GetAge("$Age2_unit")

define "Current Age In Range":
  Common.GetAge("$Age1_unit") >= "$Age1"
    and Common.GetAge("$Age2_unit") < "$Age2"

// Check if patient has exactly one MMR dose
define "MMR_Vaccine_OneDose":
    Count(Common."MMR Immunizations") = 1

// Extract dates from MMR immunizations
define function MMRVaccineDate(Immunizations List<FHIR.Immunization>):
    (Immunizations TemDate
      return Tuple {
        Date: Date(
          year from TemDate.occurrence.value,
          month from TemDate.occurrence.value,
          day from TemDate.occurrence.value
          )
        }
    sort by Date)

define "PatientBirthDate":
    ToDate(Patient.birthDate.value)

define "VaccineDate":
    ToDate(MMRVaccineDate(Common."MMR Immunizations")[0].Date)

define "DiffInMinAdminUnit":
    Abs(Common.GetDifferenceInUnit("VaccineDate", "PatientBirthDate", "$Dose1AdminMinAge_unit"))

define "DiffInMaxAdminUnit":
    Abs(Common.GetDifferenceInUnit("VaccineDate", "PatientBirthDate", "$Dose1AdminMaxAge_unit"))

define "InDemographic":
    "Current Age In Range"

define "InPopulation":
    InDemographic and MMR_Vaccine_OneDose and "DiffInMinAdminUnit" >= "$Dose1AdminMinAge" and  "DiffInMaxAdminUnit" <= "$Dose1AdminMaxAge"

define "Recommendation1":
    if InPopulation then
        'Recommendation 1: Schedule 2nd dose MMR when patient is 4-6 years old'
    else
        null
