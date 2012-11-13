Helper script to provide aliases for easier code review workflow.

Examples:

```$: proj start newUI```
fetches updates from remote/master and creates a new feature branch called newUI.

```$: proj start ```
fetches updates from remote/master and creates a new feature branch with a random name.

```$: proj review```
sends your commits for code review

```$: proj clean```
remove any branches that are already merged in you master branch.


Installation 

Run the following in command line

```
wget https://github.com/nikosk/proj.sh/raw/master/proj.sh -O proj.sh
chmod +x proj.sh
./proj.sh install
rm proj.sh
```
