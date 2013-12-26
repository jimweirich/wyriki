Feature: Creating a Wiki
  In order to promote communication

  Scenario:
    Given I am an admin
    And I am on the "root" page
    When I create a new wiki named "Newwiki" with "HomePage"
    Then page should have notice message "Wiki Newwiki created."
    Then page should have "Newwiki" in the list of wikis

  Scenario:
    Given a base wiki
    And I am a writer
    And I am on the home page of "Base"
    When I click on an undefined page
    Then I am taken to the create new page

  Scenario:
    Given a base wiki
    And I am a reader
    And I am on the home page of "Base"
    Then there is no option to create a new page
