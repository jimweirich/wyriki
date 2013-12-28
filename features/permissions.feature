Feature: Creating a Wiki
  In order to protect against unwanted changes,
  the wikis will support reader/writer/admin privilege levels.

  Scenario:
    Given a base wiki
    And I am a writer
    And I am on the home page of "Base"
    When I click on an undefined page
    Then I am taken to the create new page

  Scenario:
    Given a base wiki
    And I am a writer
    And I am on the main page of "Base"
    When I create a new page
    Then I can see the new page

  Scenario:
    Given a base wiki
    And I am a reader
    And I am on the home page of "Base"
    Then there is no option to create a new page

  Scenario:
    Given a base wiki
    And noone is logged in
    And I am on the home page of "Base"
    Then there is no option to create a new page
