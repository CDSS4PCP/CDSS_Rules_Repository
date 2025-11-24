library "MMR6regular12months_4yrs_OneDoseOutOf12to15MonRecommendation" version '1.0.0'

include "MMR_Common_Library" version '1.0.0' called Common
using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers


context Patient

define "$Age1": 12

define "$Age1_unit": 'month'

define "$Age2": 4

define "$Age2_unit": 'year'

define "$Dose1AdminMinAge": 12

define "$Dose1AdminMinAge_unit": 'month'

define "$Dose1AdminMaxAge": 15

define "$Dose1AdminMaxAge_unit": 'month'

define "$WeeksSinceDose": 4

define "$WeeksSinceDose_unit": 'week'

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
  Date: Date(year from TemDate.occurrence.value,
                      month from TemDate.occurrence.value,
					  day from TemDate.occurrence.value)
    }
    sort by Date)

define "PrevDoseDate":
    MMRVaccineDate(Common."MMR Immunizations")[0].Date

define "PatientBirthDate":
    ToDate(Patient.birthDate.value)


define "AgeFirstDoseMonths":
    months between Patient.birthDate and PrevDoseDate // This does not take years into account


define "DiffInMinAdminUnit":
    Abs(Common.GetDifferenceInUnit("PrevDoseDate", "PatientBirthDate", "$Dose1AdminMinAge_unit"))

define "DiffInMaxAdminUnit":
    Abs(Common.GetDifferenceInUnit("PrevDoseDate", "PatientBirthDate", "$Dose1AdminMaxAge_unit"))




define "AgeFirstMMRIn":
    "DiffInMinAdminUnit" < "$Dose1AdminMinAge" or  "DiffInMaxAdminUnit" > "$Dose1AdminMaxAge"

define "TimeSinceFirstDose":
    Common.GetDifferenceInUnit(MMRVaccineDate(Common."MMR Immunizations")[0].Date, Today(), "$WeeksSinceDose_unit")

define "InPopulation":
    MMR_Vaccine_OneDose and AgeFirstMMRIn and "Current Age In Range" and TimeSinceFirstDose < "$WeeksSinceDose"

 define "Recommendation1":
     if InPopulation then
        'Schedule 2nd dose >= 4 wk of 1st dose'
     else
        null
