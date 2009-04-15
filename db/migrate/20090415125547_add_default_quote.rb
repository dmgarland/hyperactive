class AddDefaultQuote < ActiveRecord::Migration
  def self.up
    q = Quote.new(:body => "The giant communication media -- the great monsters of the television industry, the communication satellites, magazines and newspapers -- seem determined to present a virtual world, created in the image of what the globalization process requires.")
    q.save!
    
    q = Quote.new(:body => "The world of contemporay news is a world that exists for the VIP's -- the very important people, the major movie stars and big politicians. Their everyday lives are what is important: if they get married, if they divorce, if they eat, what clothes they wear and what clothes they take off. But common people only figure in the news for a moment -- when they kill someone, or when they die.")
    q.save!

    q = Quote.new(:body => "For the communication giants and the neoliberal powers, the others, the excluded, only exist when they are dead, or when they are in jail or court. This can't go on. Sooner or later this virtual world clashes with the real world. And that is actually happening: this clash results in rebellion and war throughout the entire world, or what is left of the world to even have war.")
    q.save!

    q = Quote.new(:body => "The work of independent media is to tell the history of social struggle in the world. Here in Norrth America –The United States, Canada, and Mexico- independent media has, on ocassion, been able to open spaces even within the mass media monopolies, to force them to acknowledge news of social movements.")
    q.save!

    q = Quote.new(:body => "The problem is not only to know what is occurring in the world, but to understand it and derive lessons from it, just as if we were studying, not of the past but of what is happening at any given moment in whateever part of the world. This is the way to learn who we are, what is what we want, who we can be, and what we can do or not do.")
    q.save!

    q = Quote.new(:body => "By not having to answer to the monster media monopolies, the independent media has a life's work, a political project, and a purpose: to let the truth be known.")
    q.save!

    q = Quote.new(:body => "In August 1996 we called for the creation of a network of independent media, a network of information. We mean a network to resist the power of the lie that sells us this war that we call World War IV. We need this network not only as a tool for our social movements but for our lives: this is a project for life, for a humanity that has a right to critical and truthful information.")
    q.save!
  end

  def self.down
  end
end
