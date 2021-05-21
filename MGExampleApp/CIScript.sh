#!/bin/sh

#  CIScript.sh
#  MGExampleApp
#
#  Created by Marco Guerrieri on 21/05/2021.
#

echo "CIScript: Running setup for CI Keys file"

# Create temp files for CI
if [ ! -f "./Configs/Keys.swift" ]
then
    cat > "./Configs/Keys.swift" <<- "EOF"
struct Keys {
  static let apiKey = "api_key_goes_here"
}
EOF
echo "CIScript: Keys.swift file created"
else
echo "CIScript: Keys.swift already exist"
fi
