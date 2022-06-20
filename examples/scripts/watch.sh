#! /usr/bin/env bash

npx chokidar-cli '**/*.elm' -c 'elm make src/Main.elm --output public/js/main.js' --initial
