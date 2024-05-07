# Recipe Title
Short decription of the recipe and why it is useful.

## Ingredients
- [Local installation of kubectl](../README.md#install-kubectl)
- etc.
- etc.

## Prep
1. Open your terminal
1. Set your namespace in an environment variable `ns` in each tab:
    - macOS & Linux:
        - `ns=[your-namespace-here]`
    - Windows (PowerShell)
        - `$ns="[your-namespace-here]"`
    - *Note*: Make sure to remove the brackets '[' & ']'
1. etc.
1. etc.

## Instructions
1. Provide step by step commands:
    - `kubectl -n $ns apply -f pod.yml`
    - You should see the following:
        ```
        pod/pod created
        ```
1. etc.
1. etc.

## Clean Up
1. Guide the user through cleaning up any uneeded resources.
    - `kubectl -n $ns delete -f pod.yml`
    - You should see the following:
        ```
        pod/pod deleted
        ```