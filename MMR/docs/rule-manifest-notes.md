## MMR directory
This directory contains a series of CQL and JSON files representing Clinical Quality Language (CQL) to Expression Logical
Model (ELM) translations for MMR immunization rules. These rules are based on the CDC's recommended immunization
schedules and are designed to provide guidance on MMR vaccination recommendations under various conditions. Each JSON
file defines specific rules, including parameters, contexts, and statements, to evaluate patient data and determine
appropriate immunization actions. The directory leverages FHIR standards and includes necessary library references for
processing immunization and condition data. 

### rule-manifest.json
[`rule-manifest.json`](rule-manifest.json) contains metadata for a set of rules related to MMR (Measles, Mumps, and Rubella) vaccine recommendations. Here's a breakdown of its purpose:

1. **Rule Management**: The file lists multiple rules, each identified by a unique `id`. These rules are likely used in a clinical decision support system to provide recommendations based on patient data.

2. **Library and Version Information**: Each rule entry includes a `libraryName` and `version`, indicating the specific library and version of the rule logic being used. This helps in managing and updating rules as new versions are developed.

3. **File Paths**: The `cqlFilePath` and `elmFilePath` specify the locations of the CQL (Clinical Quality Language) and ELM (Expression Logical Model) files, respectively. These files contain the logic and expressions that define the rule's behavior.

4. **Description and Role**: Each rule has a `description` that explains its purpose, such as providing recommendations for specific age groups or conditions. The `role` indicates whether the rule is a primary rule or a supporting function.

5. **Enabled Status**: The `enabled` field indicates whether a rule is currently active. This allows for easy toggling of rules without removing them from the manifest.

6. **Parameters**: Some rules have `params` that define specific parameters used in the rule logic, such as age ranges or time intervals. These parameters can be adjusted to modify the rule's behavior without changing the underlying code.

