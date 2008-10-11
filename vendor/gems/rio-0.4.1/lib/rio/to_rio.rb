#--
# =============================================================================== 
# Copyright (c) 2005,2006,2007 Christopher Kleckner
# All rights reserved
#
# This file is part of the Rio library for ruby.
#
# Rio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Rio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rio; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# =============================================================================== 
#++
#
# To create the documentation for Rio run the command
#  ruby build_doc.rb
# from the distribution directory.
#
# Suggested Reading
# * RIO::Doc::SYNOPSIS
# * RIO::Doc::INTRO
# * RIO::Doc::HOWTO
# * RIO::Doc::EXAMPLES
# * RIO::Rio
#


module RIO
  module ToRio #:nodoc: all
    module IO
      def to_rio()
        rio(self)
      end
    end
    module Object
      def to_rio()
        rio(self.to_s)
      end
    end
    module String
      include RIO::ToRio::Object
      def /(arg)
        self.to_rio / arg
      end
    end
    module Array
      def /(arg)
        rio(self) / arg
      end
      def to_rio()
        rio(self)
      end
      def to_rios()
        self.map { |path| rio(path) }
      end
    end
  end
end
