name = Hectic
processing = processing-java --sketch=../$(name)

run:
	$(processing) --run

build:
	$(processing) --output=out --force --build

export:
	$(processing) --platform=linux --output=linux --export --force