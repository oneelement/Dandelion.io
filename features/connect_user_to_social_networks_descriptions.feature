Feature: Social network integration

    So that some CRM information can be populated automatically
    As a CRM user
    I want to be able to link my profile to various social networks

    @omniauth
    Scenario: Connect account with linkedin
        Given I'm logged in
        When I visit the user profile
        And press the "linkedin" authentication connection button
        Then the page should say "Authentication successful"
        And the "linkedin" authentication should appear as connected
