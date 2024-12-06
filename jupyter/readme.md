# Interactive Jupyter Lab
This recipe schedules an interactive Jupyter Lab session on TIDE.
This is useful when you need to run multiple instances of JupyterLab or when estimating resource allocations (i.e. CPUs, GPUs, and memory) while developing and testing your code.
A pod is allowed to run for 6 hours, so if you need to run for longer than that consider using a batch job.

A quick note on the choice of storage for this recipe.
We will be using Block Storage, which is ReadWriteOnce, requiring one unique volume per Jupyter Lab instance.
In order to scale this recipe, allowing multiple instances access to the same data at the same time, you could use ReadWriteMany with Object Storage or File Storage.
For more on storage types, please see the [Storage Services Overview](https://csu-tide.github.io/storage-services/).

## Ingredients
- [Local installation of kubectl](../README.md#install-kubectl)
- Jupyter container image
- Jupyter Notebook (optional)
- Two terminal tabs

## Prep
1. Open your terminal and pull up two tabs
1. Set your namespace in an environment variable `ns` in each tab:
    - macOS & Linux:
        - `ns=[your-namespace-here]`
    - Windows (PowerShell)
        - `$ns="[your-namespace-here]"`
    - *Note*: Make sure to remove the brackets '[' & ']'
1. Browse the [available container images](https://csu-tide.github.io/jupyterhub/images) to see what software you want to run
1. Edit the file `jupyter-pod.yaml` and replace the value for the `image:` line with the url of your chosen container image

## Instructions
1. Create a small PersistentVolumeClaim (PVC) for this example:
    - *Note*: If you already have a PVC in your namespace, feel free to instead update  `jupyter-pod.yaml` with your PVC claimName on line 36.
    - `kubectl -n $ns apply -f volume.yaml`
    - You should see the following:
        ```
        persistentvolumeclaim/jupyter-volume created
        ```
1. Schedule the Jupyter Lab pod onto TIDE:
    - `kubectl -n $ns apply -f jupyter-pod.yaml`
    - You should see the following:
        ```
        pod/jupyter-pod created
        ```
1. Check the status of your pod:
    - `kubectl -n $ns get pods`
        - or
    - `kubectl -n $ns get pods --watch`
    - *Note*: The `--watch` option must be ended with `ctrl + c`
    - You should see the following:
        ```
        NAME               READY   STATUS    RESTARTS   AGE
        jupyter-pod        1/1     Running   0          8m50s
        ```
1. Forward the port 8888 from your pod to your local machine:
    - `kubectl -n $ns port-forward jupyter-pod 8888`
    - You should see the following:
        ```
        Forwarding from 127.0.0.1:8888 -> 8888
        Forwarding from [::1]:8888 -> 8888
        ```
    - *Note*: You will need to leave this terminal tab running, so switch to your second one before proceeding
1. Get the URL & token for your Jupyter Lab from your pod:
    - `kubectl -n $ns logs jupyter-pod`
    - You should see the following:
        ```
        To access the server, open this file in a browser:
            file:///home/jovyan/.local/share/jupyter/runtime/jpserver-1-open.html
        Or copy and paste one of these URLs:
            http://jupyter-pod:8888/lab?token=80a5f0fd0b776ed867c0af1bc5d6a87be4d351cd8964bf70
            http://127.0.0.1:8888/lab?token=80a5f0fd0b776ed867c0af1bc5d6a87be4d351cd8964bf70
        ```
    - *Note*: You want the URL that begins with `http://127.0.0.1`
1. Paste the URL into your browser of choice
    - You should see the following:
    - ![jupyter lab](../images/jupyter-pod-1.png)
    - *Note*: Available software will vary depending on the chosen container image

## Clean Up
1. Close your port-forward terminal tab
1. Stop your Jupyter pod: 
    - You may leave the job running until it reaches the max runtime at which point it will be shut down automatically
        - Or
    - You can tell k8s to shut it down manually with this command:
        - `kubectl -n $ns delete -f jupyter-pod.yaml`
1. If you created a PVC in step 1 just for this recipe, then please delete it:
    - `kubectl -n $ns delete -f volume.yaml`
