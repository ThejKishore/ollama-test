#!/bin/bash

# Set default values
TAR_FILE="ollama-with-mistrallite.tar"
CHUNK_PREFIX="ollama_chunk_"
CHUNK_SIZE="22m"
RECOMBINED_FILE="ollama-recombined.tar"

# Help message
usage() {
    echo "Usage: $0 [split|combine|verify]"
    echo "  split    - Split $TAR_FILE into 250MB chunks"
    echo "  combine  - Combine chunks into $RECOMBINED_FILE"
    echo "  verify   - Verify checksums of the chunks"
    exit 1
}

# Split the TAR file
split_tar() {
    if [[ ! -f "$TAR_FILE" ]]; then
        echo "Error: $TAR_FILE not found."
        exit 1
    fi

    echo "Splitting $TAR_FILE into 250MB chunks..."
    split -b "$CHUNK_SIZE" "$TAR_FILE" "$CHUNK_PREFIX"
    echo "Generating SHA256 checksums..."
    sha256sum ${CHUNK_PREFIX}* > ${CHUNK_PREFIX}checksums.sha256
    echo "Done. Created chunks and checksum file."
}

# Combine chunks into a single TAR
combine_tar() {
    echo "Combining chunks into $RECOMBINED_FILE..."
    cat ${CHUNK_PREFIX}* > "$RECOMBINED_FILE"
    echo "Done. You can now load it with:"
    echo "docker load -i $RECOMBINED_FILE"
}

# Verify checksums
verify_chunks() {
    echo "Verifying chunk checksums..."
    sha256sum -c ${CHUNK_PREFIX}checksums.sha256
}

# Main
case "$1" in
    split) split_tar ;;
    combine) combine_tar ;;
    verify) verify_chunks ;;
    *) usage ;;
esac
