library "MMR2regularyoungerthan12_47monthsNoMMRRecommendation" version '1.0.0'

using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers
include "MMR_Common_Library" version '1.0.0' called Common

context Patient

define "$Age1":
    12

define "$Age1_unit":
    'month'

define "$Age2":
    47

define "$Age2_unit":
    'month'

define "VaccineName":
    'Measles, Mumps, and Rubella Virus Vaccine'

define "Current Age in Lower Limit Units":
  Common.GetAge("$Age1_unit")

define "Current Age in Upper Limit Units":
  Common.GetAge("$Age2_unit")

define "Current Age In Range":
 Common.GetAge("$Age1_unit") >= "$Age1"
    and Common.GetAge("$Age2_unit") < "$Age2"

define "InPopulation":
   "Current Age In Range" and not exists(Common."MMR Immunizations")

define "Recommendation1":
    if InPopulation then
        'Recommendation 1: Administer 1st dose'
    else
        null

define "Recommendation2":
    if InPopulation then
        'Schedule 2nd dose 4-6 yr of age'
    else
        null


define "Recommendation":
    if InPopulation then
        {Recommendation1, Recommendation2}
    else
        null
