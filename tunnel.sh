#!/bin/bash

ssh -nNT -L 8080:localhost:8080 core@k8s-test.cloudapp.net -p 2022

#ssh -nNT -L 8001:localhost:8001 core@k8s-test.cloudapp.net -p 2022