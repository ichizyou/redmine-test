Feature: issue
  show hudson build results on issue

  @javascript
  Scenario: Show job simple-ruby-application
    Given Project "eCookbook" uses modules below:
        | name       |
        | Hudson     |
      And Issue #1 is related to revisions "2"
      And "eCookbook" project has jobs:
        | name                    |
        | simple-ruby-application |
      And Job "simple-ruby-application" has build results:
        | number | result  | finished_at | building | error | caused_by | revisions |
        | 5      | SUCCESS | #today      | false    |       | 1         | 2         |
      And I am logged in as "dlopper" with password "foo"
    When I show issue #1
    When save the page
    Then I should see build results in Associated revisions:
        | revision | job name                | build number | build result  | build url                                           | finished at        |
        | 2        | simple-ruby-application | 5            | SUCCESS       | http://localhost:8080/job/simple-ruby-application/5 | less than a minute |
