# Task_app


* Ruby version

  -Ruby '2.6.5'

  -Rails '5.2.4'

  -PostgreSQL

* Heroku deploy

  `$ rails assets:precompile RAILS_ENV=production`

  `$ git add -A`

  `$ git commit -m "init"`

  `$ heroku create`

  `$ git push heroku master`

  `$ heroku run rails db:migrate`

* Table

| user     | label   | task    |
| -------- | ------- | ------- |
| id       | id      | id      |
| name     | user_id | task_id |
| email    |         | title   |
| passward |         | content |
