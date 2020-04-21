# Wireguard on ec2

## Infra
### AWS Resources

#### Create manually
* 1 `ec2 Key pair` for ssh access
* 1 `Elastic IP` for an external IP associated to the instance (optional)

#### Create with Terraform
* 1 `ec2` instance
* 1 `security_group`
    * ingress port 22 for ssh
    * ingress port 51820 for Wireguard UDP
    * egress let it all out

### Terraform
#### Options
* `key_name` the ec2 key pair to associate to the instance, defaults to `"aws-wireguard"`
* `wireguard_ips` port 51820 ip whitelist, deafaults to `["0.0.0.0/0"]`
* `ssh_ips` port 51820 ip whitelist, **REQUIRED**`

usage
```
terraform apply -var='ssh_ips=["<ip cidr>"]'
```
```
terraform plan -var='ssh_ips=["<ip cidr>"]' -var='wireguard_ips=["<ip cidr>"]'
```
```
terraform apply -var='ssh_ips=["<ip cidr>"]' -var="key_name=<your key pair name>"
```
```
terraform apply -var='ssh_ips=["73.173.72.29/32"]' -var='wireguard_ips=["73.173.72.29/32"]'
```
## Wireguard

### Install
`install.sh` runs on `ec2` instance create

### Setup
Follow instructions via https://tau.gr/posts/2019-03-02-set-up-wireguard-vpn-ubuntu-mac/#create-server-config or configure Wireguard as you see fit

### Wireguard command quick reference
* `wg-quick up wg0`
* `wg-quick down wg0`
* `wg show`
* `wg showconf`

* `systemctl enable wg-quick@wg0` # start Wireguard automatically

## References
* https://tau.gr/posts/2019-03-02-set-up-wireguard-vpn-ubuntu-mac/
* https://github.com/isystem-io/wireguard-aws
* https://habr.com/en/post/449234/
