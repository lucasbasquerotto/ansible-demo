1) Create an account in Digital Ocean (if you don't have already)

2) Generate a token in https://cloud.digitalocean.com/account/api/tokens

3) Create Firewalls in https://cloud.digitalocean.com/networking/firewalls to allow requests from anywhere to any of the droplets.

4) Create a droplet in Digital Ocean:

```
- Ubuntu 18.04
- US$ 5.00
- User Data: paste the text in /setup/ansible.sh in the textarea
- Tags: main
```

5) Connect to the droplet through SSH:

```
- Accept the fingerprint (if asked, type 'yes' and press ENTER)
- SSH password: abc321
```

6) Verify that the droplet preparation is finished

```
- Run: tail /var/log/setup.log
- See if the last line printed is: "Setup Finished" (wait until it isn't finished)
```

7) Prepare the script to download the repository and run the playbook:

```
$ nano run.sh
[paste the content of the file run.sh in this repository]
Save and exit: Ctrl+X -> y -> ENTER
chmod +x run.sh
```

7) Run the script:

```
./run.sh
```

It may give an error the first time, because the Digital Ocean API token is not defined, so define it in `~/env/env.yml`:

```
$ nano ~/env/env.yml
[paste the token of step [2] in the first field `do_token`, then uncomment the `droplet_state` that has the value `present` and comment the one that has the value `deleted` (see step [9] for more information)]
Save and exit: Ctrl+X -> y -> ENTER
$ ./run.sh
```

8) To reset the cluster (if needed):

```
./run.sh --tags "reset"
```

Then, if you want to create the cluster and deploy the services again:

```
./run.sh --tags "cluster,deploy,status"
```

9) To delete all droplets except the first one created (the ansible server):

```
$ nano ~/env/env.yml
[uncomment the `droplet_state` that has the value `deleted` and comment the one that has the value `present`]
Save and exit: Ctrl+X -> y -> ENTER
$ ./run.sh
```

10) Alternatives to running ansible:

Instead of running with:

```
$ ./run.sh
and
$ ./run.sh --tags "reset"
```

You can run with:

```
$ cd ~/ansible
$ ansible-playbook main.yml
and
$ cd ~/ansible
$ ansible-playbook main.yml --tags "reset"
```

(this won't update the repository with changes, while with `./run.sh` will, except for the files inside the `env` directory, that are defined only in the 1st run)