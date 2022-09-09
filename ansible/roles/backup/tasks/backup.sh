#!/bin/bash

timestamp="$(date +'%b-%d-%y')"
tar -czfv /home/backup-${timestamp}.gz /home
