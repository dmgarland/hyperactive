# ROR SubList Plugin
# Luke Galea - galeal@ideaforge.org
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

require 'action_pack'

module UIEnhancements
  module SubList
  
	  def self.included(mod)
	    mod.extend(ClassMethods)
	  end
	  
	  module ClassMethods
	   def sub_list( model = 'Note', parent = 'incomplete', parent_subclass = nil )
	     instance_eval do
            model = model.to_s.tableize.singularize
            model_class = model.to_s.camelize.constantize
            models = model.pluralize
            
            define_method("initialize_#{models}") do
              success = true
              parent_obj = eval "@#{parent}"
              model_list = parent_obj.send( models )

              return success if params[model].nil?
              
              params[model].sort.each do |id, values|
                obj = send( "find_#{model}", id )
                if obj.nil?
                  obj = model_class.new( values )
                  if parent_subclass.nil?
                    obj.send( "#{parent}=", parent_obj )
                  else
                    obj.send( "#{parent_subclass}=", parent_obj )
                  end
                  model_list << obj
                else
                  obj = model_list.select { |item| item == obj }.first
                  success = obj.update_attributes( values )
                end
              end
              model_list.select { |item| item.id.nil? }.each { |null_item| null_item.id = rand(100000)}
              
              success
            end
            
            define_method("prepare_#{models}") do
              (eval "@#{parent}").send( models ).select { |item| item.id.nil? }.each { |null_item| null_item.id = Time.now.to_i }
            end
            
            define_method "add_#{model}" do
              new_obj = model_class.new()
              new_obj.id = Time.now.to_i #this won't actually be used as the id
              yield new_obj #opportunity to setup the new item              
              render :partial => model, :locals => { model.to_sym => new_obj }
            end
            
            define_method "remove_#{model}"  do
              obj = send( "find_#{model}", params[:id] )
              if ! obj.nil?
                obj.destroy #This is not a new note but an old one..actually delete it
              end
              render :text => ''
            end
            
            define_method "find_#{model}" do | id |
              begin
                return model_class.find( id )
              rescue ActiveRecord::RecordNotFound
                return nil
              end
            end
            
            protected "find_#{model}"      	      
            #protected "update_or_create_#{models}"
            
          end #end of instance_eval
        end #end of sublist	 function 
	  end #end of module Classmethods
	  
  end #end of sublist module
end #end of ui enhanacements module