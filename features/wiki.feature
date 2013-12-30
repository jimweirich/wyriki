Feature: Managing Wikis
  In order to promote communication

  Scenario:
    Given I am an admin
    And I am on the "root" page
    When I create a new wiki named "Newwiki" with "HomePage"
    Then page should have notice message "Wiki Newwiki created."
    Then page should have "Newwiki" in the list of wikis

  Scenario:
    Given I am an admin
    And a base wiki
    And I am on the "root" page
    And I create a new wiki named "Newwiki" with "HomePage"
    When I delete a wiki named "Newwiki"
    Then page should have notice message "Newwiki Base deleted"
    Then page should not have "Newwiki" in the list of wikis