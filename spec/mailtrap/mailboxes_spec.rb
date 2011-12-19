require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), %w[ .. .. lib mailtrap log_parser ])
require File.join(File.dirname(__FILE__), %w[ .. .. lib mailtrap mailboxes ])

LOG_DIR ||= File.join(File.dirname(__FILE__), 'sample_logs')
SAMPLE_LOG_FILENAME ||= File.join(LOG_DIR, 'sample.log')
SAMPLE_EMPTY_LOG_FILENAME ||= File.join(LOG_DIR, 'sample_empty.log')

describe Mailtrap::Mailboxes do
  it "should handle an empty file" do
    mailboxes = Mailtrap::Mailboxes.new(SAMPLE_EMPTY_LOG_FILENAME)
    mailboxes.accounts.should be_instance_of Array
    mailboxes.accounts.should be_empty
  end
  
  it "should extract three accounts from the sample log file" do
    mailboxes = Mailtrap::Mailboxes.new(SAMPLE_LOG_FILENAME)
    mailboxes.accounts.should be_instance_of Array
    mailboxes.accounts.should have(3).elements
    mailboxes.accounts[0].should == 'recipient@test.com'
    mailboxes.accounts[1].should == 'bear@zoo.com'
    mailboxes.accounts[2].should == 'giraffe@zoo.com'
  end
  
  it "should extract instances of Mail::Message from mailboxes" do
    mailboxes = Mailtrap::Mailboxes.new(SAMPLE_LOG_FILENAME)
    recip_mail = mailboxes.get('recipient@test.com')
    recip_mail.should be_instance_of Mail::Message
  end

  it "should extract mail for recipient from each mailbox" do
    mailboxes = Mailtrap::Mailboxes.new(SAMPLE_LOG_FILENAME)
    recip_mail = mailboxes.get('recipient@test.com')
    bear_mail = mailboxes.get('bear@zoo.com')
    giraffe_mail = mailboxes.get('giraffe@zoo.com')

    recip_mail.destinations.should == %w[ recipient@test.com ]
    bear_mail.destinations.should == %w[ bear@zoo.com giraffe@zoo.com ]
    giraffe_mail.destinations.should == %w[ bear@zoo.com giraffe@zoo.com ]
    
    recip_mail.body.should include("Body content A")
    bear_mail.body.should include("Body content B")
    giraffe_mail.body.should include("Body content B")

    mailboxes.get('recipient@test.com').should be_nil
    mailboxes.get('bear@zoo.com').should be_nil
    mailboxes.get('giraffe@zoo.com').should be_nil
    mailboxes.get('no-one@test.com').should be_nil
  end
  
  it "should return new messages that arrive even after it has been opened" do
    pending
  end
end
