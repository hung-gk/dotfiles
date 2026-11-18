

## SQL style
- Lowercase keywords, trailing commas, 4-space indents, one column per line.
- Use CTEs, not subqueries. Start with import CTEs, then logic CTEs, then end with `final` and `select * from final`.
- Alias explicitly, and never use `select *` except in that final CTE.
- Use `qualify` for window-based dedup in BigQuery.
- Use `safe_divide` and `safe_cast`. Name timestamps `*_at` (UTC) and dates `*_date`.
- Follow the repo's sqlfluff config if one exists.

## dbt conventions
- Layers: `stg_` (1:1 with source: rename, cast, light cleaning) → `int_` → `fct_` / `dim_` marts.
- Always use `ref()` / `source()`. Never hardcode project.dataset.table.
- Every model gets a primary-key test (`unique` + `not_null`) and a description in YAML.
- New columns get documented in the same change.
- Incremental models: state the `unique_key`, the `incremental_strategy`, and how late-arriving data is handled. Flag any change that needs a `--full-refresh`.
- Use `dbt build --select <model>+` or `state:modified+` to scope runs. Never run the whole project unprompted.
- Run `dbt compile` and check the compiled SQL before claiming a model works.

## Looker / LookML conventions
- Work in development mode on a branch. Never push to production directly.
- Business logic belongs in dbt, not LookML. LookML defines dimensions, measures, and joins on modeled tables.
- Every explore needs explicit join relationships (`relationship:`) and a primary key on each view.
- Flag changes that could break existing dashboards or Looks (renamed or removed fields).
- Prefer dbt models over PDTs unless there's a clear reason.

## Every task should have a concrete Acceptance Criteria
1. Start with the user story
Refer to the user story connected to the acceptance criteria. This ensures that the criteria tie to the desired functionality.

2. Determine the outcomes
Express the user experience and expected outcomes criteria. What should the feature achieve for the user? Avoid getting bogged down in technical implementation details.

3. Establish overall testability
Ensure each criterion translates into a clear and verifiable test. This allows for an objective evaluation of whether the feature meets the requirements.

4. Decide the measurability
Whenever possible, quantify the criteria using measurable terms. This facilitates a clear pass/fail determination during testing.

5. Focus on independence
Aim for independent criteria that you can test in isolation. This streamlines the testing process and avoids dependencies.

Consider incorporating User acceptance testing (UAT) criteria alongside the development team's criteria. UAT criteria focus on ensuring the feature meets expectations from a usability standpoint.

6. Promote collaboration
Encourage collaboration during the creation process. Involve the product owner, software developer (or teams) and other relevant stakeholders to ensure a comprehensive set of criteria that reflects all perspectives.

7. Review and refinement
Don't be afraid to revisit and refine the acceptance criteria throughout development. As understanding evolves, consider adjusting the criteria to reflect the latest information.

8. Provide clarity and concision
Strive for clear and concise language everyone can understand. Technical jargon or ambiguous phrasing can lead to confusion.