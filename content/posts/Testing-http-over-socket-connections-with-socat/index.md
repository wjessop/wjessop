---
title: Testing http over socket connections with socat
date: 2011-12-02T22:00:55Z
draft: false
tags: [tech, programming]
summary: Easy socat command for testing local HTTP connections listening on a UNIX socket.
description: Easy socat command for testing local HTTP connections listening on a UNIX socket.
category: ""
type: Post
---

Sometimes I need to test an http server that is listening on a unix socket. It's really easy to do this using socat, but the socat man page is pretty long. Here it is for anyone who needs it in the future, and me when I inevitably forget.

In this case the server is unicorn, but this will work for any http server listening on a socket, for instance thin. The lines beginning with "-->" are lines I typed (the 4 lines at the start), remove the "-->" when you try this.

```
$ socat - UNIX-CONNECT:/u/apps/app/shared/sockets/unicorn.sock,crnl
-->GET /session/new HTTP/1.1
-->Host: thehostname.com
-->X-Forwarded-Proto: https
-->
HTTP/1.1 200 OK
Date: Fri, 02 Dec 2011 14:37:23 GMT
Status: 200 OK
Connection: close
Strict-Transport-Security: max-age=31536000
Content-Type: text/html; charset=utf-8
X-UA-Compatible: IE=Edge,chrome=1
ETag: "2346c47c7cb3bc37729e42fc8b20c821"
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _x_session=blablabla; path=/; HttpOnly; secure
X-Request-Id: c0a374f460d1b1205df450ab77dd2328
X-Runtime: 0.159219

<!DOCTYPE html>
<html lang="en" data-behavior="wallpaper">
<head>
etc.
```

For those interested in the relevance of the crnl option at the end of the socket path, this from the man page:

> - Converts the default line termination character NL ('n', 0x0a)
> - to/from CRNL ("rn", 0x0d0a) when writing/reading on this
> - channel (example). Note: socat simply strips all CR characters.
