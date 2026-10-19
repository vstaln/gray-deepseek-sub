#!/bin/sh
here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
sys="$(uname -s)"
case "$sys" in
MINGW* | MSYS* | CYGWIN*) rel="x86_64-pc-windows-msvc/deepseek-sub.exe" ;;
Darwin*)
    case "$(uname -m)" in
    arm64) rel="aarch64-apple-darwin/deepseek-sub" ;;
    *) rel="x86_64-apple-darwin/deepseek-sub" ;;
    esac ;;
*)
    case "$(uname -m)" in
    aarch64 | arm64) rel="aarch64-unknown-linux-musl/deepseek-sub" ;;
    *) rel="x86_64-unknown-linux-musl/deepseek-sub" ;;
    esac ;;
esac
if [ -x "$here/$rel" ]; then exec "$here/$rel" "$@"; fi
for cand in "$here/target/release/deepseek-sub.exe" "$here/target/release/deepseek-sub" "$here/target/debug/deepseek-sub.exe" "$here/target/debug/deepseek-sub"; do
    if [ -x "$cand" ]; then exec "$cand" "$@"; fi
done
echo "deepseek-sub binary not found in $here" >&2
exit 1
