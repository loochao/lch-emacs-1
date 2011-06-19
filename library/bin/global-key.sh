#!/bin/bash

for i in `ls *.el`; do
  sed 's/global-set-key/define-key global-map/g' $i > $i.new;
  mv $i.new $i
done
