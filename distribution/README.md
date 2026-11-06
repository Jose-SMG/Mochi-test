# Existing beta import

`import.json` records the exact public release assets previously built and published in Jose-SMG/Pruebas. The import workflow copies those files into this dedicated repository's Releases after verifying sizes, SHA-256 digests, source revisions and platform manifests. It adds `migration-provenance.json` without changing the original files.

The beta tag identifies the actual binary source commit, retained in this repository's history. The default branch also includes the dedicated repository documentation and migration tooling. Migration does not rebuild the application or mark incomplete native interaction tests as passed.

Future native builds can be started explicitly through the **Coucou Mochi installers** workflow. Existing upstream workflow definitions are archived under `docs/upstream-workflows/` for reference; they do not publish official Coucou releases from this repository.
