---
title: Running a specific knapsack test set locally
date: 2023-04-26T15:00:00Z
draft: false
tags: ["ruby", "programming"]
summary: Sometimes you have a test order issue CI that you want to debug locally, and to do that you need to only run the tests that knapsack runs in the relevant shard, in the right order. Here's how to do that!
category: ""
type: Post
---

Sometimes you have a test order issue CI that you want to debug locally, and to do that you need to only run the tests that knapsack runs in the relevant shard, in the right order. Here's how to do that!

1. Grab `CI_NODE_TOTAL` and `CI_NODE_INDEX` from the test output, it's likely near the top:

![Getting the CI node data from CI output](images/ci-node-data.png#full)

2. Grab the seed value, it's probably going to be near the bottom of the output:

![Getting the seed value from CI output](images/seed.png#full)

3. Run the command with the interpolated values you got above

        $ RAILS_ENV=test CI=true CI_NODE_TOTAL=16 CI_NODE_INDEX=4 bundle exec rake "knapsack:rspec[--seed 43092 --format documentation]"

    You might also want to add `--fail-fast` to the options to cut short the test suite when you hit your error:

        $ RAILS_ENV=test CI=true CI_NODE_TOTAL=16 CI_NODE_INDEX=4 bundle exec rake "knapsack:rspec[--seed 43092 --format documentation --fail-fast]"

    You can even `rspec bisect` across this set of tests:

        $ OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES RAILS_ENV=test CI=true CI_NODE_TOTAL=16 CI_NODE_INDEX=13 bundle exec rake "knapsack:rspec[--seed 16837 --bisect]"

    Here I added `OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` as there [is bug/issue with Ruby](https://stackoverflow.com/questions/52671926/rails-may-have-been-in-progress-in-another-thread-when-fork-was-called) on OS X, you should be able to remove that environment variable on Linux.
