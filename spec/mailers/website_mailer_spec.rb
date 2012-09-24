require "spec_helper"

describe WebsiteMailer do
  describe "contact_form" do
    let(:mail) { WebsiteMailer.contact_form }

    it "renders the headers" do
      mail.subject.should eq("Contact form")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
