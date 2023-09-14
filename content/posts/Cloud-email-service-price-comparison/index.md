---
title: Cloud email service price comparison
date: 2011-11-30T21:27:42Z
draft: false
tags: [aws, email, postmark, sendgrid, ses, tech]
summary: A comparison of Sendgrid, AES SES, Postmark and Mailgun pricing
category: ""
type: Post
---

**Larger interactive versions of all the graphs on this page are available [here](cloud_email_provider_price_comparison.html).** **Update:** Added [Mailgun](https://www.mailgun.com/ "Mailgun") to the [graphs](http://willj.net/static/cloud_email_provider_price_comparison.html).

Earlier this year I posted a [price comparison](/posts/should-i-switch-from-sendgrid-to-amazon-ses "Sendgrid and Amazone SES price comparison") between [Sendgrid](https://sendgrid.com/ "Sendgrid"), and the then newly available [Amazon SES](http://aws.amazon.com/ses/ "Amazon SES").

Tim Falls commented on the post saying that Sendgrid had updated their pricing:

> Since this post was published, we have released a new pricing structure \*and\* a new service tier that offers more email for less + a feature set and pricing model that you will find very competitive with SES.

That was back in June, so it's about time I produced an updated comparison. First, lets look at the difference between the old and new Sendgrid prices:

{{< figure src="images/screen-shot-2011-11-30-at-22-20-15.png" alt="graph showing cost of email service providers" title="Comparison of old and new Sendgrid prices" class="full" >}}

Overall the up-front plan prices, and prices for email over allowance have remained the same, but email allowance within each plan has increased. The exception is the Silver plan where email over allowance has increased by $0.0001/email. New to the lineup is the Lite plan.

More interesting is how these new prices compare to the competitors. I've added in Amazon SES, and Postmark too:

{{< figure src="images/screen-shot-2011-12-01-at-00-42-52.png" alt="graph showing cost of email service providers" title="Sendgrid, Postmark and Amazon SES price comparison" class="full" >}}

The most notable differences here are the inclusion of [Postmark](http://postmarkapp.com/ "Postmark"), and the the Sendgrid Lite plan that shadows Amazon SES. I'd guess this was added purely to compete with Amazon. As in my last post it is hard to see what is going on with smaller numbers of emails being sent, here's a zoom on the origin:

{{< figure src="images/screen-shot-2011-12-01-at-00-42-57.png" alt="graph showing cost of email service providers" title="Price comparison for small numbers of emails sent" class="full" >}}

Here you can see the Sendgrid Lite plan shadowing Amazon and the Postmark costs heading up rapidly.

## Conclusion

It seems Sendgrid have just added an 'Amazon SES' plan to pull back any customers that would have chosen SES based on price. It's probably a good move, and it will allow easy transition into their more 'premium' plans if you sign up and later decide to change plan.

Given the advertised features of Postmark compared to the price it seems hard to consider using them. They seem to have some fairly well known customers though, so if anyone has used Postmark leave a comment with how that is working out for you.

So which email cloud provider should you use? Use the graphs I made, but price is only going to be one factor, so check what each provider offers. I've linked to all the pricing pages below.

### Price sources

- [Sendgrid prices](https://sendgrid.com/pricing)
- [Postmark prices](https://postmarkapp.com/pricing)
- [Amazon SES prices](https://aws.amazon.com/ses/pricing)
- [Mailgun prices](https://www.mailgun.com/pricing)
