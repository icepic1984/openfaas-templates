# Common lisp function templates for openfaas

This repository contains common lisp function templates using
different implementations (sbcl,ecl) for openfaas.

# Usage

1 ) Fetch template from github
```console
foo@bar:~$ faas template pull https://github.com/icepic1984/openfaas-templates
```

2) Create new function
```console
foo@bar:~$ faas-cli new echo --lang clisp-sbcl
```

3) Edit `function\handler.lisp`

4) Build function. Note that i am build the dockerfile remotely on my kubernetes cluster for arm64. This step might differ on your system.

```console
foo@bar:~$ $faas-cli build -f echo.yml --shrinkwrap
```

5) Build image and push into remote registry
```console
foo@bar:~$ docker buildx build \
	--platform linux/arm64 \
	--output "type=image,push=true" \
	--tag icepic1984/echo:latest build/echo/
```

6) Enable portforwarding

```console
foo@bar:~$ kubectl port-forward svc/gateway -n openfaas 8080:8080
```

7) Deploy image

```console
foo@bar:~$ faas-cli deploy --image icepic1984/echo:latest --name echo

Deployed. 202 Accepted.
URL: http://127.0.0.1:8080/function/echo
```

8) Execute

```console
foo@bar:~$ curl -s http://127.0.0.1:8080/function/echo -d "hi"
hi
```
