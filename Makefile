all:
	hugo -d docs/

server:
	hugo server -DF -v
	# This command works on the iPhone, but doesn't seem to auto-refresh locally.
	# hugo server -DF -v --bind=0.0.0.0 --baseURL=http://lentil.local:1313
