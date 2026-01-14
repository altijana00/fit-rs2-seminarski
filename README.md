# ZenYogaApp

ZenYogaApp is the application made for yoga studios and participants to make joining classses easier.

**Application is consisted of:**
- Desktop application - used by administrators to manage the whole system, staff members to manage studios and classes. 
- Mobile application - used by participants to search studios and join classes.

Studio membership payments are implemented using a Stripe payment system (https://stripe.com/), and some of the test cards can be found on: https://stripe.com/docs/testing

**How to start**

- Clone repository
- Locate docker-compose.yml file
- run `docker-compose build` command
- run `docker-compose up` command


**Login credentials:**
```
Administrator - Desktop:

Email: admin@edu.fit.ba
Password: test

Staff - Desktop:

Email: owner@edu.fit.ba
Password: test

Email: instructor@edu.fit.ba
Password: test

Participant - Mobile:

Email: participant@edu.fit.ba
Password: test
```
