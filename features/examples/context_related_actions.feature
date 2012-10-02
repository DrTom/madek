Feature: Login

  As a MAdeK user

  Background: Load the example data and personas
    Given personas are loaded
      And I am "Normin"

  @javascript
  Scenario: Context actions on the set detail view
    When I open a set that I can edit which has children
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | edit |
    | favorite |
    | permissions |
    | add to set |
    | set highlight |
    #| set cover |
    #| save display settings |
    | create set |
    | delete |

  @javascript
  Scenario: Context actions on the media entry detail view
    When I open one of my resources
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | edit |
    | favorite |
    | browse |
    | permissions |
    | add to set |
    | export |
    | create set |
    | delete |

  # https://www.pivotaltracker.com/story/show/33961905
  @javascript
  Scenario: Context actions on the search result page
    When I see some search results
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | import |
    | create set |
    | create filter set |

  Scenario: Context actions on the filter set detail view
    When I open a filter set that I can edit which has children
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | edit |
    | favorite |
    | permissions |
    | add to set |
    | save display settings |
    | create set |
    | delete |

  @javascript
  Scenario: Context actions on the group page
    When I click the arrow next to my name
     And I follow "Meine Arbeitsgruppen"
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | create group |

  @javascript
  Scenario: Context actions on the favorite view
    When I click the arrow next to my name
     And I follow "Meine Favoriten"
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | create set |
    | import |

  @javascript
  Scenario: Context actions on the my media entries view
    When I click the arrow next to my name
     And I follow "Meine Medieneinträge"
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | create set |
    | import |

  @javascript
  Scenario: Context actions on the my sets view
    When I click the arrow next to my name
     And I follow "Meine Sets"
    Then I can open the context actions drop down and see the following actions in the following order:
    | action |
    | create set |
    | import |
    
    
