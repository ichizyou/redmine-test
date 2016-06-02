# $Id$
Feature: index
  show hudson jobs with latest build results

  Background: 
    Given Project "eCookbook" uses "Hudson" Plugin
      And "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
        | Edit Hudson settings|
      And I am logged in as "dlopper" with password "foo"

  Scenario: If project has no Hudson settings, plugin show message
    When I go to Hudson at "eCookbook" Project
    Then I should see "No settings for this project. Please confirm settings"

    When I click "confirm settings"
    Then I should see "Settings"

    When I fill in "http://localhost:8080" for "settings[url]"
     And I click "Save"
    Then the field named "settings[url]" should contain "http://localhost:8080/"

    When I go to Hudson at "eCookbook" Project
    Then I should see "No Jobs"

