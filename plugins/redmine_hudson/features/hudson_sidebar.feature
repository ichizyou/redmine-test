# language: en

Feature: sidebar

  Background: 
    Given Project "eCookbook" uses "Hudson" Plugin
      And "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
        | Edit Hudson settings|
        | Build Hudson        |
      And I am logged in as "dlopper" with password "foo"

    When  I go to HudsonSettings at "eCookbook" Project
     And  I fill in "http://localhost:8080" for "settings[url]"
     And  I click "Save"

  Scenario: Plugin can show links in sidebar
    When  I go to Hudson at "ecookbook" Project 
    Then  I should see links below in sidebar:
      | text     | url                          |
      | Settings | /projects/ecookbook/settings |
      | Server   | http://localhost:8080/       |
