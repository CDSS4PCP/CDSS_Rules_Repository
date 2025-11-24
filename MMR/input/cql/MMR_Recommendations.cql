library "MMR_Recommendations" version '1.0.0'

using FHIR version '4.0.1'

include "FHIRHelpers" version '4.0.1' called FHIRHelpers
include "MMR_Common_Library" version '1.0.0' called Common

// Include all MMR rule libraries
include "MMR1regularyoungerthan12monthsNoMMRRecommendation" version '1.0.0' called Rule1
include "MMR2regularyoungerthan12_47monthsNoMMRRecommendation" version '1.0.0' called Rule2
include "MMR3regularyoungerthan47months_18yrsNoMMRRecommendation" version '1.0.0' called Rule3
include "MMR4regular12months_4yrs_OneMMRRecommendation" version '1.0.0' called Rule4
include "MMR5regular12months_4yrs_OneDoseOutOf12to15MonRecommendation" version '1.0.0' called Rule5
include "MMR6regular12months_4yrs_OneDoseOutOf12to15MonRecommendation" version '1.0.0' called Rule6
include "MMR7regular4_18yrs_OneDoseRecommendation" version '1.0.0' called Rule7
include "MMR8regular4_18yrs_OneDoseRecommendation" version '1.0.0' called Rule8
include "MMR9MedicalContraPrecautionMMRRecommendation" version '1.0.0' called Rule9
include "MMR10MedicalContraPrecautionMMRRecommendation" version '1.0.0' called Rule10
include "MMR11MedicalContraPrecautionMMRRecommendation_Immunocompromised" version '1.0.0' called Rule11
include "MMR12MedicalContraPrecautionMMRRecommendation_HIVImmunocompromised" version '1.0.0' called Rule12

context Patient

// Aggregate all recommendations from all rules
define "AllRecommendations":
  (
    {
      Rule1."Recommendation 1",
      Rule1."Recommendation 2",
      Rule2."Recommendation 1",
      Rule2."Recommendation 2",
      Rule3."Recommendation 1",
      Rule3."Recommendation 2",
      Rule4.Recommendation1,
      Rule5.Recommendation1,
      Rule6.Recommendation1,
      Rule7.Recommendation1,
      Rule8.Recommendation1,
      Rule9.Recommendation1,
      Rule9.Recommendation2,
      Rule10.Recommendation1,
      Rule11.Recommendation1,
      Rule12.Recommendation1
    }
  ) R where R is not null

// Which rules apply to this patient
define "ApplicableRules":
  (
    {
      if Rule1."In Population" then 'Rule1: Regular <12 months, no MMR' else null,
      if Rule2."In Population" then 'Rule2: Regular 12-47 months, no MMR' else null,
      if Rule3."In Population" then 'Rule3: Regular 47 months-18 years, no MMR' else null,
      if Rule4.InPopulation then 'Rule4: Regular 12 months-4 years, one MMR' else null,
      if Rule5.InPopulation then 'Rule5: Regular 12 months-4 years, one dose (12-15 mon)' else null,
      if Rule6.InPopulation then 'Rule6: Regular 12 months-4 years, one dose variant' else null,
      if Rule7.InPopulation then 'Rule7: Regular 4-18 years, one dose' else null,
      if Rule8.InPopulation then 'Rule8: Regular 4-18 years, one dose variant' else null,
      if Rule9.InPopulation then 'Rule9: Contraindication - Pregnant' else null,
      if Rule10.InPopulation then 'Rule10: Contraindication - Pregnant (one dose)' else null,
      if Rule11.InPopulation then 'Rule11: Contraindication - Immunocompromised' else null,
      if Rule12.InPopulation then 'Rule12: Contraindication - HIV/Immunocompromised' else null
    }
  ) R where R is not null

// Summary for dashboard/alerts
define "HasRecommendations":
  Count(AllRecommendations) > 0

define "RecommendationCount":
  Count(AllRecommendations)
