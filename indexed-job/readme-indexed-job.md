# Indexed Jobs
Indexed Jobs are a special kind of [Kuberentes Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) that allow you to manage and execute batch jobs efficiently. 
They provide a mechanism for parallelizing job execution across multiple pod instances, enhancing scalability and performance for tasks that can be broken down into smaller units.

For example, if you have 100 files that require pre-processing and each file can be processed independently, then an indexed job can be used to parallelize and speed up the pre-processing step.

## Ingredients
- [Local installation of kubectl](../README.md#install-kubectl)

## Prep
1. Open your terminal
1. Set your namespace in an environment variable `ns`:
    - macOS & Linux:
        - `ns=[your-namespace-here]`
    - Windows (PowerShell)
        - `$ns="[your-namespace-here]"`
    - *Note*: Make sure to remove the brackets '[' & ']'

## Instructions

### 1. Create Data Volume
When accessing data from a volume in an indexed job, a read-write many volume is required because many pods may be reading and writing data in parallel.

1. Create a read-write many volume to store data for the indexed job: 
    - `kubectl -n $ns apply -f volume.yaml`
1. Verify that the volume was created successfully:
    - `kubectl -n $ns get pvc`
    - You should see output similar to the following:
    ```bash
    NAME                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS       AGE
    index-volume          Bound    pvc-313811bb-d7a1-491b-808c-1baebffcc1c5   2Gi        RWX            rook-cephfs-tide   34s
    ```

### 2. Download Test Data
For this example, we will be using the [Plain text Wikipedia](https://www.kaggle.com/datasets/ffatty/plain-text-wikipedia-simpleenglish) dataset.
We will download the data using the pod defined in `data-pod.yaml` which runs the `get-data.sh` shell script.

1. Schedule the data pod:
    - `kubectl -n $ns apply -f data-pod.yaml`
1. Check the pod and make sure it runs to completion:
    - `kubectl -n $ns get pods --watch`
    - You should see output similar to the following:
    ```bash
    NAME               READY   STATUS    RESTARTS   AGE
    data-pod           0/1     Pending   0          0s
    data-pod           0/1     Pending   0          0s
    data-pod           0/1     Init:0/1   0          0s
    data-pod           0/1     Init:0/1   0          8s
    data-pod           0/1     Init:0/1   0          35s
    data-pod           0/1     PodInitializing   0          37s
    data-pod           1/1     Running           0          38s
    data-pod           0/1     Completed         0          49s
    data-pod           0/1     Completed         0          50s
    data-pod           0/1     Completed         0          51s
    ```
    - *Note*: Use `ctrl + c` to cancel the watch command
1. Delete the data pod once it has completed:
    - `kubectl -n $ns delete -f data-pod.yaml`
1. Check that the data was copied successfully using the viewer pod defined in `viewer-pod.yaml`:
    - `kubectl -n $ns apply -f viewer-pod.yaml`
1. Check the pod and make sure it gets to the running state:
    - `kubectl -n $ns get pods --watch`
    - You should see output similar to the following:
    ```bash
    NAME               READY   STATUS              RESTARTS   AGE
    viewer-pod         0/1     ContainerCreating   0          10s
    viewer-pod         0/1     ContainerCreating   0          12s
    viewer-pod         1/1     Running             0          13s
    ```
    - *Note*: Use `ctrl + c` to cancel the watch command
1. Get the logs from the running viewer-pod:
    - `kubectl -n $ns logs viewer-pod`
    - You should see output similar to the following:
    ```bash
    1of2
    2of2
    AllCombined.txt
    get-data.sh
    pre_process_wiki_text.py
    processed
    requirements.txt
    wiki-text.sh
    ```
1. Delete the viewer pod:
    - `kubectl -n $ns delete -f viewer-pod.yaml`

### 3. Inspect the Indexed Job
Before we schedule the indexed job, let's take a moment to see how its various components come together.

Let's start with the [indexed-job.yaml](./indexed-job.yaml) file.
From the first few lines, we can gather that this is a Kubernetes [batch job](https://kubernetes.io/docs/concepts/workloads/controllers/job/).
From the Job's spec, we see the fields `completions`, `parallelism` and `completionMode` indicating that this is job will run for 10 completions, or iterations, with up to 2 pods in parallel and that this is an indexed job. 

Using `completions` we can set our input size, for example if we wanted to process all 100 files in the directory `1of2`, then we would set `completions` to 100.

Using `parallelism` we can set how many pods are run in parallel, keeping in mind our resource requests for the pod.
For example, if we needed 1 CPU and 2GB RAM per pod, and we set `parallelism` to 10, then we would be requesting 10 CPUs and 20GB of RAM in total.

With `completionMode` Indexed, our job's pods will be provided the environment variable `$JOB_COMPLETION_INDEX` which is in the range from 0 to `completions - 1`, or in the case of this example 0 through 9, inclusive.

The container `pre-processor` will be running inside each of the pods.
We can see that it is using the [python:3](https://hub.docker.com/_/python) container image which  will have the latest version of Python 3 installed. 
We see that the container will be launching the bash script `wiki-test.sh`.
This container will also be mounting our read-write many volume at the path `/data`.

Next, let's consider the [wiki-text.sh](./wiki-text.sh) script, which is called as the command of the pre-processor container.
We see that the script will install necessary Python dependencies from the `requirements.txt` file.
Once the dependencies are installed, the script calls the program `pre_process_wiki_text.py` passing it the environment variable `$JOB_COMPLETION_INDEX`.

Lastly, let's examine the program [pre_process_wiki_text.py](./pre_process_wiki_text.py).
We see a function `pre_process_text` that performs a simple transformation on our input text files by removing stop words and empty lines and then writing the results to the processed directory.
The `main` function reads in the `$JOB_COMPLETION_INDEX` value which was passed in by the `wiki-text.sh` script.
We then perform a transformation on the value of `$JOB_COMPLETION_INDEX` to match our input.
In this example, our input files are in the form of `wiki_XX`, so for index value 0 through 9 we need to prepend an extra 0 so that the index is 00 through 09.
With the completion index transformed to work with our input, we call the `pre_process_text` function.

### 4. Schedule the Indexed Job
Now that we have examined each of the components of the indexed job, let's schedule it onto TIDE so we can see it in action.

1. Schedule the indexed job
    - `kubectl -n $ns apply -f indexed-job.yaml`
1. Check the progress of the pods:
    - `kubectl -n $ns get pods --watch`
    - You should see output similar to the following:
    ```bash
    NAME               READY   STATUS    RESTARTS   AGE
    indexed-job-example-0-z4nnb   0/1     Pending   0          0s
    indexed-job-example-0-z4nnb   0/1     Pending   0          0s
    indexed-job-example-0-z4nnb   0/1     ContainerCreating   0          0s
    indexed-job-example-1-qjl6q   0/1     Pending             0          0s
    indexed-job-example-1-qjl6q   0/1     Pending             0          0s
    indexed-job-example-1-qjl6q   0/1     ContainerCreating   0          0s
    indexed-job-example-0-z4nnb   0/1     ContainerCreating   0          5s
    indexed-job-example-1-qjl6q   0/1     ContainerCreating   0          4s
    indexed-job-example-0-z4nnb   1/1     Running             0          6s
    indexed-job-example-1-qjl6q   1/1     Running             0          5s
    ...
    indexed-job-example-8-nj45z   0/1     Completed           0          9s
    indexed-job-example-8-nj45z   0/1     Completed           0          10s
    indexed-job-example-8-nj45z   0/1     Completed           0          11s
    indexed-job-example-8-nj45z   0/1     Completed           0          11s
    indexed-job-example-9-zbccs   0/1     Completed           0          8s
    indexed-job-example-9-zbccs   0/1     Completed           0          9s
    indexed-job-example-9-zbccs   0/1     Completed           0          10s
    indexed-job-example-9-zbccs   0/1     Completed           0          10s
    ```
    - *Note*: The pods will be named in the form [job-name]-[index]-[random-code] and will be unique for every run of the job 
    - *Note*: Use `ctrl + c` to cancel the watch command
1. Check to make sure that all completions for the job succeeded:
    - `kubectl -n $ns get jobs`
    - You should see output similar to the following:
    ```bash
    NAME                  COMPLETIONS   DURATION   AGE
    indexed-job-example   10/10         71s        3m7s
    ```
1. Check that the data was processed successfully using the viewer pod defined in `viewer-pod.yaml`:
    - `kubectl -n $ns apply -f viewer-pod.yaml`
1. Check the pod and make sure it gets to the running state:
    - `kubectl -n $ns get pods --watch`
    - You should see output similar to the following:
    ```bash
    NAME               READY   STATUS              RESTARTS   AGE
    ...
    viewer-pod         0/1     ContainerCreating   0          10s
    viewer-pod         0/1     ContainerCreating   0          12s
    viewer-pod         1/1     Running             0          13s
    ```
    - *Note*: Use `ctrl + c` to cancel the watch command
1. Get a remote shell on the running viewer pod:
    - `kubectl -n $ns exec -it viewer-pod -- bash`
    - You should see a bash prompt similar to the following:
    ```bash
    root@viewer-pod:/#
    ```
1. Check the first 1000 characters of the processed wiki_00.txt file:
    - `head -c 1000 /data/processed/1of2/wiki_00.txt`
    - You should see something similar to the following:
    ```
    April April (Apr.) fourth month year Julian Gregorian calendars, comes March May. It one four months 30 days. April always begins day week July, additionally, January leap years. April always ends day week December. April comes March May, making fourth month year. It also comes first year four months 30 days, June, September November later year. April begins day week July every year day week January leap years. April ends day week December every year, other's last days exactly 35 weeks (245 days
    ```
1. Exit the remote shell:
    - `exit`

With that, congratulations! You have successfully run your first indexed job.
You can use this recipe as a template for applying indexed jobs to speed up your own workloads.

## Clean Up
Before we wrap up, let's make sure to clean up the resources used in this example.

1. Delete the viewer pod:
    - `kubectl -n $ns delete -f viewer-pod.yaml`
1. Check to make sure that the viewer pod was deleted:
    - `kubectl -n $ns get pods`
    - You should see output similar to the following:
    ```bash
    NAME                          READY   STATUS      RESTARTS   AGE
    indexed-job-example-0-z4nnb   0/1     Completed   0          26m
    indexed-job-example-1-qjl6q   0/1     Completed   0          26m
    indexed-job-example-2-hvkw9   0/1     Completed   0          26m
    indexed-job-example-3-lhppm   0/1     Completed   0          26m
    indexed-job-example-4-dlw8k   0/1     Completed   0          25m
    indexed-job-example-5-5ghgw   0/1     Completed   0          25m
    indexed-job-example-6-s7bcl   0/1     Completed   0          25m
    indexed-job-example-7-7ls6n   0/1     Completed   0          25m
    indexed-job-example-8-nj45z   0/1     Completed   0          25m
    indexed-job-example-9-zbccs   0/1     Completed   0          25m
    ```
1. We can see that all of the completed pods from our indexed job are still present in a Completed status. Let's clean those up too:
    - `kubectl -n $ns delete -f indexed-job.yaml`
1. Check to make sure all of the indexed job pods have been deleted:
    - `kubectl -n $ns get pods`
    - You should see output similar to the following:
    ```
    No resources found in [your-namsepace-here] namespace.
    ```
1. Let's also free up the storage we used when creating our read-write many volume:
    - `kubectl -n $ns delete -f volume.yaml`
    - You should see output similar to the following:
    ```bash
    persistentvolumeclaim "index-volume" deleted
    ```

That concludes this recipe!
