#!/bin/env bash

cd /data

mkdir /data/processed

mkdir /data/processed/1of2

# Get data.zip
wget "https://drive.usercontent.google.com/download?id=1DmgPmabFCf94In5P1Jkv7VCdz1YV5JX8&export=download&authuser=0&confirm=yes" -O data.zip

# Get requirements.txt
wget "https://drive.usercontent.google.com/download?id=1NssjdbQwjn7We57FPH9ZDU2deHlAA4wY&export=download&authuser=0&confirm=yes" -O requirements.txt

# Get pre_process_wiki_text.py
wget "https://drive.usercontent.google.com/download?id=1OL7cXsxWuAuEKrn-GHlMuzhnf--PNVj5&export=download&authuser=0&confirm=yes" -O pre_process_wiki_text.py

# Get wiki-text.sh
wget "https://drive.usercontent.google.com/download?id=1cmIAnBt8jXv3kze1mKiBsqCacvgs_60O&export=download&authuser=0&confirm=yes" -O wiki-text.sh

unzip data.zip

rm data.zip
