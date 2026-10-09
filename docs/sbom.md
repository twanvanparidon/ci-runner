# SBOM

`task security:sbom` writes two SBOMs per image to `sbom/` using [syft](https://github.com/anchore/syft) (runs in a container, no install needed):

- `<image>.spdx.json`: standard SPDX, for sharing.
- `<image>.syft.json`: includes Go function symbols, so scans give fewer false positives.

`sbom/` is gitignored; CI uploads it as an artifact.

## Scanning

`task security:scan` runs [grype](https://github.com/anchore/grype) on each SBOM and fails on `FAIL_ON` (default `high`) or worse.
Override per run: `task security:scan FAIL_ON=critical`.

PRs and main run `task security:scan`. [`scan.yml`](../.github/workflows/scan.yml) runs `task security:scan:published` nightly against the registry; a failed nightly run is your alert.

Published images also carry their SBOM as an attestation, see [releasing](releasing.md).

## Accepting risk

When a finding fails the scan, either fix it (bump the tool) or accept it in [`.grype.yaml`](../.grype.yaml) with a reason.
Entries pin the exact package version, so bumping a tool re-raises anything still affected.
