all:
	hugo -d docs/

server:
	hugo server -D -v
	# This command works on the iPhone, but doesn't seem to auto-refresh locally.
	# hugo server -D -v --bind=0.0.0.0 --baseURL=http://lentil.local:1313
