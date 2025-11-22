library "MMR7regular4_18yrs_OneDoseRecommendation" version '1.0.0'

include "MMR_Common_Library" version '1.0.0' called Common
using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers


context Patient

define "$Age1": 4
define "$Age1_unit": 'year'
define "$Age2": 18
define "$Age2_unit": 'year'
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

define "WeeksFromFirstDose":
	(difference in weeks between  PrevDoseDate and Today() )

define "TimeSinceFirstDose":
    Common.GetDifferenceInUnit(MMRVaccineDate(Common."MMR Immunizations")[0].Date, Today(), "$WeeksSinceDose_unit")

define "InPopulation":
    "Current Age In Range" and MMR_Vaccine_OneDose and TimeSinceFirstDose < "$WeeksSinceDose"


define "Recommendation1":
    if InPopulation then
        'Administer 2nd dose MMR'
    else
        null

