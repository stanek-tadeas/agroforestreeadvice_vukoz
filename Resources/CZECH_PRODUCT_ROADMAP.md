# Czech Product Roadmap

## Scope

This roadmap covers the Czech tree selection tool only. It assumes the current Shiny application architecture remains in place and focuses on improving beginner adoption, decision quality, and practical field usage.

## Product Vision

Make the Czech tool the default first-stop decision aid for beginners who want to choose trees and shrubs for agroforestry in Czech conditions, with outputs that are easy to understand, legally aware, and useful in real farm planning.

## Primary Users

- Beginner farmers exploring agroforestry for the first time.
- Advisors supporting farm design, subsidy preparation, and species selection.
- Teachers, students, and demonstration farms introducing agroforestry options.

## Product Goals

1. Reduce the knowledge barrier for first-time users.
2. Make recommendations easier to interpret and trust.
3. Expand the tool from single-query ranking to planning support.
4. Keep Czech policy and species data credible and maintainable.

## Non-Goals

- Replacing expert advisory visits for final planting design.
- Building a full farm management platform.
- Rewriting the whole application stack before user-value improvements are delivered.

## Current Product Constraints

- The tool already has strong Czech-specific data, but much of the value is hidden behind expert terminology.
- Hard filters are powerful but can silently exclude many species.
- Results are ranked well, but explanations for why a species was recommended are limited.
- The current UI is stronger on desktop than on mobile or tablet.

## Roadmap Themes

### Theme 1: Beginner Onboarding

Goal: make the first successful session possible without prior agroforestry knowledge.

Key outcomes:

- Users understand what to fill in on the left versus the right.
- Users can start from a preset instead of a blank form.
- Users understand which filters are strict and which are preference-based.

### Theme 2: Explainable Recommendations

Goal: help users understand why a species appears in the results and what tradeoffs are involved.

Key outcomes:

- Each top result includes short plain-language reasons.
- Users can see whether a species is excluded by regulation, subsidy, or site mismatch.
- Users can distinguish "not subsidized" from "not suitable".

### Theme 3: Planning Workflows

Goal: move from one-off ranking to repeatable farm planning.

Key outcomes:

- Users can compare scenarios.
- Users can export outputs that are useful in meetings and field planning.
- Advisors can reuse the tool in workshops and consultations.

### Theme 4: Czech Data Expansion

Goal: broaden coverage and keep the Czech dataset useful as conditions and regulations change.

Key outcomes:

- Better coverage of shrubs, understorey species, and region-specific options.
- Better handling of cultivars and supplementary species.
- Clear update process for subsidy and legal status fields.

## Phased Roadmap

## Phase 1: Remove First-Use Friction

Target window: 0 to 2 months

Objective: improve first-use success without changing the scoring model.

Planned items:

1. Add a Czech-specific intro panel above the filters.
2. Add a short explanation of "Your site" versus "Your objectives".
3. Add explicit messaging for hard filters and subsidy-based exclusions.
4. Finish and standardize tooltips for all Czech controls.
5. Add empty-state guidance before users click "Compare Trees".
6. Add a simple beginner glossary for terms like BPEJ, habitus, coppicing, and understorey.

Success criteria:

- New users can complete a first query without outside help.
- Fewer support questions about missing species or subsidy logic.
- Higher proportion of sessions that reach a computed result.

Suggested implementation touchpoints:

- `R/Tabinterface.R`
- `models/interfaceCzech.txt`
- `Resources/Tooltips.txt`
- `ui.R`

## Phase 2: Make Recommendations Explainable

Target window: 2 to 4 months

Objective: turn ranked outputs into understandable recommendations.

Planned items:

1. Add a "Why recommended" summary for top species.
2. Add simple exclusion messages such as "excluded by subsidy filter" or "outside altitude range".
3. Show key strengths per species, for example fruit, fodder, drought tolerance, understorey suitability.
4. Surface the most important caution notes from the Czech dataset in plain language.
5. Clarify legal and endangered-species flags in the additional information table.

Success criteria:

- Users can explain why the top species were shown.
- Advisors can use the output directly in consultations.
- Fewer misinterpretations of hard-filtered results.

Suggested implementation touchpoints:

- `R/suitability_Czech.R`
- `R/Tabinterface.R`
- `models/dataCzech.txt`
- `models/interfaceCzech.txt`

## Phase 3: Add Guided Entry Points

Target window: 1 to 2 quarters

Objective: let beginners start from common Czech agroforestry use cases instead of manual filter selection.

Planned items:

1. Add presets such as:
   - fruit for family use
   - trees for grazing systems
   - subsidy-safe starter list
   - dry and warm site species
   - biodiversity hedge and shelterbelt
