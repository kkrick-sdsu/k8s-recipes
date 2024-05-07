#!/bin/env bash

# Move to /data for following commands
cd /data

# Install dependencies
pip install -r requirements.txt

# Call the pre-process program
python pre_process_wiki_text.py $JOB_COMPLETION_INDEX
