#!/bin/bash
# Runs the CSV generation script in an ephemeral python virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python counties.py
deactivate
rm -rf venv
