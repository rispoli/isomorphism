#!/bin/bash

for i in *.dot
do

	echo "Generating image for file: $i";
	$(dot -Tpng $i > $(echo $i | sed s/dot/png/));

done
