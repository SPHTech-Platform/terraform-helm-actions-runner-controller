# Errors Log
Log of command failures, API errors, and tool gotchas.

## Format
```markdown
### [ERR-YYYYMMDD-XXX] Tool/Command Name
**Logged**: ISO-8601 timestamp
**Status**: pending
**Summary**: Brief description of what failed
**Resolution**: (Add when fixed)
```

---

### [ERR-20260604-001] Actions Runner Controller Pod Creation Failure
**Logged**: 2026-06-04T17:40:00+08:00
**Status**: resolved
**Summary**: In gha-runner-scale-set chart, defining a custom template block with only resources wipes out the default containers/initContainers arrays because Helm merges by replacement. This caused the operator to attempt pod creation without images (spec.containers[0].image: Required value).
**Resolution**: Updated values.yaml template in the module to render the full template_spec when containerMode is dind, and include the runner image in the fallback path. Applied a live hotfix to the AutoscalingRunnerSet resource in EKS (st-drupal-cms-prd) using JSON patch to restore the runner and init container images, resolving the block immediately for the dev team.

