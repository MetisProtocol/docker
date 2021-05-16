#!/bin/bash
while IFS== read -r key value; do
	    export $key=$value;
    done < $1
  echo $a; 
