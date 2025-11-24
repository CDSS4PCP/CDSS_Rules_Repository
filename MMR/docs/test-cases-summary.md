# MMR Test Cases Summary

**Reference Date:** November 22, 2025

This document provides an overview of all 17 MMR test case patients, organized by clinical scenario to help understand what each test case is validating.

---

## Test Cases by Clinical Scenario

### Scenario 1: Patient Too Young for MMR (<12 months)

**Clinical Context:** MMR vaccine is not recommended before 12 months of age.

| Test Case | Age | Prior Doses | Expected Outcome |
|-----------|-----|-------------|------------------|
| [mmr-rule1-positive](#mmr-rule1-positive) | 1 month | 0 | No recommendation (too young) |
| [mmr-rule1-negative](#mmr-rule1-negative) | 1y 1m | 0 | No recommendation from Rule 1 (just turned 12mo) |

**Notes:**
- `rule1-positive`: Tests that infants under 12 months get no recommendation
- `rule1-negative`: Tests boundary case - child just old enough (13 months)

---

### Scenario 2: First MMR Dose Needed

**Clinical Context:** Children 12 months - 18 years who have never received MMR should get their first dose.

| Test Case | Age | Prior Doses | Expected Outcome |
|-----------|-----|-------------|------------------|
| [mmr-rule4-positive](#mmr-rule4-positive) | 3y 4m | 0 | Recommend 1st dose |

**Notes:**
- `rule4-positive`: Tests SNOMED vaccine code recognition (uses SNOMED code instead of CVX)
- **Coverage Gap:** Missing test cases for other age groups needing first dose (12-15mo, 7-18y, adults)

---

### Scenario 3: Second MMR Dose Needed

**Clinical Context:** Children who received their first dose need a second dose. Timing and interval requirements vary by age and when first dose was given.

#### 3A. Toddlers (12-47 months) Needing 2nd Dose

| Test Case | Age | 1st Dose Given | Age at 1st Dose | Expected Outcome |
|-----------|-----|----------------|-----------------|------------------|
| [mmr-rule5-positive](#mmr-rule5-positive) | 3y 4m | 2023-11-25 | 16 months (in window) | Recommend 2nd dose |
| [mmr-rule5-positive2](#mmr-rule5-positive2) | 3y 4m | 2023-06-25 | 11 months (too early) | Recommend 2nd dose |
| [mmr-rule6-positive](#mmr-rule6-positive) | 3y 4m | 2024-08-05 | 25 months | Recommend 2nd dose |
| [mmr-rule6-positive2](#mmr-rule6-positive2) | 2y 6m | 2024-04-03 | 11 months (too early) | Recommend 2nd dose |

**Notes:**
- Rules 5-6 test different scenarios for when first dose was given (in/out of 12-15 month window)
- First dose given <12 months may need to be repeated
- Minimum interval between doses: 28 days

#### 3B. School-Age Children (4-18 years) Needing 2nd Dose

| Test Case | Age | 1st Dose Given | Age at 1st Dose | Expected Outcome |
|-----------|-----|----------------|-----------------|------------------|
| [mmr-rule7-positive](#mmr-rule7-positive) | 9y 4m | 2022-07-30 | ~6 years | Recommend 2nd dose |
| [mmr-rule8-positive](#mmr-rule8-positive) | 9y 4m | 2024-07-30 | ~8 years | Recommend 2nd dose |

**Notes:**
- Tests catch-up vaccination for school-age children
- Rule 7: First dose given early (around 6 years)
- Rule 8: First dose given late (around 8 years)

---

### Scenario 4: Already Up-to-Date (No Recommendation)

**Clinical Context:** Patients who have received appropriate doses for their age and don't need additional vaccination yet.

#### 4A. Toddlers (12-47 months) with 1 Dose

| Test Case | Age | 1st Dose Given | Age at 1st Dose | Expected Outcome |
|-----------|-----|----------------|-----------------|------------------|
| [mmr-rule2-positive](#mmr-rule2-positive) | 3y 4m | 2023-08-12 | 13 months | No recommendation (too young for 2nd dose) |

**Notes:**
- Child is 12-47 months with one dose - still in acceptable window before 2nd dose at 4-6 years

#### 4B. School-Age Children (47 months - 18 years) with 1 Dose

| Test Case | Age | 1st Dose Given | Age at 1st Dose | Expected Outcome |
|-----------|-----|----------------|-----------------|------------------|
| [mmr-rule3-positive](#mmr-rule3-positive) | 9y 4m | 2023-08-12 | ~7 years | No recommendation |

**Notes:**
- Child 4-18 years with existing dose
- **Unclear:** Why is this "no recommendation" instead of "recommend 2nd dose"? May indicate rule logic issue.

---

### Scenario 5: Contraindications - Pregnancy

**Clinical Context:** MMR vaccine is **contraindicated during pregnancy** (live virus vaccine). Women should avoid pregnancy for 28 days after vaccination.

| Test Case | Age | Prior Doses | Condition | Expected Outcome |
|-----------|-----|-------------|-----------|------------------|
| [mmr-rule9-positive](#mmr-rule9-positive) | 27y 4m | 0 | Pregnant | Contraindication |
| [mmr-rule10-positive](#mmr-rule10-positive) | 27y 4m | 1 (at 24y) | Pregnant | Contraindication |

**Notes:**
- Rule 9: Pregnant with no doses - contraindicated
- Rule 10: Pregnant with incomplete series (1 dose) - still contraindicated, must wait until after delivery

---

### Scenario 6: Contraindications - Immunocompromised Conditions

**Clinical Context:** Live virus vaccines like MMR are contraindicated in severely immunocompromised patients.

#### 6A. Lymphoma/Cancer

| Test Case | Age | Prior Doses | Condition | Expected Outcome |
|-----------|-----|-------------|-----------|------------------|
| [mmr-rule11-positive](#mmr-rule11-positive) | 27y 4m | 0 | Mantle cell lymphoma | Contraindication |

**Notes:**
- Active lymphoma is absolute contraindication for MMR

#### 6B. HIV with Severe Immunosuppression

| Test Case | Age | Prior Doses | Lab Results | Expected Outcome |
|-----------|-----|-------------|-------------|------------------|
| [mmr-rule12-positive](#mmr-rule12-positive) | 27y 4m | 0 | HIV diagnosis | Special consideration |
| [mmr-rule12-positive2](#mmr-rule12-positive2) | 27y 4m | 0 | CD4 100 cells/mm³ | Contraindication (CD4 <200) |
| [mmr-rule12-positive3](#mmr-rule12-positive3) | 27y 4m | 0 | CD4 10% | Contraindication (CD4% <15%) |

**Notes:**
- Rule 12: HIV patients can receive MMR **if** CD4 count adequate
- Rule 12-positive2: CD4 <200 cells/mm³ → Contraindication
- Rule 12-positive3: CD4 percentage <15% → Contraindication
- HIV patients with CD4 ≥200 cells/mm³ AND ≥15% may receive MMR

---

## Coverage Gaps and Missing Test Cases

### Missing Scenarios:

1. **Complete vaccination series:**
   - ❌ Child or adult with 2 valid doses → No recommendation needed

2. **Optimal timing examples:**
   - ❌ Child 12-15 months receiving 1st dose (primary schedule)
   - ❌ Child 4-6 years receiving 2nd dose (school entry requirement)

3. **Edge cases:**
   - ❌ Child exactly 12 months old (birthday)
   - ❌ Child exactly 4 years old (transition point)
   - ❌ Doses given <28 days apart (minimum interval violation)

4. **Adult catch-up scenarios:**
   - ❌ Adult (19+) with 0 doses → Recommend 1st dose
   - ❌ Adult (19+) with 1 dose → Recommend 2nd dose

5. **Invalid dose handling:**
   - ❌ Doses given before 12 months - should they count?

---

## Detailed Test Case Information

### mmr-rule1-negative
**Scenario:** Patient too young (<12 months) - boundary case
**Patient Age:** 1 year 1 month (born 2024-10-20)
**MMR Doses:** 0
**Conditions:** None
**Notes:** Just old enough for first MMR dose
**Expected:** Rule 1 does NOT fire (patient is 13 months, old enough)

---

### mmr-rule1-positive
**Scenario:** Patient too young (<12 months)
**Patient Age:** 1 month (born 2025-10-20)
**MMR Doses:** 0
**Conditions:** None
**Notes:** Age 11 months, no MMR vaccine
**Expected:** Rule 1 FIRES - no recommendation, too young

---

### mmr-rule2-positive
**Scenario:** Toddler with 1 dose, up-to-date
**Patient Age:** 3 years 4 months (born 2022-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2023-08-12 (patient age 13 months)

**Conditions:** None
**Notes:** Had first MMR age 13 months
**Expected:** Rule 2 FIRES - no additional recommendation (child 12-47mo with 1 dose)

---

### mmr-rule3-positive
**Scenario:** School-age child with 1 dose
**Patient Age:** 9 years 4 months (born 2016-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2023-08-12 (patient age 85 months / ~7 years)

**Conditions:** None
**Notes:** Age 9 years, had first MMR at age 7 years
**Expected:** Rule 3 FIRES - no recommendation (child 47mo-18y with 1+ doses)
**Question:** Why no 2nd dose recommendation? Seems like coverage gap.

---

### mmr-rule4-positive
**Scenario:** First dose needed
**Patient Age:** 3 years 4 months (born 2022-07-12)
**MMR Doses:** 0
**Conditions:** None
**Notes:** Tests SNOMED vaccine code recognition
**Expected:** Rule 4 FIRES - recommend 1st dose for child 12mo-4y with 0 doses

---

### mmr-rule5-positive
**Scenario:** Second dose needed - 1st dose in 12-15mo window
**Patient Age:** 3 years 4 months (born 2022-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2023-11-25 (patient age 16 months - **within 12-15mo window**)

**Conditions:** None
**Expected:** Rule 5 FIRES - recommend 2nd dose (1st dose was on-time)

---

### mmr-rule5-positive2
**Scenario:** Second dose needed - 1st dose outside 12-15mo window
**Patient Age:** 3 years 4 months (born 2022-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2023-06-25 (patient age 11 months - **before 12-15mo window**)

**Conditions:** None
**Expected:** Rule 5 FIRES - recommend 2nd dose (1st dose was early)

---

### mmr-rule6-positive
**Scenario:** Second dose needed - timing test
**Patient Age:** 3 years 4 months (born 2022-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2024-08-05 (patient age 25 months)

**Conditions:** None
**Expected:** Rule 6 FIRES - recommend 2nd dose

---

### mmr-rule6-positive2
**Scenario:** Second dose needed - younger patient
**Patient Age:** 2 years 6 months (born 2023-05-30)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2024-04-03 (patient age 11 months)

**Conditions:** None
**Expected:** Rule 6 FIRES - recommend 2nd dose

---

### mmr-rule7-positive
**Scenario:** School-age 2nd dose - early 1st dose
**Patient Age:** 9 years 4 months (born 2016-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2022-07-30 (patient age 72 months / ~6 years)

**Conditions:** None
**Expected:** Rule 7 FIRES - recommend 2nd dose for child 4-18y with 1 dose

---

### mmr-rule8-positive
**Scenario:** School-age 2nd dose - late 1st dose
**Patient Age:** 9 years 4 months (born 2016-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2024-07-30 (patient age 96 months / ~8 years)

**Conditions:** None
**Expected:** Rule 8 FIRES - recommend 2nd dose for child 4-18y with 1 dose

---

### mmr-rule9-positive
**Scenario:** Contraindication - pregnancy, no doses
**Patient Age:** 27 years 4 months (born 1998-07-12)
**MMR Doses:** 0
**Conditions:**
- Single pregnancy (finding) - SNOMED 237244005

**Expected:** Rule 9 FIRES - contraindication due to pregnancy

---

### mmr-rule10-positive
**Scenario:** Contraindication - pregnancy, incomplete series
**Patient Age:** 27 years 4 months (born 1998-07-12)
**MMR Doses:** 1
**Dose History:**
- Dose 1: 2022-07-30 (patient age 288 months / ~24 years)

**Conditions:**
- Single pregnancy (finding) - SNOMED 237244005

**Expected:** Rule 10 FIRES - contraindication due to pregnancy (needs 2nd dose but must wait)

---

### mmr-rule11-positive
**Scenario:** Contraindication - immunocompromised (lymphoma)
**Patient Age:** 27 years 4 months (born 1998-07-12)
**MMR Doses:** 0
**Conditions:**
- Mantle cell lymphoma, lymph nodes of multiple sites - ICD-9 200.48

**Expected:** Rule 11 FIRES - contraindication due to immunocompromised state

---

### mmr-rule12-positive
**Scenario:** Special consideration - HIV
**Patient Age:** 27 years 4 months (born 1998-07-12)
**MMR Doses:** 0
**Conditions:**
- Human immunodeficiency virus infection (disorder) - SNOMED 86406008

**Expected:** Rule 12 FIRES - HIV patients may receive MMR if CD4 adequate

---

### mmr-rule12-positive2
**Scenario:** Contraindication - HIV with low CD4 count
**Patient Age:** 27 years 4 months (born 1998-07-12)
**MMR Doses:** 0
**Conditions:** None (implied HIV)
**Laboratory Results:**
- CD3+CD4+ (T4 helper) cells [#/volume] in Blood: **100 /mm³**

**Expected:** Rule 12 FIRES - contraindication, CD4 count <200 cells/mm³ threshold

---

### mmr-rule12-positive3
**Scenario:** Contraindication - HIV with low CD4 percentage
**Patient Age:** 27 years 4 months (born 1998-07-12)
**MMR Doses:** 0
**Conditions:** None (implied HIV)
**Laboratory Results:**
- CD3+CD4+ (T4 helper) cells/100 cells in Blood: **10%**

**Expected:** Rule 12 FIRES - contraindication, CD4 percentage <15% threshold

---

## Summary Statistics

### By Age Group
- **Infants (<12 months):** 1 test case
- **Toddlers (12-47 months):** 7 test cases
- **Children (4-18 years):** 3 test cases
- **Adults (>18 years):** 6 test cases

### By Vaccination Status
- **No prior MMR doses:** 8 test cases
- **1 prior MMR dose:** 9 test cases
- **2+ prior MMR doses:** 0 test cases ⚠️ **Coverage Gap**

### By Clinical Scenario
- **Too young for vaccine:** 2 test cases (rules 1)
- **First dose needed:** 1 test case (rule 4)
- **Second dose needed:** 6 test cases (rules 5-8)
- **Up-to-date, no action:** 2 test cases (rules 2-3)
- **Contraindications:** 6 test cases (rules 9-12)

---

## Notes on "Positive" vs "Negative" Terminology

**Important:** The terms "positive" and "negative" in test case names refer to whether the **rule fires**, NOT whether the outcome is clinically positive:

- **"positive"** = Test case where the rule **FIRES** (returns true/matches criteria)
- **"negative"** = Test case where the rule **DOES NOT FIRE**

**Example:**
- `mmr-rule1-positive`: Rule fires saying "no recommendation" (patient too young)
- `mmr-rule1-negative`: Rule does NOT fire (patient old enough for different rule)

This can be counter-intuitive! See [test-case-naming-analysis.md](test-case-naming-analysis.md) for detailed explanation.

---

## Notes on Date Calculations

All ages are calculated as of **November 22, 2025**.

When a dose date is shown with patient age, this represents the age at vaccination calculated from birth date to vaccination date.

---

*This document was reorganized to group test cases by clinical scenario for easier understanding. For the original rule-number-based organization, see git history. Auto-generated portions created by `scripts/generate-test-summary.js`*
