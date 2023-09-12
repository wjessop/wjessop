---
title: AWS IAM Policy for allowing s3cmd to sync to an S3 bucket
date: 2014-04-18T17:41:47Z
draft: false
tags: [tech, programming, AWS]
summary: I needed s3cmd to sync some local files to a remove S3 bucket and had to work out the IAM permissions to allow this.
category: ""
type: Post
---

It's a good idea to set an IAM access policy for anything that accesses AWS using your account details, I wanted to do this for s3cmd syncing a local directory to an s3 bucket. There are a [number of posts](https://www.google.co.uk/search?q=s3cmd+iam+policy&oq=s3cmd+iam&aqs=chrome.0.69i59j69i57j69i60.4378j0j7&sourceid=chrome&es_sm=91&ie=UTF-8) on setting up the IAM policy for s3cmd already but none of the examples worked for me, I got a 403 permission denied error when running the s3cmd sync command.

After some digging it turns out that s3cmd now tries to set an ACL on the files it uploads, and this needs to be specifically allowed in the ACL. I'm guessing that it didn't in the past, hence the now incorrect IAM advice. So here is the new working IAM policy, complete with the `s3:PutObjectAcl` permission added:

(See jrantil's comment below on wether `s3:ListAllMyBuckets` is needed in this instance)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1397834652000",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    },
    {
      "Sid": "Stmt1397834745000",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::bucketname",
        "arn:aws:s3:::bucketname/*"
      ]
    }
  ]
}
```

## Update!

This post was imported from my original blog where there were comments, and these may be relevant to anyone finding this page now:

{{< figure src="images/comments.png" title="Comments on the original blog post" class="full" alt="">}}