2. Add a farm-type selector that reveals the most relevant filters.
3. Add a "recommended next filters" prompt after a preset is chosen.
4. Add sample scenarios for workshops and teaching.

Success criteria:

- Faster time to first useful shortlist.
- Higher usage by beginners and students.
- Better repeatability in workshops.

Suggested implementation touchpoints:

- `R/Tabinterface.R`
- `server.R`
- `ui.R`

## Phase 4: Support Real Planning Work

Target window: 2 to 3 quarters

Objective: make the tool practical for comparing options and documenting decisions.

Planned items:

1. Save and compare multiple scenarios in one session.
2. Add side-by-side comparison of top species across scenarios.
3. Create printable one-page species summaries for the top results.
4. Add a compact advisor export with selected filters, ranked results, and key notes.
5. Improve mobile and tablet usability for field or workshop use.

Success criteria:

- Users run multiple scenarios in one session.
- Exported outputs are reused in consultations and grant preparation.
- Better usability on tablets and smaller screens.

Suggested implementation touchpoints:

- `DownloadHandler.R`
- `R/Tabinterface.R`
- `server.R`
- `www/`

## Phase 5: Expand Czech Data Coverage

Target window: 2 to 4 quarters

Objective: broaden the Czech model so it supports more realistic farm choices.

Planned items:

1. Expand shrubs and understorey species coverage.
2. Add region-aware notes for colder, wetter, warmer, and drier Czech conditions.
3. Add cultivar or variety support where practically useful.
4. Add clearer management notes such as browsing risk, pruning suitability, and establishment difficulty.
5. Review missing or underused food, wood, and biodiversity attributes.

Success criteria:

- The tool covers more real-world planting options.
- Users see fewer cases where an expected species is absent.
- Advisors trust the model for a wider range of farm contexts.

Suggested implementation touchpoints:

- `models/dataCzech.txt`
- `models/interfaceCzech.txt`
- `R/suitability_Czech.R`

## Phase 6: Trust, Governance, and Ecosystem Use

Target window: ongoing after core usability improvements

Objective: keep the Czech tool current and embed it in the advisory ecosystem.

Planned items:

1. Define an update workflow for Czech subsidy and legislative fields.
2. Add versioning or changelog notes for Czech data updates.
3. Add links to current subsidy or guidance sources.
4. Add pathways to advisors, demonstration farms, or learning materials.
5. Add lightweight analytics to understand which filters and presets are used most.

Success criteria:

- Users trust that the Czech data is current.
- Maintenance work is predictable rather than reactive.
- Product decisions are based on actual usage patterns.

## Prioritization

### Must Have

- Better onboarding copy
- Hard-filter visibility
- Complete Czech tooltip coverage
- Plain-language result explanations

### Should Have

- Presets by common Czech use case
- Scenario comparison
- Printable species sheets
- Mobile-friendly layout improvements

### Could Have

- Variety-level recommendations
- Advisor directory or partner links
- Community feedback layer on species pages

## Key Metrics

### Adoption Metrics

- Number of Czech tool sessions per month
- Share of sessions that reach a computed comparison
- Repeat usage within 30 days

### Usability Metrics

- Median time to first result
- Drop-off rate before clicking "Compare Trees"
- Frequency of use of presets versus manual filtering

### Decision Quality Metrics

- Export rate for Czech sessions
- Share of sessions using more than one scenario
- Feedback responses reporting that results were understandable and actionable

### Data Quality Metrics

- Number of Czech species records updated per release
- Time since last review of subsidy and legislative fields
- Number of reported Czech data issues resolved per quarter

## Risks and Dependencies

### Risks

- Policy changes may quickly invalidate subsidy logic.
- More flexibility can confuse users if it is added without guardrails.
- Data expansion without explanation can make the UI denser and harder to use.

### Dependencies

- Access to Czech domain experts for data validation.
- Agreement on how to phrase advisory language for beginners.
- Time for UI work in the shared module without breaking other models.

## Recommended Delivery Order

1. Ship Phase 1 first because it improves beginner success with minimal model risk.
2. Ship Phase 2 next because explanation increases trust in current results.
3. Ship Phase 3 before large data expansion so new users start from guided flows.
4. Ship Phase 4 when advisory and workshop usage becomes a clear target.
5. Ship Phase 5 iteratively, tied to expert review cycles.
6. Treat Phase 6 as continuous product maintenance.

## Near-Term Backlog Proposal

If only one short implementation cycle is available, prioritize this sequence:

1. Intro panel for the Czech tab.
2. Hard-filter warning text and subsidy explanation.
3. Complete tooltips for all Czech controls.
4. Empty-state and first-use guidance.
5. "Why recommended" summaries for top results.
