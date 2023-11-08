# Kubernetes (k8s) Recipes
This repository is a collection of "recipes" to accomplish specific tasks via containers run on Kubernetes-based systems.
This repo aims to increase the accessibility and usability of the compute resources available on [VERNE](https://sdsu-research-ci.github.io/instructionalcluster) and the larger National Research Platform Nautilus.

## Context for Containers and Kubernetes
If you are not familiar with them, software containers are software applications that have been packaged with all of their dependencies which includes the operating system, runtime environment and libraries. Containers allow for isolated runtime environments, consistent & reproducible execution, and portability from desktop to cluster or cloud. Containers are like virtual machines (VMs), but smaller and optimized to the software application.

[Kubernetes](https://kubernetes.io/), often shortened to 'k8s', is a container orchestration platform that runs many containers at scale. Kubernetes manages each container's compute needs including CPUs, GPUs, memory, storage and networking. Kubernetes is like the operating system for containers. Kubernetes provides 'kubectl', a commandline tool for interacting with Kubernetes-based systems. Since Kubernetes is like the operating system, then kubectl is its commandline shell.

## Prerequisites
Before you begin using these recipes, you must have access to VERNE and be added to a namespace. 
We have [written instructions for getting access](https://sdsu-research-ci.github.io/softwarefactory/gettingaccess) and an accompanying [video walkthrough](https://mediasite.sdsu.edu/Mediasite/Play/8e7f235bc56f44fdb4586cffe1e477a71d).
The request process should require 10 minutes of your time, and should be approved within a business day by Research and Cyberinfrastructure.

We highly recommend following our [getting started guide](https://sdsu-research-ci.github.io/softwarefactory/gettingstarted) which will walk you through a "Hello World"-like example to give you some familiarity for working with Kubernetes via kubectl. 
This guide should require 30 minutes of your time to complete.
Should you run into any issues while following the guide, please send us an email at itd-research.ci@sdsu.edu.

The recipes in this repository assume that you have familiarity with the following:
- Linux
- Commandline
- Git

## Interacting with Kubernetes
Below we provide two options for interacting with Kubernetes:
- Using JupyterHub on VERNE
- Using your local machine

Using JupyterHub on VERNE is an attractive choice when first approaching Kubernetes and kubectl because it is pre-configured and allows for a short time-to-productivity.

Once you are familiar with kubectl, we recommend downloading it and installing it on your local machine.

### Using JupyterHub on VERNE
Research and Cyberinfrastructure maintains a Kube Notebook container image which comes with kubectl pre-installed.
If you completed the getting started guide, then you should already be familiar with this option.
You can refer to these directions for [selecting and configuring the Kube Notebook image](https://sdsu-research-ci.github.io/softwarefactory/gettingstarted#starting-a-kube-notebook) on [jupyterhub.sdsu.edu](jupyterhub.sdsu.edu).

### Using Your Local Machine
Installing kubectl on your local machine will allow you to use all of its available options.
Some recipes may require a local installation of kubectl and will list that in the ingredients section.
Please follow the [official directions for installing kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) and select your operating system.
When you come to the step "Verify kubectl configuration" you will need your kube config file.
You should have downloaded this file and followed the set up in the getting access directions under the [NRP Portal tasks](https://sdsu-research-ci.github.io/softwarefactory/gettingaccess#nrp-portal-tasks) section.
If you did not do that, please do so prior to attempting to verify your kubectl installation.
Should you run into any issues installing kubectl, please send us an email at itd-research.ci@sdsu.edu.

## Getting the Recipes
Each of the recipes will assume that you have a copy of the recipe. Below are two options for getting copies of the recipes.

### Cloning (or Forking) this Repo
You can clone this entire repo if you would like to have a copy of all the recipes. You can then periodically perform a `git fetch` to check for updates, and you can download the updates with a `git pull`.
- *Note*: A `git pull` may conflict with your local changes. If you wish to maintain your own changes, consider [forking](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo instead.

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

### Downloading Individual Files
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
