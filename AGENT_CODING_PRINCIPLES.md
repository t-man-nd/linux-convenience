# Agent Coding Principles

> **Purpose:** Rules for AI coding agents working on this repository. Apply these principles when implementing, refactoring, reviewing, and fixing code.
>
> **Priority:** Correctness & Security → Reliability → Clarity → Maintainability → Simplicity → Performance (unless measured performance is an explicit requirement).
>
> **Scope:** These are defaults, not excuses for unnecessary abstraction. Follow existing project conventions unless they conflict with correctness, security, or explicit requirements.

## 1. Correctness First

- Preserve required behavior and satisfy acceptance criteria before optimizing style or performance.
- Identify business rules, edge cases, and failure conditions before changing code.
- Do not change observable behavior during a refactor unless explicitly requested.
- Never guess about undocumented behavior when it can be verified from the code, tests, or specification.

**Done when:** The intended behavior is explicit and verified with appropriate tests or checks.

## 2. Clarity Over Cleverness

- Write code that another engineer can understand without reverse-engineering tricks.
- Prefer meaningful names, straightforward control flow, guard clauses, and explicit state transitions.
- Keep functions focused and scopes small; split long or deeply nested logic only when doing so improves understanding.
- Avoid magic values, hidden side effects, and clever one-liners that obscure intent.

**Done when:** A reviewer can quickly explain what the code does and why.

## 3. One Clear Responsibility (SRP)

- Give each function, class, and module a cohesive purpose and a clear reason to change.
- Separate business decisions from presentation, storage, transport, and infrastructure where the separation adds value.
- Do not interpret SRP as “one method per class” or create tiny wrappers without a meaningful boundary.
- Keep related behavior together instead of scattering it across artificial layers.

**Done when:** Changes to one responsibility rarely require modifying unrelated responsibilities.

## 4. Dependencies Must Be Intentional (SOLID)

- Prefer high cohesion and low coupling; make dependency direction and data ownership clear.
- Depend on stable contracts at important boundaries; inject external dependencies when it improves testability or replaceability.
- Keep interfaces small and consumer-focused (ISP); implementations must honor their contracts (LSP).
- Extend behavior through composition or polymorphism when there is a real variation point (OCP).
- Do not add interfaces, factories, patterns, or layers for hypothetical future needs (YAGNI).

**Done when:** Dependencies are easy to trace, justified, and do not force unrelated modules to change together.

## 5. Validate Boundaries, Protect Invariants

- Treat user input, network responses, files, messages, and external service data as untrusted.
- Validate inputs at trust boundaries and use precise types or schemas when available.
- Enforce invariants with domain checks, database constraints, and transactions as appropriate.
- Do not rely on assertions as the sole runtime validation for untrusted input.
- Prevent invalid states where practical instead of repeatedly checking them everywhere.

**Done when:** Invalid input is rejected predictably and internal state remains valid.

## 6. Never Hide Failures

- Do not swallow exceptions, ignore meaningful return values, or silently substitute success-looking defaults.
- Distinguish expected business failures from infrastructure failures and programming defects.
- Add actionable error context without exposing secrets or sensitive data.
- Bound retries, timeouts, polling, queue sizes, and resource consumption; ensure operations can terminate or be canceled.
- Design idempotency, compensation, or transactions where repeated or partially completed operations pose risks.

**Done when:** Failures have explicit behavior, are diagnosable, and cannot silently corrupt state.

## 7. Keep Complexity Justified (KISS, DRY, YAGNI)

- Choose the simplest design that meets current, concrete requirements.
- Remove duplication of **business knowledge**, but do not force unrelated concepts into a shared abstraction just because their code looks similar.
- Avoid speculative extensibility, premature generalization, and unnecessary configuration.
- Introduce abstractions only when they reduce real coupling, duplication, or complexity.
- Optimize performance from evidence (profiling, benchmarks, SLOs), unless performance is a stated correctness constraint.

**Done when:** Each abstraction and added dependency has an explainable present-day benefit.

## 8. Make Behavior Testable

- Test observable behavior and contracts rather than tightly coupling tests to implementation details.
- Cover normal cases, edge cases, error paths, and regressions based on risk.
- Keep deterministic business logic separate from time, randomness, I/O, and external services where practical.
- Use unit tests for focused rules and integration/contract tests for important boundaries.
- For a bug fix, add a regression test when feasible; do not change tests merely to hide a defect.

**Done when:** Relevant behavior is demonstrably correct and future regressions are likely to be caught.

## 9. Automate Quality Enforcement

- Follow the repository's formatter, linter, type checker, and security/static-analysis rules.
- Run the relevant checks before finalizing changes, or state clearly which checks could not be run and why.
- Do not introduce new critical warnings, type errors, failing tests, exposed secrets, or known high-risk vulnerabilities.
- Keep dependencies controlled and builds reproducible using the project's established tooling.
- Never claim that a build, test, or check passed unless it actually ran successfully.

**Done when:** Required automated checks pass or any remaining blockers are reported accurately.

## 10. Leave the Codebase Healthier

- Keep changes focused, reviewable, and proportional to the request.
- Preserve established conventions unless there is a documented reason to improve them.
- Remove dead code introduced or made obsolete by the change; do not perform unrelated rewrites.
- Update tests, documentation, migration notes, and operational guidance when behavior or contracts change.
- Explain noteworthy tradeoffs, assumptions, risks, and incomplete verification in the final handoff.

**Done when:** The change solves the task without leaving avoidable confusion, fragility, or undocumented behavior.

---

## Agent Execution Checklist

Before making changes:

- [ ] Read the relevant code, tests, and repository conventions.
- [ ] Identify the required behavior, risks, and affected boundaries.
- [ ] Choose the smallest coherent solution; avoid speculative architecture.

While making changes:

- [ ] Keep naming, control flow, scopes, and responsibilities clear.
- [ ] Validate untrusted inputs; preserve invariants; handle failures explicitly.
- [ ] Consider security, concurrency, idempotency, and resource limits where relevant.
- [ ] Add or update tests proportional to the change's risk.

Before handing off:

- [ ] Run relevant formatter, lint, type checks, tests, and security checks when available.
- [ ] Review the diff for accidental changes, dead code, secrets, and unnecessary abstractions.
- [ ] Summarize what changed, what was verified, and any remaining risks or checks not run.

**Conflict resolution:** Explicit product/security requirements and established contracts take precedence over style preferences. When two principles compete, prefer the option that is safer, easier to verify, and simpler to maintain. Do not turn a principle into a rigid metric (such as an absolute function line limit or coverage percentage) without project-specific justification.
