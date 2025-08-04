# MATLAB
This recipe schedules an interactive Jupyter Lab session with MATLAB on TIDE.

## Ingredients
- [Local installation of kubectl](../README.md#install-kubectl)
- MATLAB License

## Prep
1. Open two tabs in your terminal
1. Set your namespace in an environment variable `ns` in each tab:
    - macOS & Linux:
        - `ns=[your-namespace-here]`
    - Windows (PowerShell)
        - `$ns="[your-namespace-here]"`
    - *Note*: Make sure to remove the brackets '[' & ']'
1. Make sure that you have MATLAB licensing information (License File, License Server or account) as the container image does not provide a MATLAB license

## Instructions
1. Schedule the MATLAB pod:
    - `kubectl -n $ns apply -f matlab-pod.yaml`
    - You should see the following:
        ```
        pod/matlab-pod created
        ```
1. Make sure the pod is ready:
    - `kubectl -n $ns get pods --watch`
    - Note: Hit `ctrl + c` when the READY column shows 1/1
1. In your second terminal, setup port-forwarding for the Jupyter Lab environment:
    - `kubectl -n $ns port-forward matlab-pod 8888`
    - You should see the following:
        ```
        Forwarding from 127.0.0.1:8888 -> 8888
        Forwarding from [::1]:8888 -> 8888
        ```
1. In your first terminal, get the logs from the pod:
    - `kubectl -n $ns logs matlab-pod`
    - You should see the output similar to the following:
        ```
        [C 2024-08-01 16:28:20.054 ServerApp] 
    
        To access the server, open this file in a browser:
            file:///home/jovyan/.local/share/jupyter/runtime/jpserver-1-open.html
        Or copy and paste one of these URLs:
            http://matlab-pod:8888/lab?token=5125ffbdc4661b73f706c0507a020e71039e26dda5b17290
            http://127.0.0.1:8888/lab?token=5125ffbdc4661b73f706c0507a020e71039e26dda5b17290
        [I 2024-08-01 16:28:20.334 ServerApp] Skipped non-installed server(s): bash-language-server, dockerfile-language-server-nodejs, javascript-typescript-langserver, jedi-language-server, julia-language-server, pyright, python-language-server, python-lsp-server, r-languageserver, sql-language-server, texlab, typescript-language-server, unified-language-server, vscode-css-languageserver-bin, vscode-html-languageserver-bin, vscode-json-languageserver-bin, yaml-language-server
        ```
1. Copy and paste the URL into your browser that starts with `http://127.0.0.1:8888/...`
1. You should be greeted with the Jupyter Lab UI
1. Click the "Open MATLAB" icon
1. Proceed to license MATLAB through one of the three options
    - Note: A license server may not work if it has IP address restrictions. You should contact your local IT support to check.

## Clean Up
1. When you are done, please clean up the pod:
    - `kubectl -n $ns delete -f matlab-pod.yaml`
    - You should see the following:
        ```
        pod "matlab-pod" deleted
        ```