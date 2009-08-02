# OtherMedia is basically a really chopped-down Article.
#
# People are always browsing the web and they think "wow, this article i'm
# reading on the bbc is really great, i better let everybody on Indymedia know
# about it."
#
# So they write an "article" like:
# 'Hey u shld all chek out this article on the bbc, it relly proves how
# capitalism sux', with a url.  Ten seconds later, they're Indymedia
# contributors.
#
# The "OtherMedia" content type is designed to take this stuff out of the
# newswire and put it in its own subtype, so that the newswire
# (which contains articles which people actually put work into)
# doesn't get clogged up with this sort of crap.
#
class OtherMedia < Content

  validates_presence_of :source
  validates_uri_existence_of :source

  # OtherMedia have no photos at all, so they never have a thumbnail.
  #
  def has_thumbnail?
    false
  end

end

