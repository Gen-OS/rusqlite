#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "$SCRIPT_DIR"
cd "$SCRIPT_DIR" || { echo "fatal error" >&2; exit 1; }
cargo clean -p libsqlite3-sys
TARGET_DIR="$SCRIPT_DIR/../target"
export SQLITE3_LIB_DIR="$SCRIPT_DIR/sqlite3"
mkdir -p "$TARGET_DIR" "$SQLITE3_LIB_DIR"

# Download and extract amalgamation
SQLITE=sqlite-amalgamation-3460100

export SQLITE3_INCLUDE_DIR="$SQLITE3_LIB_DIR"
# Regenerate bindgen file for sqlite3.h
rm -f "$SQLITE3_LIB_DIR/bindgen_bundled_version.rs"
cargo update --quiet
# Just to make sure there is only one bindgen.rs file in target dir
find "$TARGET_DIR" -type f -name bindgen.rs -exec rm {} \;
env LIBSQLITE3_SYS_BUNDLING=1 cargo build --features "buildtime_bindgen" --no-default-features
find "$TARGET_DIR" -type f -name bindgen.rs -exec mv {} "$SQLITE3_LIB_DIR/bindgen_bundled_version.rs" \;

# Sanity checks
cd "$SCRIPT_DIR/.." || { echo "fatal error" >&2; exit 1; }
cargo update --quiet
cargo test --features "backup blob chrono functions load_extension serde_json vtab bundled"
printf '    \e[35;1mFinished\e[0m bundled sqlite3 tests\n'
