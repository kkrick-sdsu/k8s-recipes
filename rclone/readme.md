# Rclone for S3 Data Transfer
This recipe will copy data from TIDE S3 storage to a pod, perform computation on the data and then copy the processed data back to TIDE S3 storage.
S3 stands for Simple Storage Service and is a cloud service for object storage offered by AWS.
S3 has a popular REST API that has been adopted by other storage providers like [Ceph S3](https://docs.ceph.com/en/latest/radosgw/s3/) which powers TIDE S3 storage.
Rclone is a command line tool that is useful for transferring data to and from several cloud-based storage providers, including S3-compatible storage solutions like Ceph S3.

## Ingredients
- [Local installation of kubectl](../README.md#install-kubectl)
- TIDE S3 Credentials and Bucket
    - You can request credentials and/or a new bucket via the [TIDE Support Request](https://tide.sdsu.edu/tide-support-request/) using the Request Type of "Other" and mentioning "TIDE S3" in the Additional Details
- [Local installation of Rclone](https://rclone.org/install/#quickstart)

## Prep
1. Open your terminal
1. Set your namespace in an environment variable `ns`:
    - macOS & Linux:
        - `ns=[your-namespace-here]`
    - Windows (PowerShell)
        - `$ns="[your-namespace-here]"`
    - *Note*: Make sure to remove the brackets '[' & ']'

## Instructions
### Configure Rclone Locally
You can use the following text guide as a supplement to this [recording for configuring Rclone]().

1. Start rclone configuration
    - `rclone config`
1. New remote
    - `n`
1. Recommend a short name for typing and using in scripts
    - `s3`
1. Search for the number associated with "Amazon S3 Compliant Storage Providers ..."
    - At the time of writing this was option 4
    - `4`
1. Search for the number associated with "Ceph Object Storage"
    - At the time of writing this was option 4
    - `4`
1. Enter AWS Credentials
    - At the time of writing this was option 1
    - `1`
    - Note: These will be displayed in plain text
1. Enter your Access Key
1. Enter your Secret Key
1. Leave the Region empty (hit enter)
1. Since we are setting this up on a local computer, we are external to the cluster, so we will use the external endpoint
    - `https://s3-tide.nrp-nautilus.io`
1. Leave the location constraint empty (hit enter)
1. For the ACL, use "Owner gets FULL_CONTROL"
    - At the time of writing this was option 1
    - `1`
1. Leave server-side encryption empty (hit enter)
1. Leave KMS ID empty (hit enter)
1. Do not edit advanced config
    - `n`
1. Keep this remote
    - `y`
1. Quit rclone config
    - `q`
1. You should now see a list of your remotes:
    ```bash
    Current remotes:

    Name                 Type
    ====                 ====
    s3                   s3
    ```
1. Test your configuration
    - `rclone ls s3:my-bucket`
    - *Note*: Replace 's3' with your chosen remote name, replace 'my-bucket' with your bucket name
1. If you did not get an error message, then your configuration was successful!
    - *Note*: You may not get any output, this just means that your bucket is empty

### Copy Data to S3
1. Modify the file `copy-train-push.sh`
    - Replace `s3:my-bucket`
        - I.E.: `rclone copy ~/hello.txt tide-s3:maztec123/rlcone-recipe`
1. Save the file
1. Copy the files `copy-train-push.sh`, `hello.txt` and `train.py` to your S3 bucket
    - `rclone copy ./copy-train-push.sh s3:my-bucket/rclone-recipe/`
    - `rclone copy ./hello.txt s3:my-bucket/rclone-recipe/`
    - `rclone copy ./train.py s3:my-bucket/rclone-recipe/`
    - *Note*: Replace 's3' with your chosen remote name, replace 'my-bucket' with your bucket name
    - *Note*: Check the [K8s Recipe Readme](../README.md) for getting the files locally
1. Verify the data was copied
    - `rclone ls s3:my-bucket/rclone-recipe`
    - *Note*: Replace 's3' with your chosen remote name, replace 'my-bucket' with your bucket name
    - You should see the following:
    ```
        139 copy-train-push.sh
        173 train.py
    ```

### Add S3 Config to Namespace
1. Make a copy of the file `template-rclone.conf` and save it/rename it as `rclone.conf`
1. Update the first line with your remote name in the brackets
    - I.E.: `[tide-s3]`
1. Enter your Access Key
1. Enter your Secret Key
1. Save the file
1. In your terminal, create a secret in your namespace for your rclone.conf file
    - *Note*: If you are in a shared namespace, then you may need to change the name of the secret in the command as secrets must be unique -- we recommend to use your email prefix I.E "maztec123" for "maztec123@sdsu.edu"
    - `kubectl -n $ns create secret generic rclone-config --from-file=rclone.conf`
1. Verify your secret exists
    - `kubectl -n $ns get secret`

### Process S3 Data
1. Modify the pod.yaml file
    - Replace `s3:my-bucket` on line 26 with your rclone endpoint and bucket name
        - I.E.: `rclone copy -LP tide-s3:maztec123/rclone-recipe ~/`
    - If you had to make a unique secret name in the previous section, then replace the secret name on line 35
        - I.E.: `secretName: rclone-config-maztec123` 
1. Save the file
1. Schedule the pod to process the data
    - `kubectl -n $ns apply -f pod.yaml`
    - You should see the following:
        ```
        pod/python created
        ```
1. Watch the pod until it completes
    - `kubectl -n $ns get pods --watch`
    - *Note*: Use `ctrl + c` to cancel the watch command
    - Over time you should see the following:
    ```
    NAME     READY   STATUS    RESTARTS   AGE
    python   1/1     Running   0          4s
    python   0/1     Completed   0          10s
    python   0/1     Completed   0          11s
    python   0/1     Completed   0          12s
    python   0/1     Completed   0          12s
    ```
1. Check your rclone endpoint for the new hello.txt file
    - `rclone ls s3:my-bucket/rclone-recipe/`
    - *Note*: Replace 's3' with your chosen remote name, replace 'my-bucket' with your bucket name
1. Check the contents of hello.txt
    - `rclone cat s3:my-bucket/rclone-recipe/hello.txt` 
    - *Note*: Replace 's3' with your chosen remote name, replace 'my-bucket' with your bucket name

## Clean Up
1. Delete the pod
    - `kubectl -n $ns delete -f pod.yaml`
    - You should see the following:
        ```
        pod/python deleted
        ```
1. Delete the example data from your S3 bucket
    - `rclone delete s3:my-bucket/rclone-recipe/`
    - *Note*: Replace 's3' with your chosen remote name, replace 'my-bucket' with your bucket name
