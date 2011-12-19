require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), %w[ .. .. lib mailtrap log_parser ])

LOG_DIR ||= File.join(File.dirname(__FILE__), 'sample_logs')
SAMPLE_LOG_FILENAME ||= File.join(LOG_DIR, 'sample.log')
SAMPLE_EMPTY_LOG_FILENAME ||= File.join(LOG_DIR, 'sample_empty.log')
READ_WRITE_LOG_FILENAME ||= File.join(LOG_DIR, 'read_write.log')

describe Mailtrap::LogParser do
  it "should extract two emails from the sample log file" do
    emails = Mailtrap::LogParser.parse(SAMPLE_LOG_FILENAME)
    emails.should be_instance_of Array
    emails.should have(2).elements
  end
  
  it "should extract the details of each email" do
    emails = Mailtrap::LogParser.parse(SAMPLE_LOG_FILENAME)
    
    # let's just enough of TMail to know it's doing something useful...
    emails[0].destinations.should == %w[ recipient@test.com ]
    emails[1].destinations.should == %w[ bear@zoo.com giraffe@zoo.com ]
    
    emails[0].body.should include("Body content A")
    emails[1].body.should include("Body content B")
  end
  
  it "should not include the message boundary lines" do
    emails = Mailtrap::LogParser.parse(SAMPLE_LOG_FILENAME)
    
    emails[0].body.should_not include("* Message begins")
    emails[0].body.should_not include("* Message ends")
    
    emails[1].body.should_not include("* Message begins")
    emails[1].body.should_not include("* Message ends")
  end
  
  it "should handle an empty file" do
    emails = Mailtrap::LogParser.parse(SAMPLE_EMPTY_LOG_FILENAME)
    emails.should be_empty
  end

  it "should know how to read and write from a pipe" do
    rd, wr = IO.pipe
      File.open(SAMPLE_LOG_FILENAME) do |sample_log|
        wr.write(sample_log.read).should > 0
      end
      text = ''
      begin
        while (text << rd.read_nonblock(4096)) do ; end
      rescue IO::WaitReadable
      end
      lines = text.split("\n")
      lines.should be_instance_of Array;
      lines.should have_at_least(3).elements
  end

  it "should know how to read mail from an IO object" do
    pending
    rd, wr = IO.pipe
      File.open(SAMPLE_LOG_FILENAME) do |sample_log|
        wr.write(sample_log.read).should > 0
      end
      emails = Mailtrap::LogParser.parse(rd)
      emails.should be_instance_of Array
      emails.should have(2).elements
  end
end
