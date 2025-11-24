# MMR Test Case Naming Analysis

## Current Naming System Problems

### Issue 1: Confusing "Positive" and "Negative" terminology

**Current usage appears to mean:**
- **"positive"** = Test case where the rule **fires** (returns true/matches criteria)
- **"negative"** = Test case where the rule **does NOT fire**

**Example:**
- `mmr-rule1-positive`: 1 month old, 0 doses → Rule fires saying "No recommendation (<12 months)"
- `mmr-rule1-negative`: 13 months old, 0 doses → Rule does NOT fire (different rule would fire)

**Problem:** This is counter-intuitive! "Positive" sounds like a good outcome (vaccine given), but it actually means "the no-recommendation rule matched."

### Issue 2: Unclear Rule Numbering Logic

The rules don't follow a clear progression:

| Rule # | Library Name | What it tests |
|--------|--------------|---------------|
| 1 | `MMR1regularyoungerthan12monthsNoMMRRecommendation` | Too young (<12mo) → No rec |
| 2 | `MMR2regularyoungerthan12_47monthsNoMMRRecommendation` | 12-47mo with dose → No rec |
| 3 | `MMR3regularyoungerthan47months_18yrsNoMMRRecommendation` | 47mo-18y with dose → No rec |
| 4 | `MMR4regular12months_4yrs_OneMMRRecommendation` | 12mo-4y, 0 doses → Rec 1st dose |
| 5 | `MMR5regular12months_4yrs_OneDoseOutOf12to15MonRecommendation` | 12mo-4y, 1 dose IN window → Rec 2nd |
| 6 | `MMR6regular12months_4yrs_OneDoseOutOf12to15MonRecommendation` | 12mo-4y, 1 dose OUT window → Rec 2nd |
| 7 | `MMR7regular4_18yrs_OneDoseRecommendation` | 4-18y, 1 dose → Rec 2nd |
| 8 | `MMR8regular4_18yrs_OneDoseRecommendation` | 4-18y, 1 dose → Rec 2nd |
| 9 | `MMR9MedicalContraPrecautionMMRRecommendation` | Pregnancy contraindication |
| 10 | `MMR10MedicalContraPrecautionMMRRecommendation` | Pregnancy + incomplete series |
| 11 | `MMR11MedicalContraPrecautionMMRRecommendation_Immunocompromised` | Lymphoma contraindication |
| 12 | `MMR12MedicalContraPrecautionMMRRecommendation_HIVImmunocompromised` | HIV contraindication |

**Pattern observed:**
- Rules 1-3: "No recommendation" for various age/dose combinations
- Rules 4-8: Recommendations for doses (organized by age groups)
- Rules 9-12: Contraindications/precautions

### Issue 3: Duplicative Rule Names

Rules 5 & 6 have identical library names despite testing different scenarios:
- Rule 5: First dose **IN** 12-15 month window
- Rule 6: First dose **OUT OF** 12-15 month window

Rules 7 & 8 also have identical library names (testing different timing of first dose).

---

## Recommended Logical Organization (If Starting From Scratch)

### Option A: CDC Schedule Order (Age-Based)

Organize by patient age progression and vaccination status:

```
1. Infant <12 months, 0 doses         → No recommendation (too young)
2. Child 12-15 months, 0 doses        → Recommend 1st dose
3. Child 12-15 months, 1 dose         → No recommendation (too soon for 2nd)
4. Child 16-47 months, 0 doses        → Recommend 1st dose (catch-up)
5. Child 16-47 months, 1 dose on time → Recommend 2nd dose
6. Child 16-47 months, 1 dose early   → Recommend 2nd dose (redo early dose)
7. Child 4-6 years, 0 doses           → Recommend 1st dose (catch-up)
8. Child 4-6 years, 1 dose            → Recommend 2nd dose (school entry)
9. Child 7-18 years, 0 doses          → Recommend 1st dose (catch-up)
10. Child 7-18 years, 1 dose          → Recommend 2nd dose (catch-up)
11. Child 7-18 years, 2 doses         → No recommendation (complete)
12. Adult, 0 doses                    → Recommend 1st dose
13. Adult, 1 dose                     → Recommend 2nd dose
14. Adult, 2 doses                    → No recommendation (complete)
15. Pregnant, any doses               → Contraindication
16. Immunocompromised, any doses      → Contraindication/Special
17. HIV (CD4 <200), any doses         → Contraindication
18. HIV (CD4 ≥200), any doses         → Consider vaccination
```

