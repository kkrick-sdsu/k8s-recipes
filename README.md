# Kubernetes (k8s) Recipes
This repository is a collection of "recipes" to accomplish specific tasks via containers run on Kubernetes-based systems.
This repo aims to increase the accessibility and usability of the compute resources available on VERNE and the larger National Research Platform Nautilus.

## Context for Containers and Kubernetes
If you are not familiar with them, software containers are software applications that have been packaged with all of their dependencies which includes the operating system, runtime environment and libraries. Containers allow for isolated runtime environments, consistent & reproducible execution, and portability from desktop to cluster or cloud. Containers are like virtual machines (VMs), but smaller and optimized to the software application.

Kubernetes, often shortened to 'k8s', is a container orchestration platform that runs many containers at scale. Kubernetes manages each container's compute needs including CPUs, GPUs, memory, storage and networking. Kubernetes is like the operating system for containers. Kubernetes provides 'kubectl', a commandline tool for interacting with Kubernetes-based systems. Since Kubernetes is like the operating system, then kubectl is its commandline shell.

## Prerequisites
Before you begin using these recipes, you must have access to VERNE and be added to a namespace. 
We have [written instructions for getting access](https://sdsu-research-ci.github.io/softwarefactory/gettingaccess) and an accompanying [video walkthrough](https://mediasite.sdsu.edu/Mediasite/Play/8e7f235bc56f44fdb4586cffe1e477a71d).
The request process should require 10 minutes of your time, and should be approved within a business day by Research and Cyberinfrastructure.

We also highly recommend following our [getting started guide](https://sdsu-research-ci.github.io/softwarefactory/gettingstarted) which will walk you through a "Hello World"-like example to give you some familiarity for working with Kubernetes via kubectl. 
This guide should require 30 minutes of your time to complete.
Should you run into any issues while following the guide, please send us an email at itd-research.ci@sdsu.edu.

## Interacting with Kubernetes
Below we provide two options for interacting with Kubernetes:
- Using JupyterHub on VERNE
- Using your local machine

Using JupyterHub on VERNE is an attractive choice when first approaching Kubernetes and kubectl because it is pre-configured and allows for a short time-to-productivity.
However, it does come with limitations chief of which is not being able to use the port-forwarding command. 
If one of the recipes calls for any command that requires kubectl to run locally, it will be listed in the ingredients section.

Once you are familiar with kubectl, we recommend downloading it and installing it on your local machine.

### Using JupyterHub on VERNE
This section coming soon!

### Using Your Local Machine
This section coming soon!

## Cloning this Repo
You can clone this entire repo if you would like to have a copy of all the recipes. You can then periodically perform a `git fetch` to check for updates, and you can download the updates with a `git pull`.
- Note: A `git pull` may conflict with your local changes. If you wish to maintain your own changes, consider [forking](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo instead.

To clone this repo just follow these steps:
1. Via commandline, navigate to where you want to clone this repo
1. Run the following command:
    ```bash
    git clone https://github.com/SDSU-Research-CI/k8s-recipes.git
    ```
1. Verify that you successfully cloned the repo with `git status`:
    ```bash
    $ git status
    On branch master
    Your branch is up to date with 'origin/master'.
    ```

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
1. Make sure that the file downloaded successfully with `ls -la`:
    ```bash
    $ ls -la
    total 88
    drwxr-xr-x  5 kkrick kkrick  4096 Oct 18 14:27 .
    drwxr-xr-x 20 kkrick kkrick  4096 Oct 11 08:10 ..
    -rw-r--r--  1 kkrick kkrick 64110 Oct 18 14:27 analysis.ipynb
    ```
