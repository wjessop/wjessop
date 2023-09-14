---
title: Should I switch from Sendgrid to Amazon SES?
date: 2011-01-25T21:53:07Z
draft: false
tags: [aws, sendgrid, ses, web service, tech]
summary: I compared all Sendgrid and Amazon SES prices to see who was cheaper
category: ""
type: Post

---
**Update: A new comparison with updated Sendgrid prices, and Postmark is available [here](/posts/cloud-email-service-price-comparison) "Sendgrid, Postmark and Amazon SES price comparison").**

Probably yes, at least if price is your main concern and you are just concerned with sending email and not with extras. I wanted to see just how the [Amazon SES](http://aws.amazon.com/ses/) prices stacked up against (that I am aware of) the next cheapest provider, [Sendgrid](http://sendgrid.com/) so I graphed it:

{{< figure src="images/emails-price-comparison1.png" alt="A graph showing the difference between prices for Sendgrid and AWS SES" title="Cost comparison for Amazon SES/Sendgrid" class="full" >}}

SendGrid can't be too happy with that, in short at no point is it better to go with SendGrid over SES if you are only taking price into account. Of course SendGrid have [value-add over just plain email](https://sendgrid.com/pricing/) sending, you decide if it's worth the premium, but for me the only feature I'd want would be the 'Whitelabel' option, and Amazon SES has that included.

Note that you get 2000 emails per day free with Amazon SES if you send from an [Amazon EC2](http://aws.amazon.com/ec2/) instance, but at this scale there is very little visible difference in cost. I thought it would be useful to take into account the cost of an EC2 instance, even if you have your main server elsewhere you could run your email processing on a micro or small EC2 machine to take advantage of the 2000 free emails per day, here's a zoom in on the origin:

{{< figure src="images/email-prices-plus-server.png" alt="A graph showing the difference between prices for Sendgrid and AWS SES, including spinning up a server to send mail from" title="Cost comparison for Amazon SES/Sendgrid + EC2 instance cost" class="full" >}}

So, there is no point in spinning up an EC2 instance to take advantage of the 2000 free emails per day.

I will be interested in SendGrid's response to this. Possibly lowering prices? For me certainly their value-add isn't worth the extra cost over Amazon SES.