### Option B: Decision Tree Order (Clinical Logic)

Organize by how a clinician would think:

```
Group A: Exclusions First
1. Pregnant                           → Contraindication
2. Immunocompromised (lymphoma)       → Contraindication
3. HIV with CD4 <200                  → Contraindication
4. HIV with CD4% <15%                 → Contraindication

Group B: Age Too Young
5. <12 months                         → No recommendation (too young)

Group C: First Dose Recommendations
6. 12-15 months, 0 doses              → Recommend 1st dose (primary schedule)
7. 16 months - 4 years, 0 doses       → Recommend 1st dose (catch-up)
8. 4-18 years, 0 doses                → Recommend 1st dose (catch-up)
9. Adult, 0 doses                     → Recommend 1st dose (catch-up)

Group D: Second Dose Recommendations
10. 4-6 years, 1 dose in window       → Recommend 2nd dose (primary schedule)
11. 4-6 years, 1 dose early           → Recommend 2nd dose (redo early dose)
12. 7-18 years, 1 dose                → Recommend 2nd dose (catch-up)
13. Adult, 1 dose                     → Recommend 2nd dose (catch-up)

Group E: Complete Series
14. Any age, 2+ valid doses           → No recommendation (complete)
```

---

## Understanding Current Test Cases

Here's what each existing test case is actually testing:

### **No Recommendation Rules (Rules 1-3)**

**Rule 1: Too young for any vaccine**
- `mmr-rule1-negative`: Age 13mo, 0 doses → Rule does NOT fire (old enough now)
- `mmr-rule1-positive`: Age 1mo, 0 doses → Rule FIRES (too young)

**Rule 2: Young child with existing dose**
- `mmr-rule2-positive`: Age 3y4m, 1 dose at 13mo → Rule FIRES (has dose, wait for 4-6y window)

**Rule 3: Older child with existing dose**
- `mmr-rule3-positive`: Age 9y4m, 1 dose at 7y → Rule FIRES (has dose already)

### **First Dose Recommendation (Rule 4)**

**Rule 4: Child ready for first dose**
- `mmr-rule4-positive`: Age 3y4m, 0 doses → Rule FIRES (recommend 1st dose)
  - *Note: Uses SNOMED vaccine code to test code system recognition*

### **Second Dose Recommendations (Rules 5-8)**

**Rule 5: Second dose after on-time first dose**
- `mmr-rule5-positive`: Age 3y4m, 1 dose at 16mo (IN 12-15mo window) → Rec 2nd
- `mmr-rule5-positive2`: Age 3y4m, 1 dose at 11mo (OUT OF window) → Rec 2nd

**Rule 6: Second dose timing tests**
- `mmr-rule6-positive`: Age 3y4m, 1 dose at 25mo → Rec 2nd
- `mmr-rule6-positive2`: Age 2y6m, 1 dose at 11mo → Rec 2nd

**Rule 7: School-age child, early first dose**
- `mmr-rule7-positive`: Age 9y4m, 1 dose at 6y → Rec 2nd

**Rule 8: School-age child, late first dose**
- `mmr-rule8-positive`: Age 9y4m, 1 dose at 8y → Rec 2nd

### **Contraindication/Precaution Rules (Rules 9-12)**

**Rule 9: Pregnancy, no doses**
- `mmr-rule9-positive`: Age 27y, pregnant, 0 doses → Contraindication

**Rule 10: Pregnancy, incomplete series**
- `mmr-rule10-positive`: Age 27y, pregnant, 1 dose → Contraindication

