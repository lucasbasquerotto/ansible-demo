1) Create an account in Digital Ocean (if you don't have already)

2) Generate a token in https://cloud.digitalocean.com/account/api/tokens?i=5f28a9

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



```
./run.sh
```

```
./run.sh --tags "cluster-reset"
```