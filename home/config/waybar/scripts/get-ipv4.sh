#!/bin/bash

ip addr show enp4s0 | grep -Po 'inet \K[\d.]+' | wl-copy