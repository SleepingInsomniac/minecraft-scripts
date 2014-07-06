#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
screen -S minecraft -X stuff "`printf "say Updating website maps... this may take a while.\r"`"
mapcrafter -c mapcrafter.config -j 2
screen -S minecraft -X stuff "`printf "say Completed updating website maps.\r"`"
