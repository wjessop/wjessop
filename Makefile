all:
	hugo -d docs/

server:
	hugo server -DF

remote-server:
	hugo server -DF --bind=0.0.0.0 --baseURL=http://lentil.local:1313
