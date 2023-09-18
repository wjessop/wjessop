all:
	hugo -d docs/

server:
	hugo server -DF -v

remote-server:
	hugo server -DF -v --bind=0.0.0.0 --baseURL=http://lentil.local:1313
