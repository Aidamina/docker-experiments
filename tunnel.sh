#!/bin/bash

ssh -nNT -L 8080:localhost:8080 core@k8s-test.cloudapp.net -p 2022
