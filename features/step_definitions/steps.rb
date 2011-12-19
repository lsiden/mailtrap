Given /^Mailtrap is not started$/ do
  system("bin/mailtrap stop").should_not be_nil
end

Given /^I start mailtrap with default options$/ do
  system("bin/mailtrap start").should be_true
end

Given /^my test is configured to send mail to the mailtrap server$/ do
  pending # express the regexp above with the code you wish you had
end

When /^my test sends several messages$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^Those messages should be found in the default log file$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^that I start mailtrap and tell it to write to a fifo$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^those messages can be read from the fifo$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^my test can send and read more messages$/ do
  pending # express the regexp above with the code you wish you had
end
