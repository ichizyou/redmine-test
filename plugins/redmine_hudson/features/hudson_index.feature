Feature: index
  show hudson jobs with latest build results

  Background: 
    Given Project "eCookbook" uses "Hudson" Plugin
      And "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
        | Edit Hudson settings|
        | Build Hudson        |
      And I am logged in as "dlopper" with password "foo"

    Given HudsonApi.get_job_list returns "simple/hudson_job-list"
     And  HudsonApi.get_job_details returns "simple/hudson_job-details"
     And  HudsonApi.get_build_results returns "simple/job_simple-ruby-application_build_results"

    When  I go to HudsonSettings at "eCookbook" Project
     And  I fill in "http://localhost:8080" for "settings[url]"
     And  I click "Save"
     And  I check "simple-ruby-application"
     And  I click "Save"

  Scenario: Plugin can show job full details
    When  I go to Hudson at "eCookbook" Project
    Then  I should see "simple-ruby-application" within "h3#job-name-1"
     And  I should see job description of "simple-ruby-application":
      """
      here is simple ruby application description.
      this line is multi line test.
      """
     And  I should see latest build of "simple-ruby-application":
      | number | result  | finished at         |
      | 3      | SUCCESS | 2009/07/19 20:33:35 |
     And  I should see health reports of "simple-ruby-application":
      | description                                                |
      | 安定したビルド: 最近の5個中、2個ビルドに失敗しました。 59% |
      | Rcov coverage: Code coverage 70.0%(70.0) 87%               |

  @current
  Scenario: Plugin can show hudson image on background
    Given HudsonApi.ci_server_name returns hudson
    When  I go to Hudson at "eCookbook" Project
    Then  Background image is "http://localhost:8080/images/hudson.png"

  @current
  Scenario: Plugin can show jenkins image on background
    Given HudsonApi.ci_server_name returns jenkins 
    When  I go to Hudson at "eCookbook" Project
    Then  Background image is "http://localhost:8080/images/jenkins.png"

  @javascript
  Scenario: click package icon, plugin show build artifacts
    When  I go to Hudson at "eCookbook" Project
    When  I click "Show Build Artifacts" icon of "simple-ruby-application"
    Then  I should see artifacts of "simple-ruby-application":
      | item   | url |
      | app    | http://localhost:8080/job/simple-ruby-application/3/artifact/SimpleRubyApplication/source/app.rb |
      | readme | http://localhost:8080/job/simple-ruby-application/3/artifact/SimpleRubyApplication/readme.rdoc |

  @javascript
  Scenario: click document icon, plugin show build history
    Given HudsonApi.get_recent_builds returns "simple/job_simple-ruby-application_rssAll"
    When  I go to Hudson at "eCookbook" Project
    Then  I should see "simple-ruby-application" within "h3#job-name-1"
    When  I click "Show Build History" icon of "simple-ruby-application"
    Then  I should see build history:
      | number | result  | published at |
      | #3     | SUCCESS | 2009/07/20 21:35:15 |
      | #2     | SUCCESS | 2009/07/19 20:35:15 |
      | #1     | FAILURE | 2009/07/19 19:13:15 | 

  @javascript
  Scenario: click build icon, plugin request build and show result
    Given HudsonApi.request_build returns "simple/job_simple-ruby-application_build_result" 
    When  I go to Hudson at "eCookbook" Project
    When  I click "Build Now" icon of "simple-ruby-application"
    Then  I should see "Build Accepted. - simple-ruby-application" within "#info"
     
