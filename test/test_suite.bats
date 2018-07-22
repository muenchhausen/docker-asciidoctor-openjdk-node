#!/usr/bin/env bats

@test "expected openjdk release is installed" {
  java -version 2>&1 | grep -r 'openjdk version "1\.8\..*"'
}

@test "expected node release is installed" {
  node -v | grep v10.
}

@test "expected asciidoctor release is installed" {
  asciidoctor -v | grep "Asciidoctor 1.5."
}

export TMP_GENERATION_DIR="/app/build/asciidoc/html5"

@test "gradle asciidoctor has created an HTML document from basic example" {
  grep '<html' ${TMP_GENERATION_DIR}/example-manual.html
}

@test "gradle asciidoctor has created an HTML document with asciidoctor-diagrams" {
  grep 'images/activity.svg' ${TMP_GENERATION_DIR}/sample-with-diagram.html
  grep 'images/blockdiag-1.svg' ${TMP_GENERATION_DIR}/sample-with-diagram.html
  grep 'images/dot-example.svg' ${TMP_GENERATION_DIR}/sample-with-diagram.html
  grep 'images/nwdiag-dmz.svg' ${TMP_GENERATION_DIR}/sample-with-diagram.html
  grep 'images/rackdiag-1.svg' ${TMP_GENERATION_DIR}/sample-with-diagram.html
  grep 'images/sample-diagram.svg' ${TMP_GENERATION_DIR}/sample-with-diagram.html
  grep 'images/diag-' ${TMP_GENERATION_DIR}/sample-with-diagram.html
}
