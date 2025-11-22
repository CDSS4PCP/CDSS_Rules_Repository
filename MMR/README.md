# MMR (Measles, Mumps, Rubella) Clinical Decision Support Rules

This directory contains FHIR-based Clinical Decision Support (CDS) rules for MMR vaccination recommendations, implemented as a FHIR Implementation Guide with embedded CQL (Clinical Quality Language).

The rules are based on the CDC's recommended immunization schedules and provide guidance on MMR vaccination recommendations under various conditions. Each rule evaluates patient data using FHIR standards to determine appropriate immunization actions.

## Project Structure

This project follows the [sample-content-ig](https://github.com/cqframework/sample-content-ig) structure for FHIR Implementation Guides:

```
MMR/
├── input/
│   ├── cql/                           # CQL logic files
│   ├── tests/
│   │   └── MMR_Recommendations/       # Test patient bundles
│   └── vocabulary/
│       └── ValueSet/
│           └── external/              # External ValueSets (1.5MB, committed for reproducibility)
├── input-cache/                       # IG Publisher tooling (auto-generated, mostly ignored)
│   ├── txcache/                       # Terminology cache (kept in repo)
│   └── *.jar                          # Publisher JARs (ignored, downloaded via _refresh.sh)
├── output/                            # Generated IG output (ignored)
├── docs/                              # Additional documentation
│   └── rule-manifest-notes.md         # Details about rule-manifest.json
├── _refresh.sh                        # Build script
├── ig.ini                             # IG configuration
└── rule-manifest.json                 # Rule metadata and configuration
```

## Getting Started

### Prerequisites

- Java 11 or higher
- Internet connection (for first-time setup)

### First-Time Setup

The IG Publisher tooling JARs are not committed to the repository. Run the refresh script to download required tooling:

```bash
cd MMR
./_refresh.sh
```

This will populate `input-cache/` with:
- `tooling-cli-3.8.0.jar` (~100MB)
- `publisher.jar` (~200MB)
- `validator_cli.jar` (~170MB)
- FHIR schemas for validation

### Building the Implementation Guide

After initial setup, run `_refresh.sh` to rebuild the IG after making changes to CQL or FHIR resources:

```bash
./_refresh.sh
```

The generated Implementation Guide will be available in `output/`.

## Rule Management

### rule-manifest.json

The `rule-manifest.json` file contains metadata for the MMR vaccine recommendation rules, including rule IDs, library names, versions, file paths, descriptions, enabled status, and parameters.

See [docs/rule-manifest-notes.md](docs/rule-manifest-notes.md) for detailed information about the rule manifest structure.

## CQL Logic Files

The CQL files in `input/cql/` contain the clinical logic for MMR vaccination recommendations. These files define specific rules with parameters, contexts, and statements to evaluate patient data.

**Key improvements in this version:**
- ✅ Fixed Common library syntax issues
- ✅ Corrected FHIR resource handling for QI-Core profiles
- ✅ Updated to use proper FHIR R4 patterns

## Test Data

### Test Patient Bundles

Test patient bundles in `input/tests/MMR_Recommendations/` were derived from the [CDSS Testing Harness](https://github.com/CDSS4PCP/cdss-testing-harness) repository. Original bundles were modified to conform to the sample-content-ig directory structure requirements.

### External ValueSets

External ValueSets are included in `input/vocabulary/ValueSet/external/` (1.5MB total) to ensure:
- ✅ Reproducible builds without external dependency fetching
- ✅ Offline development and testing capability
- ✅ Consistent CQL evaluation across different environments
- ✅ Stable behavior independent of external terminology server changes

## Development Workflow

1. Make changes to CQL files in `input/cql/`
2. Update test cases in `input/tests/MMR_Recommendations/` if needed
3. Update `rule-manifest.json` if adding/modifying rules
4. Run `./_refresh.sh` to rebuild and validate
5. Review output in `output/` directory
6. Test with sample patient data
7. Commit changes (excluding `output/`, `temp/`, and `*.jar` files)

## Related Resources

- [sample-content-ig](https://github.com/cqframework/sample-content-ig) - Template structure
- [CDSS Testing Harness](https://github.com/CDSS4PCP/cdss-testing-harness) - Test data source
- [CQL Specification](https://cql.hl7.org/)
- [QI-Core Implementation Guide](http://hl7.org/fhir/us/qicore/)
- [FHIR R4 Specification](http://hl7.org/fhir/R4/)

## Contributing

When submitting changes:
1. Ensure `./_refresh.sh` runs without errors
2. Include test cases demonstrating the changes
3. Update `rule-manifest.json` if modifying rules
4. Update this README if adding new functionality or changing structure
5. Verify all CQL files compile to valid ELM

## Questions?

Contact the CDSS4PCP team or open an issue in the repository.
