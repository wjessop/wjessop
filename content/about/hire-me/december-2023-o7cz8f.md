---
title: Hire Me
date: 2023-09-18T17:30:00+01:00
draft: false
preview: false
type: Static
opentocontracts: false
noindex: true
---

Hi, I am Will Jessop, an extensively experienced programmer, sysadmin and technical leader. As a consultant and contractor I focus on:-

- Ruby on Rails performance and application scaling.
- Postgres database performance and scaling.
- Application architecture planning and implementation for robustness and scale.
- Ruby on Rails upgrades, including handling upgrades directly, introducing processes to make upgrades sustainable and documenting changes to help teams split up and handle large upgrades themselves.
- Consulting on engineering organisation structure and process with the aim of improving project outcomes, engineer focus and happiness, and generally increasing the effectiveness of engineering departments.

I open to technical leadership, performance/scaling and Ruby on Rails upgrade roles.

---

## Experience

### 📍 Impactive (Remote, Boston USA) - CTO

When I joined Impactive (then Outvote) the organisation was struggling with a number of issues including an urgent scaling and re-architecting problem, lack of organisation leading to poor project outcomes and low morale, and a lack of quality leading to negative customer experiences and a poor reputation in the industry. I immediately went to work fixing these.

#### Performance, scaling and re-architecture

The most immediate concern was that they had won the contract to run all voter outreach and communication for the Biden campaign in the 2020 presidential election, a contract that would see orders of magnitude more traffic than they got day to day. The application was struggling under the existing load and there was a serious time-pressure to scale and re-architect to meet the deadline of voter outreach starting months before the election. I quickly got to work identifying critical paths within the application, adding performance monitoring and implementing fixes for a large number of issues. In the end Impactive handled the election traffic successfully for our clients.

- Identified all critical paths within the application.
- Added performance monitoring tooling and introduced these to the team.
- Significantly optimised a large amount of database usage.
- Re-architected several systems to be much more scalable.
- Added read replicas to offload read-only load from the primary.

Later, during the mid term elections in 2022 Impactive won the DCCC contract and scaling went even further, peaking at over 1000 req/s across the existing, and new product features, requiring further Postgres and Ruby on Rails performance work including query optimisation, and further re-architecting including moving to an SLA based queue infrastructure.

#### Complete re-organisation of the engineering department and product pipeline

Next, the development organisation itself was in trouble. There was no clear organisation, morale was low and key senior employees were burnt out and leaving including the previous CTO and lead engineer. Projects routinely ran over with little to no oversight, understanding of requirements was minimal leading to discrepancies between the desired outcome of projects and what was built leading to delays and extra workload to re-align, communication was mostly one-way down the pipeline so there was no feedback on pace of development and overruns so engineers were getting assigned new projects mid-way through existing projects with no clear prioritisation.

To fix this I completely overhauled the product pipeline from planning through to deploy, introducing a completely new process, structure and a totally new development cycle. I increased employee happiness, reduced employee turnover, and increased the overall quality of the codebase and application while improving project outcomes with more accurate delivery times and an increased project throughput.

- Introduced a new eight week development cycle and process:
	- Planning ahead meant the engineers had a clear understanding of what projects were assigned to them and when they were due. Confusion was minimised and happiness increased.
	- The development organisation was still able to react fast when required due to the new feedback process.
		- Weekly planning meetings between leaders to check on overall progress, re-assess priorities, adjusting the cycle where necessary.
		- Per-team check-ins with project stakeholders to steer development ensuring project outcomes matches expectation.
	- I implemented cross department meetings to plan the cycle. All department heads/stakeholders including the CEO and COO would get together to discuss organisational priorities for the upcoming development cycle ensuring all voices across the organisation could be heard when it came to prioritising engineer time.
	- An all-department Cycle kick-off, re-inforced the mission, build a sense of a shared goal and belonging on the team.
	- Per-team Project kick-off meetings with projects stakeholders increased understanding of projects at the team level, including what was expected to be delivered.
- Increased engineer focus:
	- Engineers reported feeling able to focus on projects more and this led to an increase in quality.
	- The perceived lack of a constant rush created a sense of pride and ownership in their work.
	- Re-organised meetings to be more relevant and smaller where needed reducing reported "meeting overload".
- Eliminated unclear priorities by simplifying the process by which engineers were assigned work, and providing a feedback process for engineers to report confusion.

