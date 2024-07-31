---
title: Designing your application for scale
date: 2023-08-15T00:00:00Z
draft: true
tags: ["management", "design", "tech"]
summary: As applications grow and the userbase gets larger so does the application data, and this can mean scaling problems. Here are some simple ideas to design scalability into the application from the start, leading to faster pages, better UX and happier customers.
category: ""
type: Post
---

## The Trap

Picture a startup, recently launched, a sales tracking application called WidgetSalesTrackr. There are 10s of customers signed up, a similar number of users, and customers are using the application to track sales that they are making on their e-commerce platforms. Data is coming in from an API endpoint but it's happening at the rate of 100s of sales per day and the data is still pretty small. They've been going 3 months so far and have in the region of 10,000 sales in the sales table.

It's looking promising but it's still small, the founders haven't quit their main jobs yet but they have high hopes that things are going to take off because feedback is really positive.

Early on someone added pagination to the pages where sales are listed, but only after someone pointed out that having a few thousand sales on one page was a bit cumbersome. Whoops. Still, it was easy to add, and is fairly simple to use and understand:

![Some basic pagination used on a website](images/simple-pagination.png)

There's a button to skip to the first couple of pages, buttons to skip to the last couple of pages, and buttons to skip to the next and previous pages. Standard stuff.

![Spongebob timecard, 5 years later](images/5-years-later-cropped.jpeg#full)

Some years have passed and things have taken off. WidgetSalesTrackr has a team of 10 engineers plus the usual design, product, sales and marketing departments you'd expect.

The original 100s of sales per day ingested by the API has grown massively and now peaks at closer to 100 per second. Month on month they're adding 50 million records to the sales table, and the records are getting updated now too as order statuses change. The database is starting to creak a little and it's the sales table, the biggest table with the highest insert and update rate, that is the cause of most of the problems.

So what's the problem here?

There is talk of moving sales data to another store, like DynamoDB or similar, but it's a huge task.

Scaling problems are good though right! Yes, but that doesn't mean you have to walk deliberately and directly into a pit trap full of them.
distracting

there is no time to be dealing with this. There are more important projects to complete

Listen to customers:
"I go back through the list of sales and calculate the average order total for all sales in the previous year"

Control access to the data

---

# Notes

Hyrum's Law

With a sufficient number of users of an API, it does not matter what you promise in the contract: all observable behaviors of your system will be depended on by somebody.

I've seen this problem many times now.

- BOUND IT!
- Total Number of sales <add today>
- archived data, can be available more offline?
- Go through the regular motions. Add indexes, cacheing, faster hardware, database partitions etc.
- Postgres partitioning mention in talk, moving partitions out of the way
