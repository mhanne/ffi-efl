#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
require 'e17/ecore'
#
describe E17::ECORE do
    #
    include E17
    #
    it "should init" do
        ECORE.init.should eql 1
        ECORE.init.should eql 2
        ECORE.init.should eql 3
    end
    #
    it "should shutdown" do
        ECORE.shutdown.should eql 2
        ECORE.shutdown.should eql 1
        ECORE.shutdown.should eql 0
    end
    #
    it "should run a single iteration of the mainloop" do
        ECORE.init
        ECORE.main_loop_iterate
        ECORE.shutdown
    end
    #
    it 'should write and read data from pipe' do
        data = FFI::MemoryPointer.from_string("none")
        cb = Proc.new do |data,buffer,bytes|
            data.read_string.should eql 'none'
            buffer.read_string.should eql 'hello world'
            bytes.should eql 12
        end
        ECORE.init
        pipe = ECORE::EcorePipe.new cb, data
        pipe.write("hello world").should be_true
        ECORE.main_loop_iterate
        pipe.read_close
        pipe.write_close
        pipe.del.address.should eql data.address
        ECORE.shutdown
    end
end
