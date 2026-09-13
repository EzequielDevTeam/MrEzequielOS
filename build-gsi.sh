#!/bin/bash
# MrEzequielOS GSI build script — roda NO servidor Crave via:
#   crave run --projectID 99 --notify --no-patch -- \
#     "curl -sf https://raw.githubusercontent.com/EzequielDevTeam/MrEzequielOS/lineage-23.2/build-gsi.sh | bash"
#
# solving, de uma vez: patch local falhando (Bad file descriptor),
# arquivos fora de repo que não viajavam e comando gigante no terminal.
# Tudo vem do GitHub (manifest + forks + snippets), fonte única da verdade.
set -e

MANIFEST_URL="https://github.com/EzequielDevTeam/MrEzequielOS.git"
MANIFEST_BRANCH="lineage-23.2"

[ -d .repo ] || { echo "ERRO: rode na raiz do codigo (sem .repo aqui)"; exit 1; }

echo "=== 1/5 manifests (snippets MrEzequielOS) ==="
mkdir -p .repo/local_manifests
rm -rf /tmp/mreze-manifest
git clone --depth 1 --branch "$MANIFEST_BRANCH" "$MANIFEST_URL" /tmp/mreze-manifest
cp /tmp/mreze-manifest/snippets/mrezequiel.xml .repo/local_manifests/

echo "=== 2/5 sync (forks + treble + extra) ==="
/opt/crave/resync.sh

echo "=== 3/5 apks oficiais ==="
bash vendor/extra/apps/fetch-apks.sh

echo "=== 4/5 lunch ==="
source build/envsetup.sh
lunch mrezequiel_gsi-bp4a-userdebug

echo "=== 5/5 build systemimage ==="
m systemimage -j$(nproc)

echo "=== OK: out/target/product/tdgsi_arm64_ab/system.img ==="