#### Quality

Impactive had a quality problem. Defects were regularly shipped to production as both bugs in new features, and regressions in existing features and Impactive had a reputation in the industry as shipping buggy software. I wanted to change this because it was causing problems with customer retention and staff morale, as well as making overall project delivery less efficient as time taken fixing bugs took time away from new projects and interrupted engineer focus. To create a culture of quality I:

- Changed code review from something that the CEO and CTO alone did to be something that all engineers took part in.
	- This stopped "rubber stamping" by management who didn't have time to do proper code review.
	- It made engineers think about quality in general, and helped them apply this thinking to their code knowing it was going to be reviewed.
	- Led by example. Performed code review, and had Engineers review my code.
- Encouraged good Pull Request structuring, descriptions and commit messages.
	- This made engineers think carefully about the steps required to complete tasks, and made code easier to review.
- Pushed for large projects to be split into smaller sets of deliverables:
	- Smaller deliverable items help identify mis-steps or mis-communication earlier.
	- Increases the chance or project success.
	- Allows for a more agile approach should priorities change.
- Created regular check ins from stakeholders during the development process, helping to identify flaws earlier in the development process.
- Implemented e2e testing for critical paths throughout the application, ensuring that no critical application breaking bugs made it to production.
- Encouraged CI discipline. Getting CI green, then getting people to pay attention to when CI failed prevented flaws that should be detected by CI from getting to production.
- Enforced testing by default. Pull requests had to come with associated tests.

Ultimately quality increased dramatically. We stopped deploying so many bugs and drastically reduced outages. An overall increase in the quality of the codebase and being able to rely on CI increased engineer confidence and the speed of development and job satisfaction.

### 📍 Tanda (Remote, London UK) - Performance contractor/consultant

Tanda was a short term contract focussed mainly on database performance. Ultimately when I left Tanda they had a far better optimised database, and new techniques on the engineering team for scaling themselves in the future. Some highlights:

- Significantly increased database performance by query optimisation and IO reduction, greatly improving the experience for many of their customers.
- Identified and removed unused indexes, increasing write performance on core queries on the critical path.
- Wrote internal articles for the engineering team aiming to spread knowledge of database performance and optimisation techniques.

### 📍 Procore (Remote, CA USA) - contractor/consultant

As part of the RubyTune consultancy team I was deeply involved in a number of areas:

- Advising on the architectural direction of the company.
- Guiding the upgrade process including breaking down and tracking the work required, and automatically splitting up smaller tasks between teams.
- Writing documentation for the upgrade process for teams to follow.
- Implementing code and tooling for tracking key application performance metrics.
- Optimisation and tracking of the application boot performance.
- Writing new internal tooling for operating on data at scale.

### 📍 Previous

#### Stuart (Remote, Barcelona Spain) - contractor/consultant

At Stuart I was solely focussed on planning, documenting and execuing a number of their Rails upgrades which happened seamlessly with no customer impact.

#### 37signals/Basecamp (Remote, Chicago USA) - Sysadmin

At 37signals/Basecamp I was on the team that rolled out inter-datacentre failover, worked on security initiatives including our handling Hacker One reports, and handled day to day sysadmin duties helping to keep Basecamp and other apps running performantly.

#### Engineyard (Remote, San Francisco USA) - Application Support Engineer

At Engineyard among other things I led the team that handled the migration of all customers from the EngineYard private cloud to AWS and the Terramark cloud.

---

## Get started!

To get started simply email me at [will@willj.net](mailto:will@willj.net?subject=Interested%20in%20hiring%20you). I usually kick things off by setting up a 45 minute call to go through requirements and to make sure that I can help you before sending a contract.

---

## Rates and Billing

Most of this is negotiable, but the basics of hiring me are as follows.

- My current basic rate is $300 USD/hour or local equivalent based on the exchange rate at the time.

- For longer term and retained contracts I will discount.

- I can bill in most currencies and to most countries.

- I invoice every two weeks.

- If you are in the UK or EU there will be VAT added.

---

## Miscellanea

- **Working with companies in non-UK timezones is not a problem**, I have worked extensively with US companies coast to coast, Europe, and also New Zealand.
- I primarily work remotely, however:-
	- Where desired I will travel to meet and work with your team for short to medium periods, expenses such as travel and accomodation will be covered by you.
	- I am happy to travel internationally on the same terms.
