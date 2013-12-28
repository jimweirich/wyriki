Feature: Creating a Wiki
  In order to promote communication

  Scenario:
    Given I am an admin
    And I am on the "root" page
    When I create a new wiki named "Newwiki" with "HomePage"
    Then page should have notice message "Wiki Newwiki created."
    Then page should have "Newwiki" in the list of wikis
