Feature: As a webapp developer
  I need to test use-cases that send mail to users
  And I don't want to send real mail to real people

  Scenario: Write mail to a static log file
    Given Mailtrap is not started
    And I start mailtrap with default options
    And my test is configured to send mail to the mailtrap server
    When my test sends several messages
    Then Those messages should be found in the default log file

  Scenario: Write mail to a pipe
    Given Mailtrap is not started
    And I start mailtrap and tell it to write to a fifo
    And my test is configured to send mail to the mailtrap server
    When my test sends several messages
    Then those messages can be read from the fifo
    And my test can send and read more messages
