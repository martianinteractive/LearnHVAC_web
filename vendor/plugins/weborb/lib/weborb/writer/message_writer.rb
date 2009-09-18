# =========================================================================
# message_writer.rb
# Copyright (C) 2006 Midnight Coders, LLC
#
# ruby adaptation, design and implementation: 
#      Harris Reynolds (harris@themidnightcoders.com)
# original design: 
#      Mark Piller (mark@themidnightcoders.com)
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# The software is licensed under the GNU General Public License (GPL)
# For details, see http://www.gnu.org/licenses/gpl.txt.
# =========================================================================

require 'weborb/reader/anonymous'
require 'weborb/reader/named'
require 'weborb/reader/date'
require 'weborb/writer/object_writer'
require 'weborb/v3types/v3message'
require 'weborb/log'
require 'weborb/util'
require 'date'
require 'rexml/document'

class MessageWriter
  
  def MessageWriter.write_object( data_object, formatter )
    #TODO: determine if data_object is "referencable"; if so write out a reference
    write_method = @@writers[data_object.class]
    
    if write_method.nil?
      if Log.debug?
        Log.debug( "write method not found for class: " + data_object.class.name + " writing as a complex object." )
      end
    
      if ClassUtil.in_class_hierarchy(data_object.class, "ActiveRecord::Base")
        MessageWriter.write_active_record( data_object, formatter )
      else
        @@default_writer.write_object( data_object, formatter )
      end
    else
      write_method.call( data_object, formatter )
    end
  end
  
  def MessageWriter.init_writers
    @@default_writer = ObjectWriter.new
    @@writers = Hash.new
    writer_class = Object.const_get :MessageWriter
    
    #number writers
    float_class = Object.const_get :Float
    write_number_method = writer_class.method :write_number
    @@writers.store(float_class, write_number_method)
    fixnum_class = Object.const_get :Fixnum
    @@writers.store(fixnum_class, write_number_method)
    bignum_class = Object.const_get :Bignum
    @@writers.store(bignum_class, write_number_method)
    
    #boolean writers
    true_class = Object.const_get :TrueClass
    write_boolean_method = writer_class.method :write_boolean
    @@writers.store(true_class, write_boolean_method)
    false_class = Object.const_get :FalseClass
    @@writers.store(false_class, write_boolean_method)
    
    #string writer
    string_class = Object.const_get :String
    write_string_method = writer_class.method :write_string
    @@writers.store(string_class, write_string_method)
    
    #nil writer
    nil_class = Object.const_get :NilClass
    write_nil_method = writer_class.method :write_nil
    @@writers.store(nil_class, write_nil_method)
    
    #time writer
    date_time_class = Object.const_get :DateTime
    write_time_method = writer_class.method :write_time
    @@writers.store(date_time_class, write_time_method)
    date_class = Object.const_get :Date
    @@writers.store(date_class, write_time_method)
    time_class = Object.const_get :Time
    @@writers.store(time_class, write_time_method)
    
    #array writer
    array_class = Object.const_get :Array
    write_array_method = writer_class.method :write_array
    @@writers.store(array_class, write_array_method)
    
    #anonymous object writer
    anon_obj_class = Object.const_get :AnonymousObject
    write_anon_obj_method = writer_class.method :write_anonymous_obj
    @@writers.store(anon_obj_class, write_anon_obj_method)
    
    #named object writer
    named_obj_class = Object.const_get :NamedObject
    write_named_obj_method = writer_class.method :write_named_obj
    @@writers.store(named_obj_class, write_named_obj_method)
    
    #body holder writer
    body_holder_class = Object.const_get :BodyHolder
    write_body_holder_method = writer_class.method :write_body_holder
    @@writers.store(body_holder_class, write_body_holder_method)
    
    #hash writer
    hash_class = Object.const_get :Hash
    write_hash_method = writer_class.method :write_hash
    @@writers.store(hash_class, write_hash_method)
    
    #xml writer
    xml_document_class = REXML::Document
    write_xml_method = writer_class.method :write_xml
    @@writers.store(xml_document_class, write_xml_method)
  end
  
  def MessageWriter.write_number( data_object, formatter )
    if data_object.class.name == "Fixnum"
      data_object = data_object.to_f
    end
    
    formatter.write_number( data_object )
  end
  
  def MessageWriter.write_boolean( data_object, formatter )
    formatter.write_boolean( data_object )
  end
  
  def MessageWriter.write_string( data_object, formatter )
    formatter.write_string( data_object )
  end
  
  def MessageWriter.write_xml( data_object, formatter )
    formatter.write_xml( data_object )
  end
  
  def MessageWriter.write_nil( data_object, formatter )
    formatter.write_null
  end
  
  def MessageWriter.write_time( data_object, formatter )
    formatter.write_date( data_object )
  end
  
  def MessageWriter.write_array( data_object, formatter )
    formatter.begin_write_array( data_object.length )
  
    for i in 0...data_object.length
      #NOTE: do we really need to call default_adapt here?  what exactly is the "value" object?
      #MessageWriter.write_object( data_object[i].default_adapt, formatter )
      MessageWriter.write_object( data_object[i], formatter )
    end
    
    formatter.end_write_array
  end
  
  def MessageWriter.write_anonymous_obj( data_object, formatter )
    formatter.write_anonymous_obj( data_object )
  end
  
  def MessageWriter.write_named_obj( data_object, formatter )
    object_name = data_object.object_name
    property_bag = data_object.anonymous_object.properties
    object_serializer = formatter.get_object_serializer
	object_serializer.write_object( object_name, property_bag, formatter )
  end
  
  def MessageWriter.write_body_holder( data_object, formatter )
    body_holder = data_object
    MessageWriter.write_object( body_holder.body, formatter )
  end
  
  def MessageWriter.write_hash( data_object, formatter )
    object_serializer = formatter.get_object_serializer
	object_serializer.write_object( nil, data_object, formatter )
  end
  
  def MessageWriter.write_active_record( data_object, formatter )
    properties = data_object.attributes
    instance_variables = data_object.instance_variables
    instance_variables.each do |instance_variable|
      method_name = instance_variable.delete "@"
      next if(method_name == "attributes" or method_name == "new_record" or method_name == "new_record_before_save" or method_name == "errors" )
      
      if data_object.respond_to?( method_name )
        method = data_object.method method_name
        model_data = method.call
        properties.store( method_name, model_data )
      else
        Log.debug( "active record object does not respond to the method: " + method_name ) if Log.debug?
      end
    end
    
    object_class = data_object.class
    attributes = object_class.get_attributes
	
	attributes.each do |attribute|
	  attr_name = attribute.id2name
	  attr_method = data_object.method attr_name
	  attr_value = attr_method.call
	  properties.store( attr_name, attr_value )
	end

    class_name = data_object.class.name
    server_mappings = WebORBConfig.get_server_mappings
    resolved_name = server_mappings[class_name]
    
    if resolved_name.nil?
      MessageWriter.write_hash( properties, formatter )
    else
      object_serializer = formatter.get_object_serializer
	  object_serializer.write_object( resolved_name, properties, formatter )
    end
  end
end

MessageWriter.init_writers