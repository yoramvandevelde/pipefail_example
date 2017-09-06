#!/bin/bash 
# author: Yoram van de Velde ( _@sp2.io )

# Examples of why pipefail is really important to use.

# We enable exit on error functionality
set -o errexit

# These commands will fail but not stop the script because of the pipes
# to succesfull commands. This works because error is output to stderr,
# and the empty output of the command is output to stdout. This means the
# *head* command is executed with no input, but it will exit with 
# succesfull status of 0.
echo "set -e / set -o errexit test 1"
no-way-this-exists | head -n 1 
echo -e "${?}\n"

echo "set -e / set -o errexit test 2"
not_existing_command -y | cut -d ' ' -f 1
echo -e "${?}\n"

echo "set -e / set -o errexit test 3"
really_not_existing_command | tail -n 1
echo -e "${?}\n"



# Let's set the magic pipefail and see what happens.
set -o pipefail

# If you want to allow commands in piped commands to fail you could  
# use the following construction. This way you make sure you always
# have expected behaviour.
echo "set -o pipefail test 1"
no-way-this-exists | head -n 1 || true
echo -e "${?}\n"

# All other piped commands fail and exit the script with a non zero
# status code.
echo "set -o pipefail test 2"
nonexisting_command -y | tail -n 1
echo -e "${?}\n"

# We will never get here.
echo "set -o pipefail test 3"
nonexisting_command | head -n 1
echo -e "${?}\n"
