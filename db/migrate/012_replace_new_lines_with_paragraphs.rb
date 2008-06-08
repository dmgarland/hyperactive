class ReplaceNewLinesWithParagraphs < ActiveRecord::Migration
  def self.up
    content = Content.find(:all)
    content.each do |c|
      puts c.title
      unless c.body.nil?
        c.body.gsub!(/\r\n?/, "\n")
        c.body = "<p>" + c.body.gsub(/\n\n+/, "</p>\n\n<p>").gsub(/([^\n]\n)(?=[^\n])/, '\1<br />') + "</p>"
      end
      unless c.summary.nil?
        c.summary.gsub!(/\r\n?/, "\n")
        c.summary = "<p>" + c.summary.gsub(/\n\n+/, "</p>\n\n<p>").gsub(/([^\n]\n)(?=[^\n])/, '\1<br />') + "</p>"
      end
      if c.valid?
        c.save!
      end
    end
  end

  def self.down
  end
end