**Rule 11: Immunocompromised**
- `mmr-rule11-positive`: Age 27y, lymphoma, 0 doses → Contraindication

**Rule 12: HIV with low CD4**
- `mmr-rule12-positive`: Age 27y, HIV diagnosis, 0 doses → Special consideration
- `mmr-rule12-positive2`: Age 27y, CD4 100/mm³ → Contraindication (CD4 <200)
- `mmr-rule12-positive3`: Age 27y, CD4 10% → Contraindication (CD4% <15%)

---

## Coverage Gaps in Current Test Suite

Based on your "logical from scratch" suggestion, here are notable gaps:

### Missing Test Cases:

1. **Complete series scenarios:**
   - ❌ Child/Adult with 2 valid doses → No recommendation needed

2. **Optimal timing scenarios:**
   - ❌ Child 12-15 months getting 1st dose → Document expected timing
   - ❌ Child 4-6 years getting 2nd dose → Document school entry requirement

3. **Edge cases:**
   - ❌ Child exactly 12 months old (birthday)
   - ❌ Child exactly 4 years old (transition between age groups)
   - ❌ Dose given 1 day too early (minimum interval testing)
   - ❌ Adult with recent measles exposure (different recommendation)

4. **Invalid dose scenarios:**
   - ❌ Doses given <12 months (should they count?)
   - ❌ Doses given <28 days apart (minimum interval)

---

## Recommendations for Your Situation

Since you're working with an existing test suite (not building from scratch), here are practical options:

### Option 1: Create a Mapping Document (Easiest)

Add to `docs/test-case-naming-analysis.md` a clear mapping:
```markdown
## Quick Translation Guide

| Current Name | Better Name | What It Tests |
|--------------|-------------|---------------|
| mmr-rule1-positive | infant-too-young | <12mo, no rec |
| mmr-rule4-positive | toddler-first-dose | 12-47mo, 0 doses, rec 1st |
| ...
```

### Option 2: Add Aliases/Symlinks (Medium effort)

Create descriptive symlinks:
```bash
ln -s mmr-rule1-positive infant-under-12mo-no-rec
ln -s mmr-rule4-positive toddler-needs-first-dose
```

### Option 3: Rename Test Cases (Highest effort, most disruptive)

Only do this if:
- You have permission to restructure
- You're willing to update all references
- The test harness supports it

### Option 4: Document and Extend (Recommended)

1. **Keep existing test cases as-is** (don't break existing references)
2. **Add the mapping document** (Option 1)
3. **Add new test cases** with better names for missing scenarios
4. **Update test-cases-summary.md** to group by clinical scenario

---

## Proposed Enhanced Summary Table Format

Update `test-cases-summary.md` to group by clinical logic instead of rule number:

```markdown
## Test Cases by Clinical Scenario

### Scenario 1: Patient Too Young for MMR
- `mmr-rule1-positive`: 1 month old → No recommendation

### Scenario 2: First Dose Needed
- `mmr-rule4-positive`: 3y4m, never vaccinated → Recommend 1st dose

### Scenario 3: Second Dose Needed
- `mmr-rule5-positive`: 3y4m, had 1st at 16mo → Recommend 2nd dose
- `mmr-rule6-positive`: 3y4m, had 1st at 25mo → Recommend 2nd dose
- `mmr-rule7-positive`: 9y4m, had 1st at 6y → Recommend 2nd dose

### Scenario 4: Contraindications
- `mmr-rule9-positive`: Pregnant → Contraindication
- `mmr-rule11-positive`: Lymphoma → Contraindication
- `mmr-rule12-positive2`: HIV with CD4 <200 → Contraindication
```

---

## Next Steps

Would you like me to:

1. **Create the mapping/translation document** showing current names → logical names?
2. **Reorganize test-cases-summary.md** by clinical scenario instead of rule number?
3. **Identify specific missing test cases** you should add?
4. **Generate a script** to create symlinks with descriptive names?

Let me know which approach works best for your situation!
