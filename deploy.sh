#! /bin/bash

mdbook build -d public
sleep 3
firebase deploy