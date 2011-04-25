#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
require 'efl/ecore'
require 'efl/ecore_getopt'
#
describe Efl::EcoreGetopt do
    #
    before(:each) do
        Efl::Ecore.init
        #
        @p = Efl::EcoreGetopt::Parser.new :prog =>"Prog", :usage => "Usage", :version => "0.0.0", :copyright => "less", :license => "MIT", :description => "description", :strict => 1
        def @p.cb parser, desc, string, data, value
            puts parser, desc, string, data, value
            true
        end
        #
        @values = {
            :license => FFI::MemoryPointer.new(:uchar),
            :copyright => FFI::MemoryPointer.new(:uchar),
            :version => FFI::MemoryPointer.new(:uchar),
            :help => FFI::MemoryPointer.new(:uchar),
            :int => FFI::MemoryPointer.new(:int),
            :double => FFI::MemoryPointer.new(:double),
            :short => FFI::MemoryPointer.new(:short),
            :long => FFI::MemoryPointer.new(:long),
            :true => FFI::MemoryPointer.new(:uchar),
            :false => FFI::MemoryPointer.new(:uchar),
            :choice => FFI::MemoryPointer.new(:pointer),
            :count => FFI::MemoryPointer.new(:int),
            :callback => FFI::MemoryPointer.new(:int),
        }
        [ :license, :copyright, :version, :help ].each do |sym|
            @values[sym].write_char 0
        end
        @values[:int].write_int 0
        @values[:double].write_double 3.1415926
        @values[:short].write_short 9
        @values[:long].write_long 666
        @values[:true].write_uchar 1
        @values[:false].write_uchar 0
        @values[:choice].write_pointer FFI::Pointer::NULL
        @values[:count].write_int 664
        @values[:callback].write_int 9
        @meta = FFI::MemoryPointer.from_string "My pretty metadata"
        @cb_data = FFI::MemoryPointer.from_string "cb data"
        #
        @p.license 'L', 'license'
        @p.value :boolp, @values[:license]
        @p.copyright 'C', 'copyright'
        @p.value :boolp, @values[:copyright]
        @p.version 'V', 'version'
        @p.value :boolp, @values[:version]
        @p.help 'H', 'help'
        @p.value :boolp, @values[:help]
        @p.store_type :int, 'i', 'int', 'store an integer'
        @p.value :intp, @values[:int]
        @p.store_meta_type :double, 'd', 'double', 'store an double+meta', @meta
        @p.value :doublep, @values[:double]
        @p.store_def_type :short, 's', 'short', 'store an short+default', 6
        @p.value :shortp, @values[:short]
        @p.store_full_type :long, 'l', 'long', 'store a long+full', @meta, :ecore_getopt_desc_arg_requirement_yes, 666
        @p.value :longp, @values[:long]
        @p.store_const 'c', 'const', 'store a constant', 123456
        @p.value :longp, @values[:long]
        @p.store_true 't', 'true', 'store true'
        @p.value :boolp, @values[:false]
        @p.store_false 'f', 'false', 'store false'
        @p.value :boolp, @values[:true]
        @p.choice 'm', 'many', 'store choice', ['ch1','ch2','ch3']
        @p.value :strp, @values[:choice]
        # FIXME: uses listp with Eina_List
#        @p.append 'a', 'append', 'store append', :ecore_getopt_type_int
        @p.count 'k', 'count', 'store count'
        @p.value :intp, @values[:count]
        # FIXME breaks --long ??
#        @p.callback_args 'b', 'callback', 'callback full', @meta, @p.method(:cb), @cb_data
#        @p.value :intp, @values[:callback]
        @p.create
