# Ansible with Kubernetes

Setup for using **Ansible** to create droplets in **Digital Ocean**, making 1 of them a **Kubernetes Master** and the others to be **Workers**, starting a **Cluster** and deploying a nginx **Service**.

### 1) Create an account in Digital Ocean (if you don't have already)

### 2) Generate a token in https://cloud.digitalocean.com/account/api/tokens

### 3) Create Firewalls in https://cloud.digitalocean.com/networking/firewalls to allow requests from anywhere to any of the droplets.

#### 3.1) For a more granular (and secure) approach using tags:

```
- Firewall01 (External SSH): [YourIP] -> Port 22 -> (tag) main
- Firewall02 (Internal SSH): (tag) main -> Port 22 -> (tag) host
- Firewall03 (Kube Network): (tag) host -> All Ports -> (tag) host
- Firewall04 (Internet): All IPs -> All Ports -> (tag) web
```

The machine with Ansible (has the `main` tag) will be the only one that can be accessed externally through SSH, and using your IP should remove the threat of brute force attacks.

The other machines (have the `host` tag) can be accessed through SSH from the Ansible machine. Inside the machine with Ansible, run `ssh host@[hostIP]`, assuming the user name in the other machines is `host` (the default in this setup).

The kubernetes masters and workers can access each other in any port, to avoid errors of nodes marked as `NotReady` when trying to apply the pod network. The ports can be changed if needed. Also, the masters have the tag `kube` and the workers have the tag `worker`, if some rule is to be applied only to the masters or only to the workers (see the properties `master_tags` and `worker_tags` in the file `/env/env.yml`). 

The workers have the `web` tag, allowing them to be accessed from anywhere in all ports (for a demo, it should be fine, but for production servers a loadbalancer should be included to receive connections from the internet and forward them to the correct pods in the correct ports).

### 4) Create a droplet in Digital Ocean:

```
- Ubuntu 18.04
- US$ 5.00
- User Data: paste the text in /setup/ansible.sh in the textarea
- Tags: main
```

### 5) Connect to the droplet through SSH:

```
- Accept the fingerprint (if asked, type 'yes' and press ENTER)
- SSH password: abc321
```

### 6) Verify that the droplet preparation is finished

```
- Run: tail /var/log/setup.log
- See if the last line printed is: "Setup Finished" (wait while it isn't finished)
```

### 7) Prepare the script to download the repository and run the playbook:

```
$ nano run.sh
[paste the content of the file run.sh in this repository]
Save and exit: Ctrl+X -> y -> ENTER
chmod +x run.sh
```

### 8) Run the script:

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

After running the playbook, you should see the new droplets created in your Digital Ocean dashboard. You can access a worker by copying the IP (the name should be in the form `worker-[number]` in the dashboard) and pasting it in the browser, followed by the port displayed at the end of the output printed while running the playbook. In the service `my-deployment`, there should be a port mapping similar to `80:[somePort]/TCP`. Use the port to the right, when accessing through the browser.

For example, if the machine `worker-001` IP is `100.110.120.130` and in the end of the ansible output the `services.stdout_lines` has the service `my-deployment` with the `PORT(S)` field value equal to `80:30507/TCP`, then you can access the worker in the browser typing `100.110.120.130:30507`.

You can run `$ ./run.sh --tags "status"` to print the status again.

After accessing the worker in the browser, you should see a nginx information saying `Welcome to nginx!`.

### 9) To reset the cluster (if needed):

```
./run.sh --tags "reset"
```

If you want only to undeploy the services:

```
./run.sh --tags "undeploy"
```

Then, if you want to create the cluster and deploy the services again:

```
./run.sh --tags "cluster,deploy,status"
```

### 10) To delete all droplets except the first one created (the ansible server):

```
$ nano ~/env/env.yml
[uncomment the `droplet_state` that has the value `deleted` and comment the one that has the value `present`]
Save and exit: Ctrl+X -> y -> ENTER
$ ./run.sh
```

### 11) Alternatives to run ansible:

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

(this won't update the repository with changes, while with `./run.sh` will (good for development), except for the files inside the `env` directory, that are defined only in the 1st run)
