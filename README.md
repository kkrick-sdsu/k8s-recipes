# Kubernetes Recipes
This repository is a collection of "recipes" to accomplish specific tasks on Kubernetes. This repo aims to increase the accessibility and usability of the compute resources available on VERNE and the larger National Research Platform Nautilus.

This repo assumes that you do have familiarity with the following:
- Linux
- Commandline
- Git

## Getting Started
This section coming soon!

### Using JupyterHub on VERNE
This section coming soon!

### Using Your Local Machine
This section coming soon!

## Cloning this Repo
This section coming soon!

## Downloading Individual Files
Just need one specific file? No problem! Just follow these steps to get one file at a time:

1. Navigate the repo directory structure to get to the file you are interested in
    - ![](./images/k8s-recipe-readme1.png)
1. In the upper right corner of the file viewer, click "Raw"
    - ![](./images/k8s-recipe-readme2.png)
1. Copy the URL from your browser's address bar
    - ![](./images/k8s-recipe-readme3.png)
1. Navigate to the system that you wish to download the file to
1. Use an http client to download the file
    - Example using curl
        ```bash
        curl -O https://raw.githubusercontent.com/SDSU-Research-CI/ic-intro/main/notebooks/analysis.ipynb
        ```
    - Example using wget
        ```bash
        wget https://raw.githubusercontent.com/SDSU-Research-CI/ic-intro/main/notebooks/analysis.ipynb
        ```
1. Make sure that the file downloaded successfully:
    ```bash
    $ ls -la
    total 88
    drwxr-xr-x  5 kkrick kkrick  4096 Oct 18 14:27 .
    drwxr-xr-x 20 kkrick kkrick  4096 Oct 11 08:10 ..
    -rw-r--r--  1 kkrick kkrick 64110 Oct 18 14:27 analysis.ipynb
    ```
