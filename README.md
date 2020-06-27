# What is it?

Amazon Linux provides a stable, secure, and high-performance execution environment for applications. This is an ECS friendly version that allows you to create an ECS service into which you can SSH. 

### Why?

This helps to have a container acting as a daemon. The primary goal I have in mind is to test out any connectivity issues between your containers, work out any name resolution between services and any other daemon like activities.

# How to use?

```shell script
$ docker run -it -p 22:22 -p 8080:8080 --name amazonlinuxecs visitsb/amazonlinuxecs:latest

Starting SSH daemon...
Starting GOSS health checks...
Going to sleep for 60 seconds. Zzz...
```

Now you can ssh into the the container using the exposed port `22`, user `ec2-user` using the private key displayed when you start the container.

**Note**: `PubkeyAuthentication` is setup by default. The public/private key contents are displayed when you start the container. `Password` based login is enabled too (Default password `ec2-user`). 

```shell script
$ /usr/bin/ssh ec2-user@127.0.0.1 22 
The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:AAo6G8MtS/3FqMQ7TW1WtoLe2bffQiuvpXblBhi1elE.
Are you sure you want to continue connecting (yes/no)? yes

[ec2-user@31be1e84d551 ~]$ whoami
ec2-user
[ec2-user@31be1e84d551 ~]$
```

### Amazon ECS setup

Setup a [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) to serve a TCP port `22` backed by a [TCP Listener](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-listener.html) forwarding traffic to your [Target Group](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-target-group.html).

# Health checks

The health checks are exposed on using `HTTP` on port `8080` under path `/healthz`. This is useful to setup your ECS container as a target group's health check under [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html).

# Problems?

Please post an issue. If you have any suggestions, I encourage you to submit a PR too.