#        puts @p.debug
        #
    end
    #
    describe "license copyright version help" do
        it "should handle -L" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["My lovely prog name","-L"]
            @values[:license].read_char.should eql 1
            [ :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle --license" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["My lovely prog name","--license"]
            @values[:license].read_char.should eql 1
            [ :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle -C" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["progname","-C"]
            @values[:copyright].read_char.should eql 1
            [ :license, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle --copyright" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["My lovely prog name","--copyright"]
            @values[:copyright].read_char.should eql 1
            [ :license, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle -V" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["My lovely prog name","-V"]
            @values[:version].read_char.should eql 1
            [ :license, :copyright, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle --version" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["progname","--version"]
            @values[:version].read_char.should eql 1
            [ :license, :copyright, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle -H" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["My lovely prog name","-H"]
            @values[:help].read_char.should eql 1
            [ :license, :copyright, :version ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
        it "should handle --help" do
            #
            [ :license, :copyright, :version, :help ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            args = @p.parse ["progname","--help"]
            @values[:help].read_char.should eql 1
            [ :license, :copyright, :version ].each do |sym|
                @values[sym].read_char.should eql 0
            end
            Efl::Ecore.shutdown
        end
    end
    describe "simple options" do
        it "should handle -i" do
            #
            @values[:int].read_int.should eql 0
            args = @p.parse ["progname","-i 666"]
            @values[:int].read_int.should eql 666
            Efl::Ecore.shutdown
        end
        it "should handle --int" do
            #
            @values[:int].read_int.should eql 0
            args = @p.parse ["progname","--int=666"]
            @values[:int].read_int.should eql 666
            Efl::Ecore.shutdown
        end
        it "should handle -d" do
            #
            @values[:double].read_double.should eql 3.1415926
            args = @p.parse ["progname","-d 6.66"]
            @values[:double].read_double.should eql 6.66
            Efl::Ecore.shutdown
        end
        it "should handle --double" do
            #
            @values[:double].read_double.should eql 3.1415926
            args = @p.parse ["progname","--double=6.66"]
            @values[:double].read_double.should eql 6.66
            Efl::Ecore.shutdown
        end
#        # FIXME : maybe fix ecore
#        it "should handle -s default" do
#            #
#            @values[:short].read_short.should eql 9
#            args = @p.parse ["progname"]
#            @values[:short].read_short.should eql 6
#            Efl::Ecore.shutdown
#        end
        it "should handle -s" do
            #
            @values[:short].read_short.should eql 9
            args = @p.parse ["progname","-s 125"]
            @values[:short].read_short.should eql 125
            Efl::Ecore.shutdown
        end
        it "should handle --short" do
            #
            @values[:short].read_short.should eql 9
            args = @p.parse ["progname","--short=125"]
            @values[:short].read_short.should eql 125
            Efl::Ecore.shutdown
        end
        it "should handle -l" do
            #
            @values[:long].read_long.should eql 666
            args = @p.parse ["progname","-l 69"]
            @values[:long].read_long.should eql 69
            Efl::Ecore.shutdown
        end
        it "should handle --long" do
            #
            @values[:long].read_long.should eql 666
            args = @p.parse ["progname","--long=69"]
            @values[:long].read_long.should eql 69
            Efl::Ecore.shutdown
        end
        it "should handle -c" do
            #
            @values[:long].read_long.should eql 666
            args = @p.parse ["progname","-c"]
            @values[:long].read_long.should eql 123456
            Efl::Ecore.shutdown
        end
        it "should handle --const" do
            #
            @values[:long].read_long.should eql 666
            args = @p.parse ["progname","--const"]
            @values[:long].read_long.should eql 123456
            Efl::Ecore.shutdown
        end
        it "should handle -t" do
            #
            @values[:false].read_uchar.should eql 0
            args = @p.parse ["progname","-t"]
            @values[:false].read_uchar.should eql 1
            Efl::Ecore.shutdown
        end
        it "should handle --true" do
            #
            @values[:false].read_uchar.should eql 0
            args = @p.parse ["progname","--true"]
            @values[:false].read_uchar.should eql 1
            Efl::Ecore.shutdown
        end
        it "should handle -f" do
            #
            @values[:true].read_uchar.should eql 1
            args = @p.parse ["progname","-f"]
            @values[:true].read_uchar.should eql 0
            Efl::Ecore.shutdown
        end
        it "should handle --false" do
            #
            @values[:true].read_uchar.should eql 1
            args = @p.parse ["progname","--false"]
            @values[:true].read_uchar.should eql 0
            Efl::Ecore.shutdown
        end
        it "should handle -m" do
            #
            @values[:choice].read_pointer.should eql FFI::Pointer::NULL
            args = @p.parse ["progname","-mch2"]
            @values[:choice].read_pointer.read_string.should eql "ch2"
            Efl::Ecore.shutdown
        end
        it "should handle --many" do
            #
            @values[:choice].read_pointer.should eql FFI::Pointer::NULL
            args = @p.parse ["progname","--many=ch3"]
            @values[:choice].read_pointer.read_string.should eql "ch3"
            Efl::Ecore.shutdown
        end
        it "should handle -k" do
            #
            @values[:count].read_int.should eql 664
            args = @p.parse ["progname","-kk"]
            @values[:count].read_int.should eql 666
            Efl::Ecore.shutdown
        end
        it "should handle --count" do
            #
            @values[:count].read_int.should eql 664
            args = @p.parse ["progname","--count","--count"]
            @values[:count].read_int.should eql 666
            Efl::Ecore.shutdown
        end
    end
end
