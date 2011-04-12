#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
require 'e17/eina'
#
describe E17::EINA do
    #
    include E17
    #
    it "should init" do
        EINA.init.should eql 1
        EINA.init.should eql 2
        EINA.init.should eql 3
    end
    #
    it "should shutdown" do
        EINA.shutdown.should eql 2
        EINA.shutdown.should eql 1
        EINA.shutdown.should eql 0
    end
    #
end
