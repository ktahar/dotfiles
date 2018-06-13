#!/bin/bash

dconf dump /org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')/ > gnome-term.dconf
