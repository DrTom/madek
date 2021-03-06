Feature: Visualization / Graph

  As a MAdeK user
  I want a tool that is visualizing the realtionships between media resources
  So that I understand structures better

  Background: Load the example data and personas
    Given personas are loaded

  @javascript
  Scenario: Calculate graph on the media set view
    Given I am "Normin"
    When I open a set that has children and parents
     And I use the "show graph" context action
    Then I can see the relations for that resource

  @javascript
  Scenario: Calculate graph on the media entry view
    Given I am "Normin"
    When I open a media entry that is child of a set that I can see
     And I use the "show graph" context action
    Then I can see the relations for that resource

  @javascript
  Scenario: Calculate graph on a filtered list
    Given I am "Normin"
    Given I see a filtered list of resources where at least one element has arcs
     And I use the "show graph" context action
    Then I can see the relations for that resources

  @poltergeist
  Scenario: Browser Switcher
    Given I am "Normin"
      And There are no persisted visualizations
      And I don't use Chrome or Safari
     When I open the visualization with the hash-tag test_noupdate_positions
      And The visualization test test_noupdate_positions is running 
     Then I see the graph after it has finished layouting/computing
      And I don't see "Test failed"

  @poltergeist
  Scenario: Popup for a set
    Given I am "Normin"
     When I visit the visualization of "my_media_resources"
      And I inspect a media set node more closely
     Then I see a popup
      And I see the title of that resource
      And I see the permission icon for that resource
      And I see the favorite status for that resource
      And I see the number of children devided by media entry and media set
      And I see the links to the resource, (my-)descendants, and (my)components

  @poltergeist 
  Scenario: Popup for a media entry
    Given I am "Normin"
     When I visit the visualization of "my_media_resources"
      And I inspect a media entry node more closely
      Then I see a popup
      And I see the title of that resource
      And I see the permission icon for that resource
      And I see the favorite status for that resource
      And I dont see any number of children and parents
      And I see the links to the resource (my)components
      And I don't see the links to the resource (my)descendants

  @poltergeist
  Scenario: Title
    Given I am "Normin"
     When I a see a graph
     Then I see a title
     When I visualize the filter "Meine Sets"
     Then I see the title "Meine Sets"
     When I visualize the filter "Meine Inhalte"
     Then I see the title "Meine Inhalte"
     When I visualize the filter "Mir anvertraute Inhalte"
     Then I see the title "Mir anvertraute Inhalte"
     When I visualize the filter "Meine Favoriten"
     Then I see the title "Favoriten"
     When I visualize the filter Suchergebnisse für "ZHdK"
     Then I see the title Suchergebnisse für "ZHdK"

  @poltergeist
  Scenario: Origin Highlight
    Given I am "Normin"
     When I visualize the descendants of a Set
     Then I see the originating set beeing highlighted
     And I see the title of the set as graph-title
     When I visualize the component of a Entry
     Then I see the originating entry beeing highlighted
     And I see the title of the entry as graph-title

  @poltergeist
  Scenario: Default labels
    Given I am "Normin"
     And  There are no persisted visualizations
     When I a see the graph of the resource "my_media_resources"
     Then the label option "sets_having_descendants" is selected 
     Then I see by default exactly the labels of the sets that have children in the current visualization

  @poltergeist
  Scenario: Selecting option all labels
    Given I am "Normin"
     And  There are no persisted visualizations
     When I a see the graph of the resource "my_media_resources"
     When I select "alle" of the label select options 
     Then I see that all labels are show 

  @poltergeist
  Scenario: Selecting non labels
    Given I am "Normin"
     And  There are no persisted visualizations
     When I a see the graph of the resource "my_media_resources"
     When I select "keine" of the label select options 
     Then I see that none labels are show 

