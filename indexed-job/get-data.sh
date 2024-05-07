#!/bin/env bash

cd /data

mkdir /data/processed

mkdir /data/processed/1of2

# Get data.zip
wget "https://drive.usercontent.google.com/download?id=1DmgPmabFCf94In5P1Jkv7VCdz1YV5JX8&export=download&authuser=0&confirm=yes" -O data.zip

# Get requirements.txt
wget "https://raw.githubusercontent.com/csu-tide/k8s-recipes/master/indexed-job/requirements.txt" -O requirements.txt

# Get pre_process_wiki_text.py
wget "https://raw.githubusercontent.com/csu-tide/k8s-recipes/master/indexed-job/pre_process_wiki_text.py" -O pre_process_wiki_text.py

# Get wiki-text.sh
wget "https://raw.githubusercontent.com/csu-tide/k8s-recipes/master/indexed-job/wiki-text.sh" -O wiki-text.sh

unzip data.zip

rm data.zip
