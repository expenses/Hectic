# Lazy makefile to simplify commands

processing = processing-java --sketch=`pwd`/Hectic

run:
	$(processing) --run

build:
	mkdir -p out
	$(processing) --output=`pwd`/out --force --build