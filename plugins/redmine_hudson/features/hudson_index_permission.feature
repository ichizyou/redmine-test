# $Id$
Feature: index
  show hudson jobs with latest build results

  Scenario: If 'Developer' don't have 'view_hudson' permission, Redmine don't show hudson tab on the menu
    Given Project "eCookbook" uses "Hudson" Plugin
     And  I am logged in as "dlopper" with password "foo"
    When  I go to "eCookbook" Project
    Then  I should not see "Hudson" within "#main-menu"

  Scenario: If 'Developer' have 'view_hudson' permission, Redmine show hudson tab on the menu
    Given Project "eCookbook" uses "Hudson" Plugin
      And "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
        | Edit Hudson settings|
      And I am logged in as "dlopper" with password "foo"
    When I go to "eCookbook" Project
    Then I should see "Hudson" within "#main-menu"
