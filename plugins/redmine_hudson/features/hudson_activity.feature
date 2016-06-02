Feature: project activity 
  show hudson build results on activity

  @javascript @current
  Scenario: Show build results on activity
    Given "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
     And  Project "eCookbook" uses modules below:
        | name       |
        | Hudson     |
     And  "eCookbook" project has jobs:
        | name                    |
        | simple-ruby-application |
     And  Job "simple-ruby-application" has build results:
        | number | result  | finished_at | building | error | caused_by | revisions |
        | 5      | SUCCESS | #today      | false    |       | 1         | 2         |
      And I am logged in as "dlopper" with password "foo"
    When I go to ProjectActivity at "eCookbook" Project
     And I check "Hudson" Activity
     And I click "Apply"
    Then I should see build results in Activity:
        | activity                                 | activity url                                        | activity detail | activity author |
        | Build simple-ruby-application 5: SUCCESS | http://localhost:8080/job/simple-ruby-application/5 | Changesets: r2  | redMine Admin   |
