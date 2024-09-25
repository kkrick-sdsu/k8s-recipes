#!/bin/bash

python train.py

# Add code to copy hello.txt back TIDE S3
rclone copy ~/hello.txt s3:my-bucket/rclone-recipe/
