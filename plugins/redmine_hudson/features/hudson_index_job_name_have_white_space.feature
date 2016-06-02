# $Id$
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

    Given HudsonApi.get_job_list returns "have_white_space/hudson_job-list"
     And  HudsonApi.get_job_details returns "have_white_space/hudson_job-details"
     And  HudsonApi.get_build_results returns "have_white_space/job_have_white_space_build_results"

    When  I go to HudsonSettings at "eCookbook" Project
     And  I fill in "http://localhost:8080" for "settings[url]"
     And  I click "Save"
     And  I check "have white space"
     And  I click "Save"

  Scenario: Plugin can show job full details
    When  I go to Hudson at "eCookbook" Project
    Then  I should see "have white space" within "h3#job-name-1"
     And  I should see job description of "have white space":
      """
      this job name has white space
      """
     And  I should see latest build of "have white space":
      | number | result  | finished at         |
      | 1      | SUCCESS | 2009/07/19 20:33:35 |

  @javascript
  Scenario: click package icon, plugin show build artifacts
    When  I go to Hudson at "eCookbook" Project
    When  I click "Show Build Artifacts" icon of "have white space"
    Then  I should see artifacts of "have white space":
      | item   | url |
      | app    | http://localhost:8080/job/have%20white%20space/1/artifact/HaveWhiteSpace/source/app.rb |
      | readme | http://localhost:8080/job/have%20white%20space/1/artifact/HaveWhiteSpace/readme.rdoc |

  @javascript
  Scenario: click document icon, plugin show build history
    Given HudsonApi.get_recent_builds returns "have_white_space/job_have_white_space_rssAll"
    When  I go to Hudson at "eCookbook" Project
    Then  I should see "have white space" within "h3#job-name-1"
    When  I click "Show Build History" icon of "have white space"
    Then  I should see build history:
      | number | result  | published at |
      | #1     | SUCCESS | 2009/07/20 21:35:15 |

  @javascript
  Scenario: click build icon, plugin request build and show result
    Given HudsonApi.request_build returns "have_white_space/job_have_white_space_build_result" 
    When  I go to Hudson at "eCookbook" Project
    When  I click "Build Now" icon of "have white space"
    Then  I should see "Build Accepted. - have white space" within "#info"
     
