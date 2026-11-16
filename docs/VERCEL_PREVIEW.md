# Vercel Flutter Web preview

The owner has authorized maintaining this demo preview after every approved
merge. The agent performing a merge must follow deployment to READY, verify the
merged commit and report the preview URL. Source preparation does not prove a
project is connected or a deployment succeeded.

## Build configuration

- `vercel.json`: static Flutter Web output at `build/web`; native Git deployments
  enabled for preview/feature branches; `main` is disabled to avoid a production
  Git deployment. HTML, bootstrap and metadata revalidate instead of staying stale.
- `tool/build_vercel.sh`: uses official Flutter 3.35.4 at exact framework revision
  `d693b4b9dbac2acd4477aea4555ca6dcbea44ba2`; enforces locked packages, formatting,
  analysis, regression tests and a self-contained release web build.
- Flutter service-worker generation is disabled for this demo so new merges do
  not leave viewers on an older cached application.
- `tool/write_preview_metadata.dart`: writes a public `preview-version.json`
  containing the full commit SHA, branch, app version, UTC build time and demo flag.
  No tokens, account settings or environment-variable values are included.

## One-time account activation

1. Use the owner's connected Vercel account. Create/link only the isolated project
   `tax-flutter-mobile-preview` and connect `abdalraof-albarbar/Tax-Flutter-Mobile`.
2. Keep the repository private. Grant Git access to this repository only.
3. Use framework **Other**, repository root `.`, and the committed `vercel.json`.
4. Keep Vercel's production branch at `main`, but its automatic Git deployment is
   disabled by `vercel.json`. The workflow mirrors successfully tested `main` to
   `preview`, which Vercel deploys as Preview with a stable branch URL. Do not
   promote a deployment to production merely to refresh a demo preview.
5. Use the feature branch's separate Preview URL to review work before merging.
   Keep the stable preview domain assigned to the `preview` mirror branch.
6. Record the real project ID, team and returned preview URL after linking. Do
   not invent a domain or treat an unclaimed fallback deployment as account-linked.

Vercel documents that a new project's first deployment may be classified as
Production by the service. Do not use that to claim production release approval;
keep this project isolated and use Preview deployments for subsequent updates.

## Every merge into main

1. Merge only an approved PR after required checks pass.
2. `.github/workflows/vercel-preview.yml` runs only after a successful push-to-main
   Flutter CI run. It skips superseded commits and fast-forwards `preview` to that
   exact tested commit. The mirror is derived output, never an editing branch.
3. Confirm Vercel's Git integration starts a Preview deployment on `preview`.
4. Wait for CI and deployment completion. Check Vercel's READY state, branch,
   commit SHA and generated `preview-version.json` against the merged commit.
5. Keep the preview URL pointing at the newest successful main deployment.
   Fix failures; do not call an old deployment an updated preview.
6. Report the real preview URL, deployed commit and verification result.

The native Git connection avoids copying local auth or adding a Vercel token to
GitHub source. If an account connection is missing, complete source/configuration
work and request that connection; never read `auth.json` or ask for credentials
in chat. Do not modify unrelated Vercel projects, domains or production services.

## Official references

- [Vercel GitHub deployments](https://vercel.com/docs/git/vercel-for-github)
- [Preview environments and branch URLs](https://vercel.com/docs/deployments/environments)
- [Git deployment configuration](https://vercel.com/docs/project-configuration/git-configuration)

## Activation evidence

- Verified account: `technologyet31-create`; scope: `technologyet31-creates-projects`.
- Linked project: `tax-flutter-mobile-preview`, ID
  `prj_9gaPkUzVjwyMkq1Ehjmg8BQBXdSp`.
- Vercel Git connection confirmed to `abdalraof-albarbar/Tax-Flutter-Mobile`.
- [Project dashboard](https://vercel.com/technologyet31-creates-projects/tax-flutter-mobile-preview).
- Automatic production-domain assignment is disabled for this isolated project.
- PR #1 and PR #2 were merged with explicit user approval after their checks.
- Main CI run `43365014088` and mirror run `43366377624` both succeeded.
- The mirror automatically fast-forwarded `preview` to tested main
  `e76c4e373961e70b00f6200c9c95edadd82ddd4d`.
- Vercel automatically built deployment `dpl_Bxj12aWdsfbFULF5vqureY9ckKWL`,
  `tax-flutter-mobile-preview-e13bhbzfn.vercel.app`: **READY, target Preview**.
- The stable domain `tax-flutter-mobile-preview.vercel.app` automatically points
  at that deployment. Authenticated `vercel curl` returned HTTP 200 HTML and
  `preview-version.json` with the exact SHA above, branch `preview`, version
  `0.1.0`, built at `2026-11-13T04:36:28.126885Z`.

New feature PRs need their own merge approval. The profile/settings feature is
reviewed separately; this main preview evidence does not include unmerged work.
